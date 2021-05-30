; Summary: create new directory from path given in program argument
; Date: May 29 2021
; Example: ./maked dir

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

    ; load program argument into preallocated memory address space
    MOV     rdi, [rsp + 16]
    MOV     rsi, dir
    CALL    _load_program_arg

    ; call sys_mkdir system call to create new directory
    MOV     rax, 83
    MOV     rdi, dir
    ; MOV     rdi, 0644o
    MOV     rsi, 0754o
    SYSCALL

; check if sys_mkdir was called successfully
.I2:

    CMP     rax, 0
    JGE     .E2

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, error_create_dir
    MOV     rdx, 33
    SYSCALL

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, newline
    MOV     rdx, 1
    SYSCALL

    JMP     _terminate

.E2:

    JMP _terminate

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
    error_create_dir:   DB "Error: Unable to Create Directory"
    newline:            DB 0xa

section .bss

    dir:             RESB 255