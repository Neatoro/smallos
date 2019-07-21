ENTRY(_start)

KERNEL_ADDR_OFFSET = 0xC0000000;

SECTIONS {

    . = 1M;

    .multiboot.data :
    {
        *(.multiboot.data)
    }

    . += KERNEL_ADDR_OFFSET;

    .text ALIGN(4K) : AT(ADDR(.text) - KERNEL_ADDR_OFFSET)
    {
        *(.text)
    }

    .rodata ALIGN(4K) : AT(ADDR(.rodata) - KERNEL_ADDR_OFFSET)
    {
        *(.rodata)
    }

    .data ALIGN(4K) : AT(ADDR(.data) - KERNEL_ADDR_OFFSET)
    {
        *(.data)
    }

    .bss ALIGN(4K) : AT(ADDR(.bss) - KERNEL_ADDR_OFFSET)
    {
        *(COMMON)
        *(.bss)
    }

}