.global _end

@ Syscall to terminate the program
_end:
    mov r0, #1
    mov r7, #1
    swi 0
    .end
