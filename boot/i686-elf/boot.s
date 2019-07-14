.set ALIGN, 1<<0
.set MEMINFO, 1<<1
.set FLAGS, ALIGN | MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
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

_setup_stack:
    mov $stack_top, %esp
    ret

_kernel:
    call kernel_main
    ret

_generate_mmap:
    xor %ebx, %ebx
    xor %bp, %bp
    mov %eax, 0xe820
    ret

_start:
    jmp _setup_stack
    jmp _generate_mmap
    jmp _kernel

    cli
1:  hlt
    jmp 1b

.size _start, . - _start
