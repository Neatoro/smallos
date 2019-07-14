#include<stddef.h>
#include<stdint.h>
#include<string.h>
#include<tty.h>
#include "vga.h"

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_setcolor(uint8_t color) {
	terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

void terminal_putchar(char c) {
    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

    if (++terminal_column == VGA_WIDTH) {
        terminal_column = 0;

        if (++terminal_row == VGA_HEIGHT) {
            terminal_row = 0;
        }
    }
}

void print(const char* data) {
    size_t size = strlen(data);

    for (size_t i = 0; i < size; ++i) {
        terminal_putchar(data[i]);
    }
}

void newline() {
    terminal_column = 0;
    if (++terminal_row == VGA_HEIGHT) {
        terminal_row = 0;
    }
}

void println(const char* data) {
    print(data);
    newline();
}

void print_int(signed int i, const unsigned int base) {
    if (i < 0) {
        terminal_putchar('-');
        i = -1 * i;
    }

    unsigned int k = i % base;
    if (k == i) {
        terminal_putchar("0123456789ABCDEF"[k]);
    } else {
        i = (i - k) / base;
        print_int(i, base);
        terminal_putchar("0123456789ABCDEF"[k]);
    }
}

void terminal_init(void) {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
    terminal_buffer = (uint16_t*) 0xB8000;

    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            terminal_putentryat(' ', terminal_color, x, y);
        }
    }
}
