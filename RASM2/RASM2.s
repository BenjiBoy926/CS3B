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
remainder:      .skip INBUFSIZE
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
    // Store first integer
    ldr r8, =intInput1
    str r8, [r8]
    // Store second integer
    ldr r9, =intInput2
    str r9, [r9]

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
    ldr r1, =diffMsg
    ldr r2, =subtractingOverflowMsg
    bl OutputCalculationResult

    @ _loopbody:
    @     // Prompt user for input
    @     ldr r1, =inPrompt
    @     bl putstring
    @     // Store user input into a string
    @     ldr r1, =strInput
    @     mov r2, #INBUFSIZE
    @     bl getstring
    @     // Try to convert the string to an integer
    @     ldr r1, =strInput
    @     bl ascint32
    @     // If integer input is negative, exit the loop
    @     cmp r0, #0
    @     blt _end
    @     // "Clear" the cpsr with simple move instruction
    @     movs r1, #1
    @     // If "carry" is set and r0 is 0, the string could not be converted to an integer
    @     cmpcs r0, #0
    @     beq _inputinvalid 
    @     _inputvalid:
    @         // Check to see if integer input is within range of min-max
    @         mov r1, r0
    @         mov r2, #MIN
    @         mov r3, #MAX
    @         bl InRange
    @         // Check contents of r0 to see if int value is in range
    @         cmp r0, #0
    @         bne _inputinrange
    @         beq _inputoutrange
    @     _inputinvalid:
    @         // Output invalid value message
    @         ldr r1, =invalidValMsg
    @         bl putstring
    @         bal _loopend
    @     _inputinrange:
    @         // Get the letter grade if input is out of range    
    @         bl GetGrade
    @         // Store letter grade in r4 for safekeeping
    @         ldr r1, =letterGrade
    @         str r0, [r1]
    @         // Title string for reporting result
    @         ldr r1, =resultReport
    @         bl putstring
    @         // Put grade character currently stored by r0
    @         ldr r1, =letterGrade
    @         bl putch
    @         // Put an endline
    @         ldr r1, =endl
    @         bl putch
    @         bal _loopend
    @     _inputoutrange:
    @         // Output appropriate error message if input is out of range
    @         ldr r1, =invalidRangeMsg
    @         bl putstring
    @         bal _loopend
    @ _loopend:
    @     // Put an endline and loop again
    @     ldr r1, =endl
    @     bl putch
    @     bal _loopbody
    @ _end:
	@ // Output goodbye message
	@ ldr r1, =goodbyeMsg
	@ bl putstring
        // Linux syscall to terminate the program
        mov r0, #0
        mov r7, #1
        swi 0
        .end

