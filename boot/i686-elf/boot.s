.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)
.set KERNEL_PAGE_NUMBER, (0xC0000000 >> 22)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bt_stack
stack_bottom:
.skip 16384
stack_top:

.section .data
.align 0x1000
boot_page_directory:
    .word 0x00000083
    .rept (KERNEL_PAGE_NUMBER - 1)
    .word 0
    .endr

    .word 0x00000083
    .rept (1024 - KERNEL_PAGE_NUMBER - 1)
    .word 0
    .endr

boot_page_table1:
    .skip 4096

.section .bss
.align 32

.section .text
.global _start
.type _start, @function
_start:
    movl $(boot_page_table1 - 0xC0000000), %edi
    movl $0, %esi
    movl $1023, %ecx

1:
    cmpl $(_kernel_start - 0xC0000000), %esi
    jl 2f
    cmpl $(_kernel_end - 0xC0000000), %esi
    jge 3f

    movl %esi, %edx
    orl $0x003, %edx
    movl %edx, (%edi)

2:
    addl $4096, %esi
    addl $4, %edi

    loop 1b

3:
    movl $(0x000B8000 | 0x003), boot_page_table1 - 0xC0000000 + 1023 * 4
    movl $(boot_page_table1 - 0xC0000000 + 0x003), boot_page_directory - 0xC0000000 + 0
    movl $(boot_page_table1 - 0xC0000000 + 0x003), boot_page_directory - 0xC0000000 + 768 * 4

    movl $(boot_page_directory - 0xC0000000), %ecx
    movl %ecx, %cr3

    movl %cr0, %ecx
    orl $0x80010000, %ecx
    movl %ecx, %cr0

    lea 4f, %ecx
    jmp *%ecx

4:

    movl $0, boot_page_directory + 0
    
    movl %cr3, %ecx
    movl %ecx, %cr3

    mov $stack_top, %esp

    call kernel_main

    cli
1:  hlt
    jmp 1b
