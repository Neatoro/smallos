.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.set KERNEL_CODE_SEGMENT, 0x8
.set KERNEK_DATA_SEGMENT, 0x10

.set KERNEL_ADDR_OFFSET, 0xC0000000

.section .multiboot.data, "a"
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .bss
.align 16

stack_bottom:
.skip 16384
stack_top:

.section .text
.global _start
.type _start, @function
_start:
    mov $stack_top, %esp

    add $KERNEL_ADDR_OFFSET, %ebx
    push %ebx

    push %eax

    cli
    
    call kernel_main

1:  hlt
    jmp 1b

.global gdt_flush
gdt_flush:
    mov 4(%esp), %ebp

    lgdt (%ebp)
    mov $KERNEK_DATA_SEGMENT, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    mov %cr0, %eax
    or $0x1, %eax
    mov %eax, %cr0

    call dump_register

    jmp $KERNEL_CODE_SEGMENT, $flush
flush:
    ret

.size _start, . - _start
