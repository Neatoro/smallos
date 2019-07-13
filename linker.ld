ENTRY(_start)

SECTIONS {

    . = 1M;

    .boot :
    {
        *(.multiboot)
    }

    .text BLOCK(8K) : ALIGN(8K)
    {
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