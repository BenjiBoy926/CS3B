.global AddToList

.equ BUFSIZE, 512
.equ MIN_CH, 'a'
.equ MAX_CH, 'b'

.data
inputCharPrompt:	.asciz "Enter a character (a or b): "
inputStrPrompt:		.asciz "Enter the string to add to the list: "
inputStrConfirm:	.asciz "String added!\n\n"
inBuffer:	.skip BUFSIZE
inFile:		.asciz "input.txt"

/*
void AddToList(r0 list)
-----------------------
Helper for rasm4 that recieves a character 'a' or 'b'
to add a custom string from the user or load strings from
"input.txt"
-----------------------
*/

.text
.balign 4
AddToList:
	push {r4-r8, r10-r12, lr}

	// Preserve the pointer to the list
	mov r4, r0

	// Get either an 'a' or a 'b'
	mov r0, #MIN_CH
	mov r1, #MAX_CH
	ldr r2, =getch
	bl GetValueInRange
	// Store the value received
	mov r5, r0
	
	atl__switch__option:
		// If option 'a' is input, get a string from the user
		cmp r5, #'a'
		beq atl__if__add_str_input

		// Use helper to add a string input
		atl__if__add_str_input:
			mov r0, r4
			bl AddStringInput
		atl__endif__add_str_input:

		// Branch out of switch
		cmp r5, #'a'
		beq atl__endswitch__option

		cmp r5, #'b'
		// Add strings from file to list helper
	atl__endswitch__option:

	pop {r4-r8, r10-r12, pc}

// r0 getch()
getch:
	push {r4-r8, r10-r12, lr}

	// Output a prompt
	ldr r1, =inputCharPrompt
	bl putstring

	// Get a string
	ldr r1, =inBuffer
	mov r2, #BUFSIZE
	bl getstring
	// Return the first character in the string
	ldrb r0, [r1]

	pop {r4-r8, r10-r12, pc}

// void AddStringInput(r0 list)
AddStringInput:
	push {r4-r8, r10-r12, lr}

	// Store list pointer
	mov r4, r0

	// Output a prompt
	ldr r1, =inputStrPrompt
	bl putstring

	// Get a string
	ldr r1, =inBuffer
	mov r2, #BUFSIZE
	bl getstring

	// Add the string inputed by the user
	mov r0, r4
	bl List_addstr

	// Output string added confirmation
	ldr r1, =inputStrConfirm
	bl putstring

	pop {r4-r8, r10-r12, pc}
	