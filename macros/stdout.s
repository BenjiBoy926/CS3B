.global _stdout

_stdout:
    mov r0, #1  @ Indicate standard output to the monitor
    mov r7, #4  @ Syscall number 4 for output
    swi 0   @ Signal Linux to start routine

    @ Move link register back into program counter
    @ It ONLY WORKS if the caller used "branch and link"
    mov r15, r14
