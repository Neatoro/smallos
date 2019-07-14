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

_mmap_error:
    mov %bp, 0
    jmp _kernel

_start:

_setup_stack:
    mov $stack_top, %esp

_generate_mmap:
    xor %ebx, %ebx
    xor %bp, %bp
    mov %eax, 0xe820
    mov %edx, 0x534D4150
    mov %ecx, 0x18
    ;int $0x15
    ;jc _mmap_error
    
    ;mov %edx, 0x534D4150
    ;cmp %eax, %edx
    ;jne _mmap_error
    ;je _mmap_test 

;_mmap_test:
;    mov %bp, 1

_kernel:
    call kernel_main

    cli
1:  hlt
    jmp 1b

.size _start, . - _start
