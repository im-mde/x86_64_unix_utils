# x86-64 Unix Utilities
Repository containg basic x86-64 NASM assembly utilties demonstrating Linux 
system calls.

## Assembling and Linking
The utilities written in this repository are build around the NASM assembler 
which is a requirement for assembly. Additionally, it is using 64 bit mode that
will need to be specified in the assembly command.

``` nasm -f elf64 src/printwd.asm -o build/printwd.o ```

There should now be an assembled object file in the build directory. The next
step is to link-edit to an executable file.

``` ld build/printwd.o -o printwd ```

An executable file should now exist. If execute authority is permitted, the
utility can now be used.

``` ./printwd ```

## Linux Syscall & NASM References
* [NASM Tutorial](https://cs.lmu.edu/~ray/notes/nasmtutorial/)
* [Direct Operating System Access via Syscalls](https://www.cs.uaf.edu/2017/fall/cs301/lecture/11_17_syscall.html)
* [64-bit Syscall Table](https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl)