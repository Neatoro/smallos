#include<tty.h>

void kernel_main(void) {
    terminal_init();

    println("Hello World");
    println("Foo Bar");
    println("");
    print_int(10, 10);
    println("");
    print_int(10, 16);
}
