; Summary: copy bytes of a file to another file, creating the other file if it doesn't exist
; Date: May 23 2021
; Example: ./copy file1.txt file2.txt

section .text

global      _start 

_start: 

    ; check that only 2 args passed to program
    CMP     BYTE [rsp], 3
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

    ; load 1st program argument to pre-allocated address space at from_filepath
    MOV     rdi, [rsp + 16]
    MOV     rsi, from_filepath
    CALL    _load_program_arg

    ; load 2nd program argument to pre-allocated address space at to_filepath
    MOV     rdi, [rsp + 24]
    MOV     rsi, to_filepath
    CALL    _load_program_arg

    ; open read file
    MOV     rax, 2
    MOV     rdi, from_filepath
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
    MOV     rsi, error_openi
    MOV     rdx, 33
    SYSCALL

    JMP     _terminate

.E2:
  
    ; open write file
    MOV     rax, 2
    MOV     rdi, to_filepath
    MOV     rsi, 65
    MOV     rdx, 0644o
    SYSCALL

    ; hold write file fd
    MOV     r13, rax

; check if write file successfully opened
.I3:

    CMP     rax, 0
    JGE     .E3

    MOV     rax, 1
    MOV     rdi, 1
    MOV     rsi, error_openo
    MOV     rdx, 34
    SYSCALL

    JMP     _terminate

.E3:

; read byte-by-byte from read file and write to write file until EOF of read file
.L1:

    ; read byte from read file
    MOV     rax, 0
    MOV     rdi, r12
    MOV     rsi, buffer
    MOV     rdx, 1
    SYSCALL

    CMP     rax, 0
    JE      .L2

    ; write byte to write file
    MOV     rax, 1
    MOV     rdi, r13
    MOV     rsi, rsi
    MOV     rdx, 1
    SYSCALL

    JMP     .L1

.L2:

    ; close read file
    MOV     rax, r12
    SYSCALL

    ; close write file
    MOV     rax, r13
    SYSCALL

    JMP _terminate

_terminate:    MOV     rax, [rsp]

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

    error_argc:     DB "Error: Invalid Argument Count", 0xa
    error_openi:    DB "Error: Unable to Open Input File", 0xa
    error_openo:    DB "Error: Unable to Open Output File", 0xa

section .bss

    buffer:         RESB 1
    from_filepath:  RESB 255
    to_filepath:    RESB 255