.global _start
.global _end

.equ BUFSIZE, 12

.data
prompt:     .asciz "Enter a whole number: "
summary:    .asciz "The addresses of the 4 ints: "
plus:       .asciz " + "
minus:      .asciz " - "
equals:     .asciz " = "
leftparenthesis:   .byte 40
rightparenthesis:  .byte 41
endl:       .byte  13

// Array contains blocks of memory for the ascii inputs from the user
inputstrings:
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
endinputstrings:
// Array of data words of the inputs converted to ints
ints:
.word 0, 0, 0, 0
endints:
// Result of the calculation of the program
answer:     .word 0
answerstr:  .skip BUFSIZE

@ Register Table
@ --------------
@ r0 -> device / intConvertedFromAscii / intsCurrentAddr                     
@ r1 -> baseAddr                              
@ r2 -> buffLen                                 
@ r3 -> internal                                
@ r4 -> inputCurrentAddr / answer     
@ r5 -> inputsEndAddr / inputCurrentAddr
@ r6 -> intsCurrentAddr  

.text
.balign 4
_start:
    _loopinit:
        // Intialize base address and end address of the array of inputs
        ldr r4, =inputstrings
        ldr r5, =endinputstrings
        ldr r6, =ints

    _loopcheck:
        // Branch to the end if currentAddr >= endAddr (r4 >= r5)
        cmp r4, r5
        beq _loopend
        bpl _loopend

    _loopbody:
        @ Prompt for first integer
        ldr r1, =prompt
        bl putstring

        @ Get string from console and store it 
        @ in the block currently pointed to by r4
        mov r1, r4
        mov r2, #BUFSIZE
        bl getstring

        @ Branch to ascint macro to convert data pointed to by r1 to an int and store the int in r0
        mov r1, r4
	    bl ascint32
        
        @ Store r0 into the current byte word pointed to by r6
        str r0, [r6]

    _loopchange:
        @ Add the size of one item in the input array to
        @ r4 so it points to the next input block
        add r4, r4, #BUFSIZE
        add r6, r6, #4
        bal _loopcheck
    
    _loopend:
    // Here, r0 will be used as the pointer to the integers instead of r4
    ldr r0, =ints
    ldr r4, [r0], #4
    ldr r5, [r0], #4
    ldr r6, [r0], #4
    ldr r7, [r0]
    // Calculate (r4 + r5) - (r6 + r7)
    add r4, r4, r5
    add r5, r6, r7
    sub r4, r4, r5
    // Store the answer in the space at the "answer" label
    ldr r1, =answer
    str r4, [r1]
    // Convert contents of r4 to string and store in "answerstr"
    mov r0, r4
    ldr r1, =answerstr
    bl intasc32

    // Use r4 to iterate through the input strings
    ldr r4, =inputstrings
    // Put left parenthesis
    ldr r1, =leftparenthesis
    bl putch
    // Put first input string
    mov r1, r4
    add r4, r4, #BUFSIZE
    bl putstring
    // Put plus symbol
    ldr r1, =plus
    bl putstring
    // Put second input string
    mov r1, r4
    add r4, r4, #BUFSIZE
    bl putstring
    // Put right parenthesis
    ld r1, =rightparenthesis
    bl putch
    // Put minus sign
    ld r1, =minus
    bl putstring
    // Put left parenthesis
    ldr r1, =leftparenthesis
    bl putch
    // Put third input string
    mov r1, r4
    add r4, r4, #BUFSIZE
    bl putstring
    // Put plus symbol
    ldr r1, =plus
    bl putstring
    // Put fourth input string
    mov r1, r4
    bl putstring
    // Put right parenthesis
    ld r1, =rightparenthesis
    bl putch
    // Put plus symbol
    ldr r1, =equals
    bl putstring
    // Put answer string into buffer
    ldr r1, =answerstr
    bl putstring
    // End the line
    ldr r1, =endl
    bl putch

    @ Service call to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
