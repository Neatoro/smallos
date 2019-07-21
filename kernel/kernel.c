#include<gdt.h>
#include<multiboot.h>
#include<stdint.h>
#include<tty.h>

void kernel_main(multiboot_info_t* mbd, unsigned int magic) {
    terminal_init();

    gdt_init();
    
    if ( (mbd->flags & MULTIBOOT_INFO_MEMORY) == MULTIBOOT_INFO_MEMORY) {
        println("Memory information detected");
        print_uint(magic, 16);
        println("");
        if ( (mbd->flags & MULTIBOOT_INFO_MEM_MAP) == MULTIBOOT_INFO_MEM_MAP) {
            println("Memory map detected");

            memory_map_t* mmap = (memory_map_t*) mbd->mmap_addr;
            unsigned long long memory_size = 0;
            while (((uint32_t) mmap) < mbd->mmap_addr + mbd->mmap_length) {
                if (mmap->type == 1) {
                    unsigned long long length = mmap->length_high;
                    length = length << 32;
                    length += mmap->length_low;

                    memory_size += length / 1048576;
                }

                mmap = (memory_map_t*) ((unsigned long) mmap + mmap->size + sizeof(mmap->size)); 
            }

            print("Available memory: ");
            print_ulong(memory_size, 10);
            print("MB");
            println("");
        }
    }

}
