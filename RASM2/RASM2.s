.global _start

.data
// CONSTANTS
.equ INBUFSIZE, 12
.equ MIN, 0
.equ MAX, 100
// VARIABLES
// Output in the header
author:     .asciz "Codey Huntting"
date:       .asciz "03/13/2019"
program:    .asciz "RASM2"
// Strings input by the user
strInput1:  .skip INBUFSIZE
strInput2:  .skip INBUFSIZE
// Strings input by the user converted into integers
intInput1:  .word 0
intInput2:  .word 0
// Sum/difference/product/quotient 
// of the two numbers input by the user
sum:        .word 0
diff:       .word 0
product:    .word 0
quotient:   .word 0
remainder:  .word 0
// Sum/difference/product/quotient 
// converted to strings
sumStr:         .skip INBUFSIZE
diffStr:        .skip INBUFSIZE
productStr:     .skip INBUFSIZE
quotientStr:    .skip INBUFSIZE
remainderStr:   .skip INBUFSIZE
// Messages that precede the report of the mathematical reports
sumMsg:         .asciz "The sum is:        "
diffMsg:        .asciz "The difference is: "
productMsg:     .asciz "The product is:    "
quotientMsg:    .asciz "The quotient is:   "
remainderMsg:   .asciz "The remainder is:  "
// Strings used to put together the correct 
// overflow message in the event of an overflow
addingOverflowMsg:      .asciz "OVERFLOW OCCURRED WHEN ADDING\n"
subtractingOverflowMsg: .asciz "OVERFLOW OCCURRED WHEN SUBTRACTING\n"
multiplyingOverflowMsg: .asciz "OVERFLOW OCCURRED WHEN MULTIPLYING\n"
dividingOverflowMsg:    .asciz "OVERFLOW OCCURRED WHEN DIVIDING\n"
// Message output when the program termintates
goodbyeMsg:  	    .asciz "Thanks for using my program! Have a good day!\n"
// TEMP
resultStr:	.skip INBUFSIZE
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
    // Get the second integer and store the result
    bl GetIntInput
    ldr r1, =intInput2
    str r0, [r1]
    // Put an endline
    ldr r1, =endl
    bl putch
    // Store first integer in a register
    ldr r8, =intInput1
    ldr r8, [r8]
    // Store second integer in another register
    ldr r9, =intInput2
    ldr r9, [r9]

    /*
    SUM OF TWO NUMBERS AND OUTPUT
    */
    adds r0, r8, r9
    ldr r1, =sumMsg
    ldr r2, =addingOverflowMsg
    // Save the arguments before calling other subroutines
	mov r4, r1
	mov r5, r2
	// Check for an overflow error
    bvs _overflow
    // Convert r0 to a string
    ldr r1, =resultStr
    bl intasc32
    // Output message
    mov r1, r4
    bl putstring
    // Output the calculation result
    ldr r1, =resultStr
    bl putstring
    // Put an endline
    ldr r1, =endl
    bl putch
    bal _end
    _overflow:
        // Output the appropriate overflow error message
        mov r1, r5
        bl putstring
    _end:

    /*
    DIFFERENCE OF TWO NUMBERS AND OUTPUT
    */
    subs r0, r8, r9
    ldr r1, =diffMsg
    ldr r2, =subtractingOverflowMsg
    bl OutputCalculationResult

    /*
    MULTIPLY TWO NUMBERS AND OUTPUT
    */
    muls r0, r8, r9
    ldr r1, =productMsg
    ldr r2, =multiplyingOverflowMsg
    bl OutputCalculationResult

    // Linux syscall to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
