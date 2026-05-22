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
    mov dh, 0           ; Row 0
    mov dl, 0           ; Column 0
    int 0x10
    
    ; Print Vexis Computing banner in bright cyan
    mov si, banner_line1
    call print_string
    
    mov si, banner_line2
    call print_string
    
    mov si, banner_line3
    call print_string
    
    mov si, banner_line4
    call print_string
    
    mov si, banner_line5
    call print_string
    
    mov si, banner_line6
    call print_string
    
    mov si, banner_line7
    call print_string
    
    mov si, banner_line8
    call print_string
    
    mov si, banner_line9
    call print_string
    
    mov si, banner_line10
    call print_string
    
    mov si, banner_line11
    call print_string
    
    mov si, banner_line12
    call print_string
    
    mov si, banner_line13
    call print_string
    
    mov si, banner_line14
    call print_string
    
    mov si, banner_line15
    call print_string
    
    mov si, banner_line16
    call print_string
    
    ; Wait for keypress
    xor ax, ax
    int 0x16
    
    ; Halt
    cli
    hlt

print_string:
    mov ah, 0x0e        ; TTY print function
    mov bh, 0x00        ; Page 0
    mov bl, 0x0b        ; Bright cyan text attribute
    
.print_loop:
    lodsb               ; Load byte from string
    cmp al, 0           ; Check for null terminator
    je .print_done
    int 0x10
    jmp .print_loop
    
.print_done:
    ret

; Banner data
banner_line1:       db '=============================================', 0x0d, 0x0a, 0
banner_line2:       db 201, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 187, 0x0d, 0x0a, 0
banner_line3:       db 186, '  ', 236, '  V E X I S   C O M P U T I N G  ', 236, '   ', 186, 0x0d, 0x0a, 0
banner_line4:       db 186, '                                           ', 186, 0x0d, 0x0a, 0
banner_line5:       db 186, '   ', 176, 176, 176, 176, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 176, 176, 176, 176, '    ', 186, 0x0d, 0x0a, 0
banner_line6:       db 186, '   ', 176, 176, '  ', 219, 219, 219, 219, 219, 219, 219, 219, 186, ' ', 219, 219, 219, 219, 219, 219, 219, 219, 186, 219, 219, 186, '  ', 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line7:       db 186, '   ', 176, 176, '  ', 219, 219, 201, 205, 205, 219, 219, 186, 219, 219, 201, 205, 205, 205, 205, 205, 219, 219, 186, 219, 219, 201, 205, 205, 219, 219, 219, 219, 201, 205, 205, 205, 205, 205, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line8:       db 186, '   ', 176, 176, '  ', 219, 219, 186, '  ', 219, 219, 186, 219, 219, 186, '  ', 219, 219, 219, 219, 219, 219, 186, 219, 219, 186, ' ', 219, 219, 219, 219, 219, 186, ' ', 219, 219, 219, 219, 186, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line9:       db 186, '   ', 176, 176, '  ', 219, 219, 186, '  ', 219, 219, 186, 219, 219, 219, 219, 219, 186, '  ', 219, 219, 219, 219, 219, 219, 186, 219, 219, 186, '  ', 219, 219, 219, 186, ' ', 219, 219, 219, 219, 186, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line10:      db 186, '   ', 176, 176, '  ', 219, 219, 219, 219, 219, 219, 219, 219, 186, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 186, 219, 219, 186, '  ', 219, 219, 219, 219, 186, 219, 219, 219, 219, 219, 219, 219, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line11:      db 186, '   ', 176, 176, '  ', 219, 219, 188, 205, 205, 205, 219, 219, 186, 219, 219, 188, 205, 205, 205, 205, 219, 219, 186, 219, 219, 188, 205, 205, 219, 219, 219, 219, 188, 205, 205, 205, 205, 205, ' ', 176, 176, '  ', 186, 0x0d, 0x0a, 0
banner_line12:      db 186, '   ', 176, 176, 176, 176, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 176, 176, 176, 176, '    ', 186, 0x0d, 0x0a, 0
banner_line13:      db 186, '                                           ', 186, 0x0d, 0x0a, 0
banner_line14:      db 186, '        BUILT BY t141gj-wq                ', 186, 0x0d, 0x0a, 0
banner_line15:      db 186, '      FAST ', 7, ' LIGHT ', 7, ' POWERFUL             ', 186, 0x0d, 0x0a, 0
banner_line16:      db 200, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 188, 0x0d, 0x0a, 0

; Boot sector signature
fill: times 510 - ($ - $$) db 0
db 0x55, 0xaa
