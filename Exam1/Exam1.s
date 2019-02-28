.global _start

.equ BUFSIZE, 12

.data
name:               .asciz "Codey Huntting"
date:               .asciz "02/27/2019"
program:            .asciz "Exam 1"
prompt:             .asciz "Enter a whole number: "
summary:            .asciz "The addresses of the 4 ints: "
space:              .asciz "   "
plus:               .asciz " + "
minus:              .asciz " - "
mult:               .asciz " * "
equals:             .asciz " = "
leftparenthesis:    .byte 40
rightparenthesis:   .byte 41
endl:               .byte 10

// Array contains blocks of memory for the ascii inputs from the user
inputstrings:
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
endinputstrings:
// Array of data words of the inputs converted to ints
ints:
.word 0, 0, 0
endints:
// Result of the calculation of the program
answer:     .word 0
answerstr:  .skip BUFSIZE
// Array of strings to display the addresses of the integers
addrstrings:
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
endaddrstrings:

@ Register Table
@ --------------
@ r0 -> device / intConvertedFromAscii / intsCurrentAddr                     
@ r1 -> baseAddr                              
@ r2 -> buffLen                                 
@ r3 -> internal                                
@ r4 -> inputCurrentAddr / answer / addressStrCurrentAddr
@ r5 -> inputsEndAddr / addressStrEndAddr
@ r6 -> intsCurrentAddr

.text
.balign 4
_start:
    // Output the header of the program
    ldr r0, =name
    ldr r1, =date
    ldr r2, =program
    bl OutputHeader

    _inputloopinit:
        // Intialize base address and end address of the array of inputs
        ldr r4, =inputstrings
        ldr r5, =endinputstrings
        ldr r6, =ints

    _inputloopcheck:
        // Branch to the end if currentAddr >= endAddr (r4 >= r5)
        cmp r4, r5
        beq _inputloopend
        bpl _inputloopend

    _inputloopbody:
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

    _inputloopchange:
        @ Add the size of one item in the input array to
        @ r4 so it points to the next input block
        add r4, r4, #BUFSIZE
        add r6, r6, #4
        bal _inputloopcheck
    
    _inputloopend:
        // Here, r0 will be used as the pointer to the integers instead of r4
        ldr r0, =ints
        ldr r4, [r0], #4
        ldr r5, [r0], #4
        ldr r6, [r0]
        // Calculate (r4 + r5) - (r6 + r7)
        mul r7, r4, r5
        add r7, r7, r6
        sub r7, r7, r4
        // Store the answer in the space at the "answer" label
        ldr r1, =answer
        str r7, [r1]
        // Convert contents of r4 to string and store in "answerstr"
        mov r0, r7
        ldr r1, =answerstr
        bl intasc32

        // Use r4 to iterate through the input strings
        ldr r4, =inputstrings

        // End the line
        ldr r1, =endl
        bl putch
        // Put first input string
        mov r1, r4
        add r4, r4, #BUFSIZE
        bl putstring
        // Put the multiply symbol
        ldr r1, =mult
        bl putstring
        // Put second input string
        mov r1, r4
        add r4, r4, #BUFSIZE
        bl putstring
        // Put plus sign
        ldr r1, =plus
        bl putstring
        // Put third input string
        mov r1, r4
        bl putstring
        // Put minus symbol
        ldr r1, =minus
        bl putstring
        // Put first input string again
        ldr r1, =inputstrings
        bl putstring
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
