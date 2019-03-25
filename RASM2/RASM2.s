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
program:    .asciz "RASM2"
// Integers input by the user converted into integers
intInput1:  .word 0
intInput2:  .word 0
// Sum/difference/product/quotient 
// of the two numbers input by the user
sum:            .word 0
diff:           .word 0
product:        .word 0
quotient:       .word 0
remainderVar:   .word 0
// Sum/difference/product/quotient/remainder 
// converted to strings
sumStr:         .skip MAXDIGITS
diffStr:        .skip MAXDIGITS
productStr:     .skip MAXDIGITS
quotientStr:    .skip MAXDIGITS
remainderStr:   .skip MAXDIGITS
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
divByZeroMsg:           .asciz "Cannot divide by zero!\n"
// Message output when the program termintates
goodbyeMsg: .asciz "Thanks for using my program! Have a good day!\n"
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

    _while__inputexists:
        /*
        GETTING TWO NUMBERS AS INPUT
        */
        // Get the first integer and store the result
        bl GetIntInput
        // Branch to end if no input is given
        beq _endwhile__inputexists
        // Store the input
        ldr r1, =intInput1
        str r0, [r1]
        // Get the second integer and store the result
        bl GetIntInput
        // Branch to end if no input is given
        beq _endwhile__inputexists
        // Store the input
        ldr r1, =intInput2
        str r0, [r1]
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
        SUM OF TWO NUMBERS AND OUTPUT
        */
        adds r0, r8, r9
        ldr r1, =sumMsg
        ldr r2, =addingOverflowMsg
        bl OutputCalculationResult

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

        /*
        DIVIDE TWO NUMBERS AND OUTPUT
        */
        mov r1, r8
        mov r2, r9
        bl idiv
        ldr r1, =quotientMsg
        ldr r2, =divByZeroMsg
        bl OutputCalculationResult

        /*
        REMAINDER OF TWO NUMBERS AND OUTPUT
        */
        mov r1, r8
        mov r2, r9
        bl remainder
        ldr r1, =remainderMsg
        ldr r2, =divByZeroMsg
        bl OutputCalculationResult

        // Branch back to the start of the loop
        bal _while__inputexists
    _endwhile__inputexists:
        // Output the goodbye message
        ldr r1, =endl
        bl putch
        ldr r1, =goodbyeMsg
        bl putstring
        ldr r1, endl
        bl putch
        // Linux syscall to terminate the program
        mov r0, #0
        mov r7, #1
        swi 0
        .end
