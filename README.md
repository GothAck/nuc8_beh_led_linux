# NUC8i{3,5,7}BEH LED Driver

## Warning
This driver is a WIP, and flibbles bytes in system memory in order to control LEDs, it's not complete, and if Intel release new firmware (tested on BECFL357.86A.0066 released on 02/22/2019), this may break things.

Other peripherals are apparently controlled from within this same memory space... I managed to disable the CPU fan when accidentally writing to the wrong location during my testing. Here be dragons!

## Fun stuff
This was created because the WMI LED control function for this hardware was shipped broken. Decompiling ACPI DSDT shows that the old API methods were disabled, and whilst there is the same new function as the newer NUC8 HNK ACPI, it's both not wired up, nor fully implemented.

I've added some of my workings and scripts in the hacking subdir. WARNING: peek.py suffers pretty badly from a memory leak in the urwid library, only run it for short periods of time.

## TODO:
- Work out how SW control works.
- Expose Power S3 led config
- uncrustify
