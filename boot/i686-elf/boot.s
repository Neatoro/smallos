.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.set KERNEL_ADDR_OFFSET, 0xC0000000
.set KERNEL_PAGE_NUMBER, KERNEL_ADDR_OFFSET >> 22
.set KERNEL_NUM_UPPER_PAGES, 7

.section .multiboot.data, "a"
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.align 0x1000

boot_page_directory:
    .long 0x00000083

    .fill (KERNEL_PAGE_NUMBER - 1), 4

    .long 0x00000083
    .long 0x00000083 | (1 << 22)
    .long 0x00000083 | (2 << 22)
    .long 0x00000083 | (3 << 22)
    .long 0x00000083 | (4 << 22)
    .long 0x00000083 | (5 << 22)
    .long 0x00000083 | (6 << 22)

    .fill(1024 - KERNEL_PAGE_NUMBER - KERNEL_NUM_UPPER_PAGES), 4

.section .multiboot.text, "ax", @progbits
.align 16

.global start
start:
    mov $boot_page_directory, %ecx
    mov %ecx, %cr3

    mov %cr4, %ecx
    or $0x00000010, %ecx
    mov %ecx, %cr4

    mov %cr0, %ecx
    or $0x80000000, %ecx
    mov %ecx, %cr0
    jmp start_higher_half

.section .text

start_higher_half:
	invlpg (0)

    mov $kernel_stack_end, %esp
    mov %esp, %ebp

    push %eax

    add $KERNEL_ADDR_OFFSET, %ebx
    push %ebx

    cli
    call kernel_main
l:
    hlt
    jmp l

.section .bss
.align 16

kernel_stack:
    .fill 16384
kernel_stack_end:
