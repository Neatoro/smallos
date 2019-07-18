#ifndef _KERNEL_GDT
#define _KERNEL_GDT

#include <stdint.h>

#define GDT_ENTRY_COUNT 3

struct gdt_entry{
    uint16_t limit_low;
    uint16_t base_low;
    uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__((packed));
typedef struct gdt_entry gdt_entry_t;

struct gdt_pointer {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));
typedef struct gdt_pointer gdt_pointer_t;

void gdt_init(void);
void gdt_put_entry(unsigned int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags);

#endif