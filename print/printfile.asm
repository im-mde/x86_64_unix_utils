; Summary: print bytes of a file to stdout
; Date: May 23 2021
; Example: ./printfile file.txt

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
    MOV     rsi, filepath
    CALL    _load_program_arg

    MOV     rbx, rax

    ; open read file
    MOV     rax, 2
    MOV     rdi, filepath
    MOV     rsi, 0
    MOV     rdx, 0644o
    SYSCALL

    MOV     r12, rax

; check if read file successfully opened
.I2:

    CMP     rax, 0
    JGE     .E2

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, error_open_file
    MOV     rdx, 27
    SYSCALL

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, filepath
    MOV     rdx, rbx
    SYSCALL

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, newline
    MOV     rdx, 1
    SYSCALL

    JMP     _terminate

.E2:

; read byte-by-byte from file and write to stdout until EOF
.L1:

    MOV     rax, 0
    MOV     rdi, r12
    MOV     rsi, buffer
    MOV     rdx, 1
    SYSCALL

    CMP     rax, 0
    JE      .L2

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, rsi
    MOV     rdx, 1
    SYSCALL

    JMP     .L1

.L2:

    ; close file
    MOV     rax, r12
    SYSCALL

    JMP _terminate

_terminate:

    MOV     rax, 60
    SYSCALL

; rdi (arg): pointer to program argument from stack
; rsi (arg): pointer to memory address space
; rax (ret): number of bytes of program arg
_load_program_arg:

    MOV     r12, 0

.L1:

    CMP     BYTE [rdi + r12], 0
    JE      .L2
    
    MOV     r13, [rdi + r12]
    MOV     [rsi + r12], r13
    ADD     r12, 1
    JMP     .L1

.L2:

    MOV     rax, r12
    RET

section .data

    error_argc:         DB "Error: Invalid Argument Count", 0xa
    error_open_file:    DB "Error: Unable to Open File "
    newline:            DB 0xa

section .bss

    buffer:             RESB 1
    filepath:           RESB 255