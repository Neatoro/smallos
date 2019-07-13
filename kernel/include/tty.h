#ifndef _KERNEL_TTY
#define _KERNEL_TTY

void terminal_init(void);
void print(const char*);

void print_int(signed int i, const unsigned int base);

#endif