org 0x7c00

jmp _start

tophat: db "\        #################\        #################\        #################\        #################\        #################\        #################\     ########################\ \          ###       ###\          ###       ###\ \ \     ###                 ###\      ###               ###\       ###             ###\        #################", 0x00
tophat_prompt: db "Smiley face (y/anything else): ", 0x00
; message: db "Hel\lo.", 0x00

_modulus:
	mov cx, di
	_loop:
		sub cx, 160

		cmp cx, 160
		ja _loop

	sub di, cx
	jmp _after_modulus

_reset_di:
	mov di, 0

	jmp _after_modulus

_newline:
	inc si

	cmp di, 160
	ja _modulus

	jmp _reset_di

	_after_modulus:

	add di, 160

	jmp _next_char

; Use si and di registers to hold message
; The message must be put into si first.
_print:
	; Moves the destination into es.
	; Can't be written into directly.
	mov ax, 0xB800
	mov es, ax
	; Which character we're up to.

	_next_char:
		cmp [si], '\'
		je _newline

		mov bx, [si]
		mov [es:di], bx

		inc di
		; Adds colour
		mov [es:di], 0x07
		inc di
		inc si

		cmp [si], 0x0
		jne _next_char

	; Returns, just like a normal return from a function
	ret

_get_input:
	inc di
	inc di

	mov ax, 0xB800
	mov es, ax

	mov ax, 0

	int 0x16

	movzx bx, al
	mov [es:di], bx

	inc di
	; Adds colour
	mov [es:di], 0x07
	inc di

	cmp al, 'y'
	je _tophat

	ret

_start:
	; Initialises VGA
	; ah is left unconfigured since the default is fine.
	mov ah, 0
	; This sets it VGA mode 2, which is text.
	mov al, 2
	; Calls the interrupt for VGA.
	int 0x10

	mov di, 0

	mov si, tophat_prompt
	call _print

	call _get_input

	jmp _exit

	_tophat:
		; Move the message into the source register.
		mov si, tophat

		call _print

	_exit:

	; Marks the program as bootable.
	times 510 - ($ - $$) db 0
	; The magic numbers that say this (below) have to be in the last 512 bytes.
	; Are there two numbers, or are we just doing a 16 bit number in two parts?
	db 0x55
	db 0xAA