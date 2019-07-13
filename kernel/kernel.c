#include<tty.h>

void kernel_main(void) {
    terminal_init();

    print("Hello Kernel World!");
}