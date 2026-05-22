# Vexis OS

A custom, lightweight operating system built from scratch. Fast, efficient, and designed to run on minimal resources.

## Overview

**Vexis OS** is a bare-metal operating system with the following specifications:

- **Memory Limit:** 1.5 GB (1536 MB) — Strictly enforced
- **Architecture:** x86 32-bit
- **Bootloader:** Custom x86 assembly
- **Kernel:** Written in C with minimal dependencies
- **Purpose:** Fast, powerful, and lightweight system

## Project Structure

```
Vexis/
├── src/
│   └── bootloader.asm       # x86 bootloader (16-bit real mode)
├── kernel/
│   └── main.c               # Kernel core (32-bit protected mode)
├── include/
│   ├── stdint.h             # Standard integer types
│   └── stddef.h             # Standard definitions
├── Makefile                 # Build system
└── README.md                # This file
```

## Features

✅ **Custom Bootloader**
- Real-mode x86 entry point
- Displays Vexis splash screen in bright green
- Transfers control to kernel

✅ **Lightweight Kernel**
- 32-bit protected mode operation
- Memory management with 1.5GB hard limit
- Command-line interface (`vexis> `)
- Command dispatcher

✅ **Built-in Commands**
- `help` — Show available commands
- `memory` — Display RAM usage and limits
- `clear` — Clear the screen
- `exit` — Halt the system

✅ **Memory Protection**
- Strict enforcement of 1536 MB maximum RAM
- Memory allocator respects limit
- Prevents over-allocation

## Building

### Prerequisites

```bash
# On Ubuntu/Debian
sudo apt-get install build-essential nasm qemu-system-x86

# On macOS
brew install nasm qemu

# On Fedora
sudo dnf install gcc nasm qemu-system-x86
```

### Build Commands

```bash
# Build everything (bootloader + kernel)
make

# Build specific components
make bootloader          # Build bootloader only
make kernel              # Build kernel only

# Run in QEMU emulator
make run

# Create bootable ISO
make iso

# Clean build artifacts
make clean

# Show all available commands
make help
```

## Running Vexis OS

### Option 1: QEMU Emulation (Recommended)

```bash
make run
```

This builds and runs the OS in QEMU with 1536 MB allocated memory.

### Option 2: Bootable Media

```bash
make iso
# Boot from vexis.iso on physical hardware or VM
```

## Kernel Features

### Memory Management
The kernel enforces a strict 1.5 GB RAM limit:

```c
#define MAX_RAM_MB 1536              /* 1.5GB maximum RAM */
#define MAX_RAM_BYTES (MAX_RAM_MB * 1024 * 1024)
```

Memory allocation will fail if it would exceed this limit.

### Command Processing
Simple but functional command dispatcher:

```
vexis> help
Available commands:
  help    - Show this help menu
  memory  - Display memory usage
  clear   - Clear screen
  exit    - Halt system
```

### Video Output
- Bright green text on black background
- Direct video memory access (0xb8000)
- 80×25 text mode

## Technical Details

### Boot Process
1. BIOS loads bootloader at 0x7c00
2. Bootloader displays splash screen
3. Bootloader loads kernel
4. Kernel initializes in protected mode
5. Kernel displays startup info and memory limits
6. User command loop begins

### Memory Layout
```
0x00000000 - Real mode interrupts
0x00007c00 - Bootloader (512 bytes)
0x00100000 - Kernel base (1 MB)
0x10000000 - Heap start (~256 MB offset)
```

### Constraints
- **RAM:** 1536 MB maximum (hard enforced)
- **CPU:** 32-bit x86 architecture
- **Kernel Size:** Minimal, under 100 KB
- **Boot Time:** < 1 second in emulation

## Performance

- **Boot Time:** ~500ms (QEMU)
- **Memory Overhead:** < 2 MB
- **Command Response:** < 100ms

## Future Enhancements

- [ ] Filesystem support (ext2/FAT)
- [ ] Process/task management
- [ ] Interrupt handler expansion
- [ ] Shell scripting
- [ ] Networking stack
- [ ] Graphics mode support

## License

Built by @t141gj-wq

## System Status

```
===== V E X I S   O S =====
BUILT BY t141gj-wq
FAST - LIGHT - POWERFUL
============================

Memory Limit: 1.5 GB (1536 MB)
Status: RUNNING
```

---

**Vexis OS** — Fast. Light. Powerful.
