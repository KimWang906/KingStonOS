ARCH = armv7-a
MCPU = cortex-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

LINKER_SCRIPT = ./KingStone_linker.ld

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.o, $(ASM_SRCS))

INC_DIRS = include

KingStone = build/KingStone.axf
KingStone_bin = build/KingStone.bin

.PHONY: all clean run debug gdb

all: $(KingStone)

clean:
	@rm -rf build

run: $(KingStone)(
	qemu-system-arm -M realview-pb-a8 -kernel $(KingStone)

debug: $(KingStone)
	qemu-system-arm -M realview-pb-a8 -kernel $(KingStone) -S -gdb tcp::1234,ipv4

gdb:
	gdb-multiarch

$(KingStone): $(ASM_OBJS) $(LINKER_SCRIPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(KingStone) $(ASM_OBJS)
	$(OC) -O binary $(KingStone) $(KingStone_bin)

build/%.o: boot/%.S
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) -I $(INC_DIRS) -c -g -o $@ $<
