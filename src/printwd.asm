; Summary: print path of working directory to stdout
; Date: May 23 2021
; Example: ./printwd

section .text

global      _start 

_start: 

    ; call sys_getcwd
    MOV     rax, 79
    MOV     rdi, buffer
    MOV     rsi, 255
    SYSCALL

    ; write to stdout value of buffer
    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, buffer
    MOV     rdx, 255
    SYSCALL

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, newline
    MOV     rdx, 1
    SYSCALL

    ; terminate
    MOV     rax, 60
    SYSCALL

section .data

    newline:    db 0xa
    
section .bss

    buffer:     resb 1024