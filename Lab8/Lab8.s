.global _start

.data
// CONSTANTS
.equ letterAsciiStart, 65
.equ INBUFSIZE, 12
.equ MIN, 0
.equ MAX, 100
// VARIABLES
// Output in the header
author:     .asciz "Codey Huntting"
date:       .asciz "03/05/2019"
program:    .asciz "Lab 8 - Grade"
// String integer input by user
strInput: .skip INBUFSIZE
// String integer input by user converted to an integer
intInput: .word 0
// Prompt for user input
inPrompt: .asciz "Enter number grade (0 - 100): "
// Endline ascii code
endl: .byte 10
// Message given if value is not an int
invalidValMsg:      .asciz "***ERROR*** invalid value\n"
// Message given if value is outside of valid range
invalidRangeMsg:    .asciz "***ERROR*** number outside of valid range\n"
// Prompt before printing the letter grade
resultReport:       .asciz "Letter Grade is: "

gradeLowerBounds: 
.word 90, 80, 70, 60
endGradeLowerBounds:

.balign 4
.text
_start:
    // Output a header with the data about this program
    ldr r0, =author
    ldr r1, =date
    ldr r2, =program
    bl OutputHeader
    // Prompt user for input
    ldr r1, =inPrompt
    bl putstring
    // Store user input into a string
    ldr r1, =strInput
    mov r2, #INBUFSIZE
    bl getstring
    // Convert the strInput from r1 to an int - result stored in r0
    ldr r1, =strInput
    bl ascint32
    // Check to see if integer input is within range of min-max
    mov r1, r0
    mov r2, #MIN
    mov r3, #MAX
    bl InRange
    bl GetGrade
    // Linux syscall to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end

