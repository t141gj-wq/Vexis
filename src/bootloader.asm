; Vexis OS Bootloader
; x86 16-bit bootloader code
; Entry point for the operating system

bits 16
org 0x7c00

start:
    ; Clear screen and set video mode
    mov ax, 0x0003      ; 80x25 text mode
    int 0x10
    
    ; Set cursor position to top-left
    mov ah, 0x02
    mov bh, 0x00        ; Page 0
    mov dh, 2           ; Row 2
    mov dl, 10          ; Column 10
    int 0x10
    
    ; Print Vexis OS title in bright green
    mov si, title_msg
    call print_string
    
    mov dh, 3
    mov dl, 8
    call set_cursor
    mov si, author_msg
    call print_string
    
    mov dh, 4
    mov dl, 9
    call set_cursor
    mov si, tagline_msg
    call print_string
    
    mov dh, 5
    mov dl, 5
    call set_cursor
    mov si, border_msg
    call print_string
    
    ; Wait for keypress
    xor ax, ax
    int 0x16
    
    ; Halt
    cli
    hlt

set_cursor:
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    ret

print_string:
    mov ah, 0x0e        ; TTY print function
    mov bh, 0x00        ; Page 0
    mov bl, 0x0a        ; Green text attribute
    
.print_loop:
    lodsb               ; Load byte from string
    cmp al, 0           ; Check for null terminator
    je .print_done
    int 0x10
    jmp .print_loop
    
.print_done:
    ret

; Data section
title_msg:      db '===== V E X I S   O S =====', 0
author_msg:     db '  BUILT BY t141gj-wq', 0
tagline_msg:    db '  FAST - LIGHT - POWERFUL', 0
border_msg:     db '============================', 0

; Boot sector signature
fill: times 510 - ($ - $$) db 0
db 0x55, 0xaa
