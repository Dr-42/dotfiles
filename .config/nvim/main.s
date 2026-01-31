;; Print Hello World to the console using x86-64 assembly (Linux)

section .data
    hello db 'Hello, World!', 0xA  ; The string to print, followed by a newline
    hello_len equ $ - hello          ; Calculate the length of the string
section .text
    global _start                    ; Entry point for the program
_start:
    ; Write the string to stdout
    mov rax, 1                      ; syscall: sys_write
    mov rdi, 1                      ; file descriptor: stdout
    mov rsi, hello                  ; pointer to the string
    mov rdx, hello_len              ; length of the string
    syscall                         ; invoke the kernel

    ; Exit the program
    mov rax, 60                     ; syscall: sys_exit
    xor rdi, rdi                    ; exit code 0
    syscall                         ; invoke the kernel
; To assemble and run this code:
; nasm -f elf64 main.s -o main.o
