[BITS 16]
[ORG 0x7C00]

; Vexis OS Bootloader
; This is the first code that runs when the computer starts
; It initializes the hardware and loads the kernel into memory

boot_start:
    ; Clear screen and set video mode
    mov ax, 0x0003        ; Set text mode 80x25
    int 0x10              ; Call video BIOS interrupt
    
    ; Set up stack pointer (memory area for temporary storage)
    mov ax, 0x0000
    mov ss, ax
    mov sp, 0x7C00
    
    ; Print welcome message: "Vexis OS"
    mov ax, 0x0000
    mov ds, ax
    mov si, boot_message
    
.print_loop:
    lodsb                 ; Load byte from message
    cmp al, 0             ; Check if end of string
    je .print_done
    
    ; Print character
    mov ah, 0x0E          ; BIOS print character function
    mov bh, 0x00          ; Page number
    int 0x10              ; Call video BIOS
    jmp .print_loop
    
.print_done:
    ; Long jump to kernel at 0x1000:0x0000
    jmp 0x1000:0x0000
    
    ; Hang if kernel returns
    jmp $

; Message to display on boot
boot_message:
    db 13, 10             ; New line
    db "========================================", 13, 10
    db "     VEXIS OS - Booting...", 13, 10
    db "========================================", 13, 10
    db 0                  ; String terminator

; Padding to make bootloader exactly 512 bytes
; Bootloader must be exactly one sector (512 bytes)
times 510 - ($ - $$) db 0

; Boot signature - tells BIOS this is bootable
dw 0xAA55
