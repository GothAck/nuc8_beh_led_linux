obj-m := nuc_led_class.o
nuc_led_class-objs := nuc_led_class_core.o

KVERSION := $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

modules:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install
	@depmod -a $(KVERSION)

.PHONY: clean default install
