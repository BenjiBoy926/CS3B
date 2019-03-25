.global GetIntInput

.data
.equ INBUFSIZE, 512
// Return address, stored to preserve the value
retAddr:	.word 0
// Prompt for input
inputPrompt:	.asciz "Enter a number: "
// String input by user
strInput:	.skip INBUFSIZE
// Messages output in the case of invalid inputs
inputInvalidMsg:	.asciz "INVALID NUMERIC STRING. RE-ENTER VALUE\n"
inputOverflowMsg:	.asciz "OVERFLOW OCCURRED. RE-ENTER VALUE\n"

/*
r0 GetIntInput()
----------------
Get an input for any integer. Checks to makes sure that the string
can be interpreted as an int, and that the integer is not too big
----------------
*/

.balign 4
.text
GetIntInput:
	// Store the contents of the link register
	push {r1-r12, lr}
	_inloop:
		// Output the input prompt
		ldr r1, =inputPrompt
		bl putstring 
		// Get string input from the user
		ldr r1, =strInput
		mov r2, #INBUFSIZE
		bl getstring
		// Convert the input to an integer
		ldr r1, =strInput
		bl ascint32
		// Input is too big if overflow flag is set
		bvs _inputoverflow
		// Input is invalid if r0 = 0 and carry flag is set
		cmpcs r0, #0
		beq _inputinvalid
		// If we make it past the previous branches, branch to the end
		bal _inputsuccess
	_inputinvalid:
		// Output invalid message
		ldr r1, =inputInvalidMsg
		bl putstring
		// Branch back to the input loop
		bal _inloop
	_inputoverflow:
		// Output overflow message
		ldr r1, =inputOverflowMsg
		bl putstring
		//Branch back to the input loop
		bal _inloop
	_inputsuccess:
		// Branch back to the return address saved at the start
		pop {r1-r12, pc}
