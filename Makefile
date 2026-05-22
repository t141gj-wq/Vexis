# Vexis OS Makefile
# Build system for the custom lightweight operating system

.PHONY: all build run clean help bootloader kernel iso

# Compiler and assembler settings
CC = gcc
CFLAGS = -Wall -Wextra -fno-builtin -fno-stack-protector -m32 -nostdinc -I./include
LDFLAGS = -m32 -nostdlib -Wl,-Ttext=0x100000

ASM = nasm
ASMFLAGS = -f bin

# Output directories
BUILD_DIR = build
OBJ_DIR = $(BUILD_DIR)/obj
BIN_DIR = $(BUILD_DIR)/bin

# Source files
BOOTLOADER_SRC = src/bootloader.asm
KERNEL_SRC = kernel/main.c

# Output files
BOOTLOADER_BIN = $(BIN_DIR)/bootloader.bin
KERNEL_BIN = $(BIN_DIR)/kernel.bin
KERNEL_ELF = $(OBJ_DIR)/kernel.elf
VEXIS_ISO = $(BIN_DIR)/vexis.iso

all: build

build: directories bootloader kernel
	director @echo "[✓] Vexis OS build complete"
	director @echo "    Bootloader: $(BOOTLOADER_BIN)"
	director @echo "    Kernel: $(KERNEL_BIN)"
	director @echo "    Run 'make run' to test"

directories:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)

bootloader: $(BOOTLOADER_BIN)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	@echo "[*] Assembling bootloader..."
	$(ASM) $(ASMFLAGS) $< -o $@
	@echo "[✓] Bootloader built: $@"

kernel: $(KERNEL_BIN)

$(OBJ_DIR)/main.o: $(KERNEL_SRC)
	@echo "[*] Compiling kernel..."
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "[✓] Kernel compiled: $@"

$(KERNEL_BIN): $(OBJ_DIR)/main.o
	@echo "[*] Linking kernel..."
	$(CC) $(LDFLAGS) $< -o $@
	@echo "[✓] Kernel linked: $@"

iso: build
	@echo "[*] Creating ISO image..."
	@mkdir -p iso_tmp/boot/grub
	@cp $(BOOTLOADER_BIN) iso_tmp/boot/
	@cp $(KERNEL_BIN) iso_tmp/boot/
	@echo "menuentry 'Vexis OS' { multiboot /boot/kernel.bin }" > iso_tmp/boot/grub/grub.cfg
	@grub-mkimage -o iso_tmp/boot/grub/i386-pc/core.img -O i386-pc biosdisk part_msdos ext2
	@grub-mkrescue -o $(VEXIS_ISO) iso_tmp
	@rm -rf iso_tmp
	@echo "[✓] ISO created: $(VEXIS_ISO)"

run: build
	@echo "[*] Starting Vexis OS..."
	@echo "    Memory Limit: 1536 MB (1.5 GB)"
	@echo "    Status: Running simulation"
	@echo ""
	@qemu-system-i386 -m 1536 -kernel $(KERNEL_BIN) -nographic 2>/dev/null || echo "[!] QEMU not found. Install qemu-system-x86 to run."

clean:
	@echo "[*] Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@echo "[✓] Clean complete"

help:
	@echo "Vexis OS - Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make                - Build the OS (bootloader + kernel)"
	@echo "  make build          - Same as 'make'"
	@echo "  make bootloader     - Build bootloader only"
	@echo "  make kernel         - Build kernel only"
	@echo "  make iso            - Create bootable ISO image"
	@echo "  make run            - Run OS in QEMU emulator"
	@echo "  make clean          - Remove all build artifacts"
	@echo "  make help           - Show this help message"
	@echo ""
	@echo "Features:"
	@echo "  - Fast, lightweight OS"
	@echo "  - 1536 MB (1.5 GB) RAM limit enforced"
	@echo "  - Custom bootloader"
	@echo "  - Kernel with command line"
	@echo "  - Memory protection"
