cli

; Initialises VGA
; ah is left unconfigured since the default is fine.
mov ah, 0
; This sets it VGA mode 2, which is text.
mov al, 2
; Calls the interrupt for VGA.
int 0x10

; Says to draw the character in the al register.
mov ah, 0x0E
mov al, 'H'
mov bx, 0
int 0x10

mov ah, 0x0E
mov al, 'I'
mov bx, 0
int 0x10

; Marks the program as bootable.
times 510 - ($ - $$) db 0
; The magic numbers that say this, below, have to be in the last 512 bytes.
; Are there two numbers, or are we just doing a 16 bit number in two parts?
db 0x55
db 0xAA