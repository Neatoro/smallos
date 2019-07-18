#include<gdt.h>

extern void gdt_flush(uint32_t gdt_pointer_addr);

gdt_entry_t gdt[GDT_ENTRY_COUNT];
gdt_pointer_t gdt_pointer;

void gdt_init(void) {
    gdt_pointer.base = ((uint32_t) &gdt);
    gdt_pointer.limit = sizeof(gdt_entry_t) * GDT_ENTRY_COUNT - 1;

    gdt_put_entry(0, 0, 0, 0, 0);
    gdt_put_entry(1, 0, 0xFFFFFFFF, 0x9A, 0xCF);
    gdt_put_entry(2, 0, 0xFFFFFFFF, 0x92, 0xCF);

    gdt_flush((uint32_t) &gdt_pointer);
}

void gdt_put_entry(unsigned int index, uint32_t base, uint32_t limit, uint8_t access, uint8_t flags) {
    gdt[index].base_low = (uint16_t) (base & 0xFFFF);
    gdt[index].base_middle = (uint8_t) (base >> 16) & 0xFF;
    gdt[index].base_high = (uint8_t) (base >> 24) & 0xFF;

    gdt[index].limit_low = (uint16_t) (limit & 0xFFFF);
    gdt[index].granularity = (uint8_t) (limit >> 16 & 0x0F);

    gdt[index].granularity |= flags & 0xF0;
    gdt[index].access = access;
}
