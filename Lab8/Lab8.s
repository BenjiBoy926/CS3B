.global _start

.data
.equ INBUFSIZE, 12
.equ MIN, 0
.equ MAX, 100
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

.equ letterAsciiStart, 65

gradeLowerBounds: 
.byte 90, 80, 70, 60
endGradeLowerBounds:

.balign 4
.text
_start:
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
    @ bl GetGrade
    _loopstart:
        // Start letter grade at 'A'
        mov r0, #letterAsciiStart
        // Load r2 with the first grade bound
        ldr r2, =gradeLowerBounds
    _loopcheck:
        // If r2 points to the end of the grade array,
        // branch to the end of the loop
        ldr r3, =endGradeLowerBounds
        cmp r2, r3
        bge _loopend
    _loopbody:
        // Load r3 with current grade lower bound
        // LCV simultaneously updated, here
        ldr r3, [r2], #1
        // Break out of the loop if grade 
        // is greater than current grade lower bound
        cmp r1, r3
        bge _end
        // Increment r0 to a lower letter grade
        add r0, r0, #1
    _loopend:
        // If we got to this point, the student got an F,
        // so increment r0 past E to F
        add r0, r0, #1    
    _end:
        // Move the instruction pointed to by the link register into the program counter
        //mov pc, lr
    // Linux syscall to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0

