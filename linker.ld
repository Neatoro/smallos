ENTRY(loader)

KERNEL_OFFSET = 0xC0000000;
KERNEL_BASE = 0xC0100000;

SECTIONS
{

    . = 1M;
    KERNEL_PHYSICAL_ADDR = .;

    .multiboot.data :
    {
        *(.multiboot.data)
    }

    .multiboot.text :
    {
        *(.multiboot.text)
    }

    . += KERNEL_OFFSET;

        .text ALIGN(4K) : AT (ADDR (.text) - KERNEL_OFFSET)
        {
            *(.multiboot)
            *(.text)
        }

        .rodata ALIGN(4K) : AT (ADDR (.rodata) - KERNEL_OFFSET)
        {
            *(.rodata)
        }

        .data ALIGN(4K) : AT (ADDR (.data) - KERNEL_OFFSET)
        {
            *(.data)
        }

        .bss ALIGN(4K) : AT (ADDR (.bss) - KERNEL_OFFSET)
        {
            *(COMMON)
            *(.bss)
        }

    KERNEL_PHYSADDR_END = . - KERNEL_OFFSET;
    KERNEL_VADDR_END = .;
}
