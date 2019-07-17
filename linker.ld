ENTRY(loader)

KERNEL_ADDR_OFFSET = 0xC0000000;
 
SECTIONS {

    . = 1M + KERNEL_ADDR_OFFSET;

    .text : AT(ADDR(.text) - KERNEL_ADDR_OFFSET) {
        *(.multiboot)
        *(.text)
        *(.rodata*)
    }

    .data ALIGN (0x1000) : AT(ADDR(.data) - KERNEL_ADDR_OFFSET) {
        *(.data)
    }

    .bss : AT(ADDR(.bss) - KERNEL_ADDR_OFFSET) {
        _sbss = .;
        *(COMMON)
        *(.bss)
        _ebss = .;
    }
}