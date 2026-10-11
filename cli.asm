org 0x7c00

jmp _start

message: db "Hel\lo...", 0x00

_newline:
	mov bx, ' '
	mov [es:di], bx

	inc di
	; Adds colour
	mov [es:di], 0x07	
	inc di

	dec cx	

	cmp cx, 0
	ja _newline

	mov cx, 80
	inc si
	jmp _print

; Use si and di registers to hold message
; The message must be put into si first.
_print:
	; There are 80 columns in the vga text buffer, so this gets to the new line.
	mov cx, 80
	cmp [si], '\'
	je _newline

	mov bx, [si]
	mov [es:di], bx

	inc di
	; Adds colour
	mov [es:di], 0x07	
	inc di
	inc si

	cmp [si], 0
	jne _print

	; Returns, just like a normal return from a function
	ret

_start:
	cli
	; Initialises VGA
	; ah is left unconfigured since the default is fine.
	mov ah, 0
	; This sets it VGA mode 2, which is text.
	mov al, 2
	; Calls the interrupt for VGA.
	int 0x10

	; Move the message into the source register.
	mov si, message

	; Moves the destination into es.
	; Can't be written into directly.
	mov ax, 0xB800
	mov es, ax
	; Which character we're up to.
	mov di, 0

	call _print

	; Marks the program as bootable.
	times 510 - ($ - $$) db 0
	; The magic numbers that say this, below, have to be in the last 512 bytes.
	; Are there two numbers, or are we just doing a 16 bit number in two parts?
	db 0x55
	db 0xAA