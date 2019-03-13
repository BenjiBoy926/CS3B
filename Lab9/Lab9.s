.global _start

.data
// CONSTANTS
.equ INBUFSIZE, 512
.equ MAXDIGITS, 12
.equ MIN, 0
.equ MAX, 100
// VARIABLES
// Output in the header
author:     .asciz "Codey Huntting"
date:       .asciz "03/13/2019"
program:    .asciz "Lab9"
// Integers input as strings
strInput1:  .skip MAXDIGITS
strInput2:  .skip MAXDIGITS
// Integers input by the user to divide
intInput1:  .word 0
intInput2:  .word 0
// Result intInput1 / intInput2
quotient:   .word 0
// Quotient converted to a string
quotientStr:    .skip MAXDIGITS
// Messages that precede the report of the mathematical reports
slash:  .asciz " / "
equal:  .asciz " = "
// Message output if divide by zero occurs 
divByZeroMsg:           .asciz "Cannot divide by zero!\n"
// Endline
.balign 4
endl:   .byte 10

.balign 4
.text
_start:
    // Output a header with the data about this program
    ldr r0, =author
    ldr r1, =date
    ldr r2, =program
    bl OutputHeader

    /*
    GETTING TWO NUMBERS AS INPUT
    */

    // Get the first integer and store the result
    bl GetIntInput
    ldr r1, =intInput1
    str r0, [r1]
    // Convert the input to ascii string
    ldr r1, =strInput1
    bl intasc32
    
    // Get the second integer and store the result
    bl GetIntInput
    ldr r1, =intInput2
    str r0, [r1]
    // Conver the input to ascii string
    ldr r1, =strInput2
    bl intasc32

    // Put an endline
    ldr r1, =endl
    bl putch

    // Store first integer
    ldr r8, =intInput1
    ldr r8, [r8]
    // Store second integer
    ldr r9, =intInput2
    ldr r9, [r9]

    /*
    DIVIDE TWO NUMBERS AND OUTPUT
    */
    mov r1, r8
    mov r2, r9
    bl idiv
    // idiv sets the overflow flag if there's divide by zero
    bvs _if__divbyzero
    // Output error message for divide by zero
    _if__divbyzero:
        ldr r1, =divByZeroMsg
        bl putstring
        bal _endif__divbyzero
    // Output result for successful divide
    _else__divbyzero:
        // Store the quotient as a string
        ldr r1, =quotientStr
        bl intasc32
        // Output (int1) / (int2) = (quotient)
        ldr r1, =strInput1
        bl putstring
        ldr r1, =slash
        bl putstring
        ldr r1, =strInput2
        bl putstring
        ldr r1, =equal
        bl putstring
        ldr r1, =quotientStr
        bl putstring
        // Put an endline
        ldr r1, =endl
        bl putch
    _endif__divbyzero:

    // Linux syscall to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
