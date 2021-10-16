; Summary: delete file from passed pathname via unlink syscall
; Date: May 23 2021
; Example: ./deletef Documents/test.txt

section .text

global      _start 

_start: 

    ; check that only 1 arg passed to program
    CMP     BYTE [rsp], 2
    JNE     .I1
    JMP     .E1

.I1:

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, error_argc
    MOV     rdx, 30
    SYSCALL

    JMP _terminate

.E1:

    ; load program argument into preallocated memory address space file
    MOV     rdi, [rsp + 16]
    MOV     rsi, filepath
    CALL    _load_program_arg

    ; call unlink syscall
    MOV     rax, 87
    MOV     rdi, filepath
    SYSCALL

; check if file deleted successfully
.I2:

    CMP     rax, 0
    JGE     .E2

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, error_delete_file
    MOV     rdx, 24
    SYSCALL

    JMP     _terminate

.E2:
    
    JMP     _terminate

_terminate:  

    MOV     rax, 60
    SYSCALL

; rdi (arg): pointer to program argument from stack
; rsi (arg): pointer to memory address space
; rax (ret): number of bytes of program arg
_load_program_arg:

    MOV     rax, 0

.L1:

    CMP     BYTE [rdi + rax], 0
    JE      .L2
    
    MOV     rdx, [rdi + rax]
    MOV     [rsi + rax], rdx
    ADD     rax, 1
    JMP     .L1

.L2:

    RET

section .data

    error_argc:         DB "Error: Invalid Argument Count", 0xa
    error_delete_file:  DB "Error: File not deleted", 0xa

section .bss

    filepath:    RESB 255