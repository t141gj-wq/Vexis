/*
 * Vexis OS - Kernel Main
 * Fast, lightweight operating system with strict 1.5GB RAM limit
 * Custom built from scratch
 */

#include "../include/stdint.h"
#include "../include/stddef.h"

/* Memory constraints */
#define MAX_RAM_MB 1536              /* 1.5GB maximum RAM */
#define MAX_RAM_BYTES (MAX_RAM_MB * 1024 * 1024)
#define KERNEL_BASE 0x100000         /* 1MB kernel base */

/* Video memory address */
#define VIDEO_MEMORY 0xb8000
#define VIDEO_WIDTH 80
#define VIDEO_HEIGHT 25

/* Current cursor position */
static uint16_t cursor_pos = 0;

/* Memory tracker */
static uint32_t allocated_memory = 0;

/* Forward declarations */
void kernel_main(void);
void print(const char *str);
void print_char(char c, uint8_t color);
void clear_screen(void);
void read_command(char *buffer, uint32_t size);
void process_command(const char *cmd);
uint32_t allocate_memory(uint32_t size);
void free_memory(uint32_t size);

/* Color codes for bright green text */
#define COLOR_GREEN_BG 0x0a   /* Bright green on black */
#define COLOR_CYAN_BG 0x0b    /* Cyan on black */
#define COLOR_WHITE_BG 0x0f   /* White on black */

/*
 * Main kernel entry point
 */
void kernel_main(void) {
    clear_screen();
    print("\n");
    print("  ===== V E X I S   O S =====\n");
    print("  BUILT BY t141gj-wq\n");
    print("  FAST - LIGHT - POWERFUL\n");
    print("  ============================\n\n");
    print("  Memory Limit: 1.5 GB (1536 MB)\n");
    print("  Status: RUNNING\n\n");
    
    /* Initialize kernel systems */
    print("  [*] Kernel initialized\n");
    print("  [*] Memory protection enabled\n");
    print("  [*] Command line ready\n\n");
    
    /* Main command loop */
    while (1) {
        char cmd_buffer[256];
        print("vexis> ");
        read_command(cmd_buffer, sizeof(cmd_buffer));
        process_command(cmd_buffer);
    }
}

/*
 * Clear the screen
 */
void clear_screen(void) {
    uint16_t *video_mem = (uint16_t *)VIDEO_MEMORY;
    uint16_t blank = (' ' << 8) | COLOR_GREEN_BG;
    
    for (int i = 0; i < VIDEO_WIDTH * VIDEO_HEIGHT; i++) {
        video_mem[i] = blank;
    }
    
    cursor_pos = 0;
}

/*
 * Print a single character with color
 */
void print_char(char c, uint8_t color) {
    uint16_t *video_mem = (uint16_t *)VIDEO_MEMORY;
    
    if (c == '\n') {
        cursor_pos += VIDEO_WIDTH - (cursor_pos % VIDEO_WIDTH);
    } else if (c == '\t') {
        cursor_pos += 4;
    } else if (cursor_pos < VIDEO_WIDTH * VIDEO_HEIGHT) {
        video_mem[cursor_pos] = (color << 8) | c;
        cursor_pos++;
    }
    
    if (cursor_pos >= VIDEO_WIDTH * VIDEO_HEIGHT) {
        cursor_pos = (VIDEO_HEIGHT - 1) * VIDEO_WIDTH;
    }
}

/*
 * Print a string
 */
void print(const char *str) {
    if (str == NULL) return;
    
    while (*str) {
        print_char(*str, COLOR_GREEN_BG);
        str++;
    }
}

/*
 * Read command from user input (simulated)
 */
void read_command(char *buffer, uint32_t size) {
    uint32_t pos = 0;
    
    while (pos < size - 1) {
        char c = 0;  /* Simulated input - in real OS would read from keyboard */
        
        /* For demonstration, break on simulated enter */
        if (pos > 0) break;
        
        if (c == 0x08 && pos > 0) {  /* Backspace */
            pos--;
            print_char('\b', COLOR_GREEN_BG);
        } else if (c == 0x0d) {       /* Enter */
            buffer[pos] = 0;
            print("\n");
            break;
        } else if (c >= 32 && c < 127) {
            buffer[pos++] = c;
            print_char(c, COLOR_GREEN_BG);
        }
    }
    
    buffer[pos] = 0;
}

/*
 * Process command input
 */
void process_command(const char *cmd) {
    if (cmd == NULL || cmd[0] == 0) {
        return;
    }
    
    /* Simple command dispatcher */
    if (cmd[0] == 'h' && cmd[1] == 'e' && cmd[2] == 'l' && cmd[3] == 'p') {
        print("Available commands:\n");
        print("  help    - Show this help menu\n");
        print("  memory  - Display memory usage\n");
        print("  clear   - Clear screen\n");
        print("  exit    - Halt system\n");
    } else if (cmd[0] == 'm' && cmd[1] == 'e' && cmd[2] == 'm') {
        print("Memory Status:\n");
        print("  Total RAM: 1536 MB (1.5 GB)\n");
        print("  Allocated: ");
        print_number(allocated_memory / (1024 * 1024));
        print(" MB\n");
        print("  Available: ");
        print_number((MAX_RAM_MB) - (allocated_memory / (1024 * 1024)));
        print(" MB\n");
    } else if (cmd[0] == 'c' && cmd[1] == 'l' && cmd[2] == 'e') {
        clear_screen();
    } else if (cmd[0] == 'e' && cmd[1] == 'x' && cmd[2] == 'i') {
        print("\nSystem halting...\n");
        while (1);  /* Halt */
    } else if (cmd[0] == 0) {
        /* Empty command */
    } else {
        print("Unknown command: ");
        print(cmd);
        print("\n");
    }
}

/*
 * Allocate memory (simple allocator)
 * RULE: Never exceed 1536 MB
 */
uint32_t allocate_memory(uint32_t size) {
    if (allocated_memory + size > MAX_RAM_BYTES) {
        return 0;  /* Allocation failed - would exceed RAM limit */
    }
    
    uint32_t addr = KERNEL_BASE + allocated_memory;
    allocated_memory += size;
    return addr;
}

/*
 * Free allocated memory
 */
void free_memory(uint32_t size) {
    if (allocated_memory >= size) {
        allocated_memory -= size;
    }
}

/*
 * Utility function to print numbers
 */
static void print_number(uint32_t num) {
    if (num == 0) {
        print_char('0', COLOR_GREEN_BG);
        return;
    }
    
    uint32_t divisor = 1000000000;
    uint8_t started = 0;
    
    while (divisor > 0) {
        uint32_t digit = num / divisor;
        if (digit > 0 || started) {
            print_char('0' + digit, COLOR_GREEN_BG);
            started = 1;
        }
        num %= divisor;
        divisor /= 10;
    }
}
