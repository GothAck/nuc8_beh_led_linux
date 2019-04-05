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

const char *debug_keys[] = {
  "S",
  "BN",
  "BH",
  "FQ",
  "CR",
  NULL,
};

static const char *states[] = {
  "power",
  "hdd",
  "sw",
  NULL,
};

static const char *colors_ba[] = {"off", "blue", "amber", NULL};
static const char *colors_rgb[] = {"off", "blue", "red", "green", "orange", "yellow", "purple", "pink", "white", NULL};

static const char **colors[] = {
  (const char **)&colors_ba,
  (const char **)&colors_rgb,
  (const char **)&colors_rgb,
  NULL,
};

static const char *anims[] = {
  "solid",
  "breathing",
  "pulsing",
  "strobing",
  NULL,
};

static void __iomem *mem_ptr = NULL;

static struct led_classdev nuc_leds[NUM_LEDS];

static int get_choice(const char *choices[], const char *buf) {
  int i = 0;
  while (choices[i]) {
    if (!strncmp(choices[i], buf, strlen(choices[i]))) {
      return i;
    }
    i++;
  }
  return -1;
}

static int print_choices(const char *buf, const char *choices[], int index) {
  int off = 0;
  int i = 0;
  while (choices[i]) {
    off += sprintf(
      buf + off,
      "%s%s%s ",
      i == index ? "[" : "",
      choices[i],
      i == index ? "]" : ""
    );
    i++;
  }
  strcpy(buf + off - 1, "\n");
  return off;
}

inline int nuc_led_get_index(struct led_classdev *led_cdev) {
  u8 i;
  for (i = 0; i < NUM_LEDS; i++) {
    if (nuc_leds[i].name == led_cdev->name)
      return i;
  }
  return -1;
}

inline int nuc_led_get_interface(int index, struct nuc_led_interface *iface) {
  void __iomem *ptr = NULL;
  switch(index) {
    case 0:
      iface->S = MEM_PTR_OFFSET(BTNS);
      iface->status = readb(iface->S);
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
      iface->S = MEM_PTR_OFFSET(RNGS);
      iface->status = readb(iface->S);
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
      iface->S = MEM_PTR_OFFSET(OBLS);
      iface->status = readb(iface->S);
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

static int nuc_led_get_interface_cdev(struct led_classdev *led_cdev, struct nuc_led_interface *iface) {
  int led = nuc_led_get_index(led_cdev);
  iface->index = led;
  return nuc_led_get_interface(led, iface);
}

static int nuc_led_get_interface_dev(struct device *dev, struct nuc_led_interface *iface) {
  struct led_classdev *led_cdev = dev_get_drvdata(dev);
  return nuc_led_get_interface_cdev(led_cdev, iface);
}

static void nuc_led_class_brightness_set(
  struct led_classdev *led_cdev,
  enum led_brightness value
) {
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_cdev(led_cdev, &iface)) {
    return;
  }
  writeb(value, iface.BN);
}

static enum led_brightness nuc_led_class_brightness_get(struct led_classdev *led_cdev)
{
  u8 value = 0;
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_cdev(led_cdev, &iface)) {
    return 0;
  }
  value = readb(iface.BN);
  return value;
}

static ssize_t nuc_led_state_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  int index = iface.status - 1;
  return print_choices(buf, states, index);
}

static ssize_t nuc_led_state_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  int set = get_choice(states, buf);
  if (set < 0) return -EIO;
  writeb(set + 1, iface.S);
  return size;
}

static ssize_t nuc_led_color_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  const u8 color = readb(iface.CR);
  return print_choices(buf, colors[iface.index], color);
}

static ssize_t nuc_led_color_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  int set = get_choice(colors[iface.index], buf);

  if (set < 0)
    return -EIO;

  writeb(set, iface.CR);
  return size;
}

static ssize_t nuc_led_anim_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  const u8 anim = readb(iface.BH) - 1;

  return print_choices(buf, anims, anim);
}

static ssize_t nuc_led_anim_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  int set = get_choice(anims, buf);
  if (set < 0)
    return -EIO;
  writeb(set, iface.BH + 1);
  return size;
}

static ssize_t nuc_led_debug_show(struct device *dev,
                                  struct device_attribute *attr, char *buf)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  return sprintf(
    buf,
    "S: %x\n"
    "BN: %x\n"
    "BH: %x\n"
    "FQ: %x\n"
    "CR: %x\n",
    iface.status,
    iface.BN ? readb(iface.BN) : 0,
    iface.BH ? readb(iface.BH) : 0,
    iface.FQ ? readb(iface.FQ) : 0,
    iface.CR ? readb(iface.CR) : 0
  );
}

static ssize_t nuc_led_debug_store(struct device *dev,
                                   struct device_attribute *attr,
                                   const char *buf, size_t size)
{
  struct nuc_led_interface iface;
  if (nuc_led_get_interface_dev(dev, &iface)) {
    return -EIO;
  }
  printk(KERN_WARNING "%s %s\n", __func__, buf);
  const char *bufcpy = kmalloc(size + 1, GFP_KERNEL);
  strcpy(bufcpy, buf);
  char *bufptr = bufcpy;

  char key[3] = {0, 0, 0};
  char *tok = strsep(&bufptr, "=");
  u8 i = 0;
  unsigned int valint;
  int writes = 0;
  while (tok) {
    if (!i) {
      strncpy(key, tok, 2);
      tok = strsep(&bufptr, " ");
    } else {
      kstrtouint(tok, 16, &valint);
      printk(KERN_WARNING "%s key %s value %x\n", __func__, key, valint);
      switch(match_string(debug_keys, 5, key)) {
        case 0:
          if (iface.S) writeb(valint, iface.S);
          writes++;
          break;
        case 1:
          if (iface.BN) writeb(valint, iface.BN);
          writes++;
          break;
        case 2:
          if (iface.BH) writeb(valint, iface.BH);
          writes++;
          break;
        case 3:
          if (iface.FQ) writeb(valint, iface.FQ);
          writes++;
          break;
        case 4:
          if (iface.CR) writeb(valint, iface.CR);
          writes++;
          break;
      }
      tok = strsep(&bufptr, "=");
    }
    i = !i;
  }

  kfree(bufcpy);

  if (writes) return size;
  return -EIO;
}

static DEVICE_ATTR(state, 0644, nuc_led_state_show, nuc_led_state_store);
static DEVICE_ATTR(color, 0644, nuc_led_color_show, nuc_led_color_store);
static DEVICE_ATTR(anim, 0644, nuc_led_anim_show, nuc_led_anim_store);
static DEVICE_ATTR(debug, 0644, nuc_led_debug_show, nuc_led_debug_store);

static struct attribute *nuc_led_attrs[] = {
        &dev_attr_state.attr,
        &dev_attr_color.attr,
        &dev_attr_anim.attr,
        &dev_attr_debug.attr,
        NULL
};

ATTRIBUTE_GROUPS(nuc_led);

static struct led_classdev nuc_leds[NUM_LEDS] = {
  {
    .name		= "nuc::btns",
    .groups = nuc_led_groups,
    .brightness_set	= nuc_led_class_brightness_set,
    .brightness_get = nuc_led_class_brightness_get,
    .max_brightness = 100,
    .flags		= LED_RETAIN_AT_SHUTDOWN,
  },
  {
   .name		= "nuc::rngs",
   .groups = nuc_led_groups,
   .brightness_set	= nuc_led_class_brightness_set,
   .brightness_get = nuc_led_class_brightness_get,
   .max_brightness = 100,
   .flags		= LED_RETAIN_AT_SHUTDOWN,
  },
  {
   .name		= "nuc::obls",
   .groups = nuc_led_groups,
   .brightness_set	= nuc_led_class_brightness_set,
   .brightness_get = nuc_led_class_brightness_get,
   .max_brightness = 100,
   .flags		= LED_RETAIN_AT_SHUTDOWN,
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
  if (!wmi_has_guid(NUCLED_WMI_MGMT_GUID)) {
    return -ENODEV;
  }

  mem_ptr = ioremap_nocache((void *)ACPI_H2RA, ACPI_H2RL);

  if (!mem_ptr) {
    return -EIO;
  }

  if (platform_driver_register(&nuc_led_class_driver) < 0) {
    iounmap(mem_ptr);
    mem_ptr = NULL;
    return -ENODEV;
  }

  pdev = platform_device_register_simple(DRVNAME, -1, NULL, 0);
  if (IS_ERR(pdev)) {
    platform_driver_unregister(&nuc_led_class_driver);
    iounmap(mem_ptr);
    mem_ptr = NULL;
    return PTR_ERR(pdev);
  }

  return 0;
}

static void __exit nuc_led_class_exit(void)
{
  platform_device_unregister(pdev);
  platform_driver_unregister(&nuc_led_class_driver);
  mem_ptr = NULL;
  iounmap(mem_ptr);
}

module_init(nuc_led_class_init);
module_exit(nuc_led_class_exit);

MODULE_AUTHOR("Greg Miell");
MODULE_DESCRIPTION("Intel NUC LED Class Driver");
MODULE_LICENSE("GPL");
ACPI_MODULE_NAME("NUC_LED");
MODULE_ALIAS("wmi:" NUCLED_WMI_MGMT_GUID);
