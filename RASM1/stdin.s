.global _stdin

_stdin:
    mov r0, #0  @ Indicate standard input from the keyboard
    mov r7, #3  @ Syscall number 3 for input
    swi 0   @ Signal Linux to start routine
    
    @ Move link register back into program counter
    @ It ONLY WORKS if the caller used "branch and link"
    mov r15, r14
