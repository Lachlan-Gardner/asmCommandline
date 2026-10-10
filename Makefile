build: cli.asm
	nasm -f bin $^ -o cli.bin

run: build
	qemu-system-i386 -drive format=raw,file=cli.bin -display sdl