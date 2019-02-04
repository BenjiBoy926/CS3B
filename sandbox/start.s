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
        add r5, r5, #1
	    cmp r4, r5 
        bal _loopcheck

    _loopend:
        bal _end
