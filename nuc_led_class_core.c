/*
 * LEDs driver for Intel NUC
 *
 * Copyright (C) 2019 Greg Miell <greg@gothack.ninja>
 *
 * Based on leds-net48xx.c and https://github.com/milesp20/intel_nuc_led
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#include <stddef.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/acpi.h>
#include <acpi/acpi_bus.h>
#include <acpi/acpi_drivers.h>

#include <linux/platform_device.h>
#include <linux/leds.h>
#include <linux/err.h>
#include <linux/io.h>

#include "nuc_led_class_core.h"

static struct platform_device *pdev;

static const char* states[] = {
  "power",
  "hdd",
  "sw",
};

static const char *colors[3][9] = {
  {"off", "blue", "amber", NULL, NULL, NULL, NULL, NULL, NULL, },
  {"off", "blue", "red", "green", "orange", "yellow", "purple", "pink", "white"},
  {"off", "blue", "red", "green", "orange", "yellow", "purple", "pink", "white"},
};

static void __iomem *mem_ptr = NULL;

static struct led_classdev nuc_leds[3];

inline int nuc_led_get_index(struct led_classdev *led_cdev) {
  u8 i;
  for (i = 0; i < 3; i++) {
    if (nuc_leds[i].name == led_cdev->name)
      return i;
  }
  return -1;
}

inline int nuc_led_get_interface(int index, struct nuc_led_interface *iface) {
  void __iomem *ptr = NULL;
  switch(index) {
    case 0:
      iface->status = readb(MEM_PTR_OFFSET(BTNS));
      switch(iface->status) {
        case NUC_LED_PW:
          ptr = MEM_PTR_OFFSET(B0);
          break;
        case NUC_LED_HD:
          ptr = MEM_PTR_OFFSET(BH);
          break;
        case NUC_LED_SW:
          ptr = MEM_PTR_OFFSET(BS);
          break;
      }
      break;
    case 1:
      iface->status = readb(MEM_PTR_OFFSET(RNGS));
      switch(iface->status) {
        case NUC_LED_PW:
          ptr = MEM_PTR_OFFSET(R0);
          break;
        case NUC_LED_HD:
          ptr = MEM_PTR_OFFSET(RH);
          break;
        case NUC_LED_SW:
          ptr = MEM_PTR_OFFSET(RS);
          break;
      }
      break;
    case 2:
      iface->status = readb(MEM_PTR_OFFSET(OBLS));
      switch(iface->status) {
        case NUC_LED_PW:
          ptr = MEM_PTR_OFFSET(O0);
          break;
        case NUC_LED_HD:
          ptr = MEM_PTR_OFFSET(OH);
          break;
        case NUC_LED_SW:
          ptr = MEM_PTR_OFFSET(OS);
          break;
      }
      break;
  }
  if (!ptr) return -1;

  if (iface->status != NUC_LED_HD) {
    iface->BN = ptr + offsetof(struct E2HR_led_normal, BN);
    iface->BH = ptr + offsetof(struct E2HR_led_normal, BH);
    iface->FQ = ptr + offsetof(struct E2HR_led_normal, FQ);
    iface->CR = ptr + offsetof(struct E2HR_led_normal, CR);
  } else {
    iface->BN = ptr + offsetof(struct E2HR_led_hdd, BN);
    iface->BH = ptr + offsetof(struct E2HR_led_hdd, BH);
    iface->FQ = NULL;
    iface->CR = ptr + offsetof(struct E2HR_led_hdd, CR);
  }
  return 0;
}

static void nuc_led_class_brightness_set(
  struct led_classdev *led_cdev,
	enum led_brightness value
) {
  int led = nuc_led_get_index(led_cdev);
  if (led < 0)
    return;
  struct nuc_led_interface iface;
  if (nuc_led_get_interface(led, &iface)) {
    return;
  }
  writeb(value, iface.BN);
}

static enum led_brightness nuc_led_class_brightness_get(struct led_classdev *led_cdev)
{
  u8 value = 0;
  int led = nuc_led_get_index(led_cdev);

  struct nuc_led_interface iface;
  if (nuc_led_get_interface(led, &iface)) {
    return 0;
  }
  value = readb(iface.BN);
  return value;
}

static ssize_t nuc_led_state_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct led_classdev *led_cdev = dev_get_drvdata(dev);
  u8 index = 0;
  int led = nuc_led_get_index(led_cdev);
  switch(led) {
    case 0:
      index = readb(MEM_PTR_OFFSET(BTNS));
      break;
    case 1:
      index = readb(MEM_PTR_OFFSET(RNGS));
      break;
    case 2:
      index = readb(MEM_PTR_OFFSET(OBLS));
      break;
  }
  index -= 1;

  return sprintf(
    buf,
    "%s%s%s %s%s%s %s%s%s\n",
    STATE_STR(index, 0), STATE_STR(index, 1), STATE_STR(index, 2));
}

static ssize_t nuc_led_state_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  u8 i;
  int set = -1;
  struct led_classdev *led_cdev = dev_get_drvdata(dev);
  int led = nuc_led_get_index(led_cdev);
  for (i = 0; i < 3; i++) {
    if (strncmp(states[i], buf, strlen(states[i])) == 0) {
      set = i + 1;
      break;
    }
  }
  if (set > 0)
    switch(led) {
      case 0:
        writeb(set, MEM_PTR_OFFSET(BTNS));
        break;
      case 1:
        writeb(set, MEM_PTR_OFFSET(RNGS));
        break;
      case 2:
        writeb(set, MEM_PTR_OFFSET(OBLS));
        break;
    }
  return size;
}

static ssize_t nuc_led_color_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct led_classdev *led_cdev = dev_get_drvdata(dev);
  int led = nuc_led_get_index(led_cdev);
  struct nuc_led_interface iface;
  if (nuc_led_get_interface(led, &iface)) {
    return -EIO;
  }
  const u8 color = readb(iface.CR);
  u8 i;
  size_t off = 0;
  for (i = 0; i < 9; i++) {
    if (!colors[led][i]) break;
    off += sprintf(
      buf + off,
      "%s%s%s ",
      WRAP_STR(color, i, colors[led]));
  }
  buf[off - 1] = '\n';
  return off;
}

static ssize_t nuc_led_color_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  u8 i;
  int set = -1;
  struct led_classdev *led_cdev = dev_get_drvdata(dev);
  int led = nuc_led_get_index(led_cdev);
  struct nuc_led_interface iface;
  if (nuc_led_get_interface(led, &iface)) {
    return -EIO;
  }
  const u8 color = readb(iface.CR);
  for (i = 0; i < 9; i++) {
    if (!colors[led][i]) break;
    if (strncmp(colors[led][i], buf, strlen(colors[led][i])) == 0) {
      set = i;
      break;
    }
  }
  if (set > 0) {
    writeb(set, iface.CR);
    return size;
  }
  return -EIO;
}

static DEVICE_ATTR(state, 0644, nuc_led_state_show, nuc_led_state_store);
static DEVICE_ATTR(color, 0644, nuc_led_color_show, nuc_led_color_store);

static struct attribute *nuc_led_attrs[] = {
        &dev_attr_state.attr,
        &dev_attr_color.attr,
        NULL
};

ATTRIBUTE_GROUPS(nuc_led);

static struct led_classdev nuc_leds[3] = {
  {
   	.name		= "nuc::btns",
    .groups = nuc_led_groups,
   	.brightness_set	= nuc_led_class_brightness_set,
    .brightness_get = nuc_led_class_brightness_get,
   	.flags		= LED_CORE_SUSPENDRESUME,
  },
  {
   .name		= "nuc::rngs",
   .groups = nuc_led_groups,
   .brightness_set	= nuc_led_class_brightness_set,
   .brightness_get = nuc_led_class_brightness_get,
   .flags		= LED_CORE_SUSPENDRESUME,
  },
  {
   .name		= "nuc::obls",
   .groups = nuc_led_groups,
   .brightness_set	= nuc_led_class_brightness_set,
   .brightness_get = nuc_led_class_brightness_get,
   .flags		= LED_CORE_SUSPENDRESUME,
  }
};

static int nuc_led_class_probe(struct platform_device *pdev)
{
  u8 i;
  int ret;
  for (i = 0; i < (sizeof(nuc_leds) / sizeof(struct led_classdev)); i++) {
    ret = devm_led_classdev_register(&pdev->dev, &nuc_leds[i]);
    if (ret) {
      while (i) {
        devm_led_classdev_unregister(&pdev->dev, &nuc_leds[--i]);
      }
      return -EIO;
    }
  }

  return 0;
}

static struct platform_driver nuc_led_class_driver = {
	.probe		= nuc_led_class_probe,
	.driver		= {
		.name		= DRVNAME,
	},
};

static int __init nuc_led_class_init(void)
{
	int ret = -ENODEV;
	if (!wmi_has_guid(NUCLED_WMI_MGMT_GUID)) {
		ret = -ENODEV;
		goto out;
	}

  mem_ptr = ioremap_nocache((void *)ACPI_H2RA, ACPI_H2RL);

  if (!mem_ptr) {
    return -EIO;
  }

	ret = platform_driver_register(&nuc_led_class_driver);
	if (ret < 0) {
    // iounmap(mem_ptr);
    return -ENODEV;
  }

	pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
	if (IS_ERR(pdev)) {
		ret = PTR_ERR(pdev);
		platform_driver_unregister(&nuc_led_class_driver);
    // iounmap(mem_ptr);
    return ret;
  }

out:
	return ret;
}

static void __exit nuc_led_class_exit(void)
{
	platform_device_unregister(pdev);
	platform_driver_unregister(&nuc_led_class_driver);
  // iounmap(mem_ptr);
}

module_init(nuc_led_class_init);
module_exit(nuc_led_class_exit);

MODULE_AUTHOR("Greg Miell");
MODULE_DESCRIPTION("Intel NUC LED Class Driver");
MODULE_LICENSE("GPL");
ACPI_MODULE_NAME("NUC_LED");
MODULE_ALIAS("wmi:" NUCLED_WMI_MGMT_GUID);
