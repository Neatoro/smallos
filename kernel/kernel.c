#include<tty.h>

void kernel_main(void) {
    terminal_init();

    register int ebx asm("ebx");
    register int eax asm("eax");
    //egister int bp asm("bp");

    print_int(ebx, 16);
    print_int(eax, 16);
    //print_int(bp, 16);
}
