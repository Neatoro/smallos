#ifndef _KERNEL_TTY
#define _KERNEL_TTY

void terminal_init(void);

void print(const char*);
void println(const char*);

void print_int(int i, const unsigned int base);
void print_long(long i, const unsigned int base);

void print_uint(unsigned int i, const unsigned int base);
void print_ulong(unsigned long i, const unsigned int base);

#endif