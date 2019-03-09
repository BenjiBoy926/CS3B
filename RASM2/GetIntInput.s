.global GetIntInput

// Amount of bytes allocated for input
.equ INBUFSIZE 512

.data
// Return address, stored to preserve the value
retAddr:	.word 0
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

GetIntInput:
	// Store the contents of the link register
	ldr r1, =retAddr
	str lr, [r1]
	_inloop:
		// Get string input from the user
		ldr r1, =inBuffer
		ldr r2, #INBUFSIZE
		bl getstring
		// Convert the input to an integer
		ldr r1, =inBuffer
		bl ascint32
		// "Clear" the cpsr with simple move instruction
        movs r1, #1
		// Input is invalid if r0 = 0 and carry flag is set
		cmpcs r0, #0
		beq _inputinvalid
		// Input is too big if r0 = 0 and overflow flag is set
		cmpvs r0, #0
		beq _inputoverflow
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
		ldr lr, =retAddr
		ldr lr, [lr]
		bx lr