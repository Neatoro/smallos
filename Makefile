TARGET = i686-elf

KERNEL_DEFAULT_FILES := $(shell find -name "*.c" -not -path "./kernel/arch/*" | grep -e "^\.\/kernel" | sed -e 's/\.c/.o/')
ARCH_FILES := $(shell find -name "*.c" -path "./kernel/arch/$(TARGET)/*" | sed -e 's/\.c/.o/')
LIB_FILES := $(shell find -name "*.c" -path "./lib/*" | sed -e 's/\.c/.o/')

default:
	echo "Nothing to do here"

%.o: %.c
	mkdir -p bin/$(shell dirname $@)
	$(TARGET)-gcc -Ilib -Ikernel/include -c -std=gnu99 -ffreestanding -O2 -Wall -Wextra -o bin/$@ $<

boot.o:
	$(TARGET)-as boot/$(TARGET)/boot.s -o bin/boot.o

clean:
	rm -rf bin

compile: $(KERNEL_DEFAULT_FILES) $(ARCH_FILES) $(LIB_FILES) boot.o
	i686-elf-gcc -Wl,--build-id=none -T linker.ld -o bin/smallos.bin -ffreestanding -O2 -nostdlib $(shell find -name "*.o" -path "./bin/*") -lgcc