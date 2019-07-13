#include<tty.h>

void kernel_main(void) {
    terminal_init();

    print("Testing string print: Hello Kernel World!");
    print_int(10, 10);
    print_int(10, 16);
}