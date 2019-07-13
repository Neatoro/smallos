ENTRY(_start)

SECTIONS {

    . = 1M;

    .text BLOCK(8K) : ALIGN(8K)
    {
        *(.multiboot)
        *(.text)
    }

    .rodata BLOCK(8K) : ALIGN(8K)
    {
        *(.rodata)
    }

    .data BLOCK(8K) : ALIGN(8K)
    {
        *(.data)
    }

    .bss BLOCK(8K) : ALIGN(8K)
    {
        *(COMMON)
        *(.bss)
    }

}