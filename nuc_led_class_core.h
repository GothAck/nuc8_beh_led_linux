#pragma once

#define DRVNAME "nuc-led-class"
#define NUCLED_WMI_MGMT_GUID "8C5DA44C-CDC3-46b3-8619-4E26D34390B7"
#define ACPI_H2RA ((void *)0xFE410500)
#define ACPI_H2RL 0x100

#define NUM_LEDS 3

struct E2HR_led_normal {
  u8 BN;
  u8 BH;
  u8 FQ;
  u8 CR;
} __attribute__((packed));

struct E2HR_led_hdd {
  u8 BN;
  u8 CR;
  u8 BH;
} __attribute__((packed));

struct E2HR {
  #define OFF1_ABS 0x30
  #define OFF1 (OFF1_ABS)
  u8 offset1[OFF1];
  u8 BTNS;
  u8 RNGS;
  u8 OBLS;
  #define OFF2_ABS 0x40
  #define OFF2 (OFF2_ABS - (OFF1_ABS + 3))
  u8 offset2[OFF2];
  struct E2HR_led_normal B0;
  struct E2HR_led_normal B3;
  struct E2HR_led_hdd BH;
  struct E2HR_led_normal BS;
  #define OFF3_ABS 0x50
  #define OFF3 (OFF3_ABS - (OFF2_ABS + 15))
  u8 offset3[OFF3];
  struct E2HR_led_normal R0;
  struct E2HR_led_normal R3;
  struct E2HR_led_hdd RH;
  struct E2HR_led_normal RS;
  #define OFF4_ABS 0x60
  #define OFF4 (OFF4_ABS - (OFF3_ABS + 15))
  u8 offset4[OFF4];
  struct E2HR_led_normal O0;
  struct E2HR_led_normal O3;
  #define OFF5_ABS 0x69
  #define OFF5 (OFF5_ABS - (OFF4_ABS + 8))
  u8 offset5[OFF5];
  struct E2HR_led_hdd OH;
  struct E2HR_led_normal OS;
} __attribute__((packed));

enum nuc_status {
  NUC_LED_PW = 1,
  NUC_LED_HD = 2,
  NUC_LED_SW = 3,
};

struct nuc_led_interface {
  u8 index;
  enum nuc_status status;
  void __iomem *S;
  void __iomem *BN;
  void __iomem *BH;
  void __iomem *FQ;
  void __iomem *CR;
};

#define MEM_PTR_OFFSET(member) (mem_ptr + offsetof(struct E2HR, member))
