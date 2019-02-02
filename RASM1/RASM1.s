.global _start

.data
prompt: .ascii "Enter a whole number: "
inbuff: .ascii ""

.text
_start:
    @ Initialize the loop
    _loopinit:
        mov r4, #4  @ R4 is the number of times the loop runs
        mov r5, #0  @ R5 is the LCV update each loop
        cmp r4, r5  @ Compare max loops with number of loops run - it's a pre-check loop
    
    @ Check the loop
    _loopcheck:
        beq _loopend    @ Branch to the loop's end if the zero flag is set
    
    @ Calculations in the loop
    _loopbody:
        @ Output the prompt to the standard output
        ldr r1, =prompt
        mov r2, #22
        bl _stdout

        @ Get input from the keyboard
        ldr r1, =inbuff
        mov r2, #32
        bl _stdin

        bal _loopchange

    @ Update the LCV for the loop
    _loopchange:
        cmp r4, r5 
        bal _loopcheck

    _loopend:
        bal _end

_stdin:
    mov r0, #0  @ Indicate standard input from the keyboard
    mov r7, #3  @ Syscall number 3 for input
    swi 0   @ Signal Linux to start routine
    
    @ Move link register back into program counter
    @ It ONLY WORKS if the caller used "branch and link"
    mov r15, r14

_stdout:
    mov r0, #1  @ Indicate standard output to the monitor
    mov r7, #4  @ Syscall number 4 for output
    swi 0   @ Signal Linux to start routine

    @ Move link register back into program counter
    @ It ONLY WORKS if the caller used "branch and link"
    mov r15, r14

@ Syscall to terminate the program
_end:
    mov r0, #1
    mov r7, #1
    swi 0
    .end
