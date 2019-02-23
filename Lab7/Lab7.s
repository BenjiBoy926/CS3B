.global _start

.equ BUFSIZE, 12
.equ CMP, 0

.data
prompt: .asciz "Enter an integer: "
// String input as an ascii code
strinput: .skip BUFSIZE
// String version of the number used for comparison is stored here
strcmp: .skip BUFSIZE
gemsg: .asciz " is greater than "
lemsg: .asciz " is less than "
eqmsg: .asciz " is equal to "
endl: .byte 10

/*
REGISTER TABLE
--------------
r0 - integer input, macro argument
r1 - string input/output
r2 - input buffer, integer input
r3 - address of message to output (greater than, equal to or less than message)
--------------
*/
.balign 4
.text
_start:
    // Output the prompt for user input
    ldr r1, =prompt
    bl putstring
    // Get a string from user input
    ldr r1, =strinput
    mov r2, #BUFSIZE
    bl getstring
    // Convert string input to integer and store result in r0
    ldr r1, =strinput
    bl ascint32
    // Move integer input into r3 for safekeeping
    mov r2, r0
    // Convert the comparison number into a string
    mov r0, #CMP
    ldr r1, =strcmp
    bl intasc32
    // Compare the integer input with the comparison number
    // Branch to corresponding labels if it is greater than or equal to
    cmp r2, #CMP
    bgt _greater
    beq _equal
    // Store the correct message in r3, and branch to output
    ldr r3, =lemsg
    bal _output

    _greater:
        // Store the correct message in r3, and branch to output
        ldr r3, =gemsg
        bal _output
    
    _equal:
        // Store the correct message in r3, and branch to output
        ldr r3, =eqmsg
        bal _output

    _output:
        // Output what the user input
        ldr r1, =strinput
        bl putstring
        // Output the string pointed to by r3
        mov r1, r3
        bl putstring
        // Output the number compared
        ldr r1, =strcmp
        bl putstring
	// Put the endline character after output
	ldr r1, =endl
	bl putch
        // Terminate the program
        mov r0, #0
        mov r7, #1
        swi 0
    
