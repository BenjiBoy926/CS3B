/*
RASM4
-----
A very (very) basic text editor in assembly language
Maintains a linked list of strings.  The user can do
each of the following:

1) View strings
2) Add string
	a) from keyboard
	b) from file
3) Delete string (by index)
4) Replace string at index with string from keyboard
5) Search string that contain a substring
6) Save file to another file called output.txt
7) Quit
-----
*/

.global _start

.extern system

.data
.equ MIN_OPTION, 1
.equ MAX_OPTION, 7
.equ BUFSIZE, 512

// Stores a pointer to the string list used to dynamically store all of the strings
stringList:	.word 0
// Feedback displayed if user enters invalid option
inputInvalidPrompt:	.asciz "*** ERROR: please input a number between 1 and 7 ***\n"
// Endline ascii code
endl:	.byte 10

// Clear command for the c++ system call
clearCmd:	.asciz "clear"

// Prompt user for any key
pausePrompt:	.asciz "Press any key to continue... "
// Buffer where user input goes when paused. The buffer is never actually used
pauseBuffer:	.skip BUFSIZE

.text
.balign 4
_start:
	// Construct the central list of the program
	bl List

	// Store a pointer to the new list in the local static variable
	ldr r4, =stringList
	str r0, [r4]

	rasm4__while__input_not_7:
		// Clear the screen
		ldr r0, =clearCmd
		bl system

		// Get a valid integer input between the min-max options
		mov r0, #MIN_OPTION
		mov r1, #MAX_OPTION
		ldr r2, =GetIntInput
		bl GetValueInRange
		mov r4, r0

		// Check integer against the max option (equal to quit)
		cmp r4, #MAX_OPTION
		beq rasm4__endwhile__input_not_7

		rasm4__switch__option:
			// Option 1 displays the list
			cmp r4, #1
			beq rasm4__if__display_list
			bal rasm4__endif__display_list

			// Display the list
			rasm4__if__display_list:
				ldr r0, =stringList
				ldr r0, [r0]
				bl DisplayList
			rasm4__endif__display_list:

			// Branch out of the switch
			cmp r4, #1
			beq rasm4__endswitch__options

			// Option 2 allows user to add to list
			cmp r4, #2
			beq rasm4__if__add_to_list
			bal rasm4__endif__add_to_list

			rasm4__if__add_to_list:
				ldr r0, =stringList
				ldr r0, [r0]
				bl AddToList
			rasm4__endif__add_to_list:

			// Branch out of the switch
			cmp r4, #2
			beq rasm4__endswitch__options

			cmp r4, #3
			// helper that gets an index and deletes that node
			// Branch out of the switch
			cmp r4, #3
			beq rasm4__endswitch__options

			cmp r4, #4
			// helper gets an index and another string and replaces the value at that index with the new string
			// Branch out of the switch
			cmp r4, #4
			beq rasm4__endswitch__options

			cmp r4, #5
			// helper recieves a substring and displays all string with the substring in them
			// Branch out of the switch
			cmp r4, #5
			beq rasm4__endswitch__options

			cmp r4, #6
			// helpers outputs list to output.txt
		rasm4__endswitch__options:

		// Put the pause prompt
		ldr r1, =pausePrompt
		bl putstring

		// Get the pause input
		ldr r1, =pauseBuffer
		ldr r2, #BUFSIZE
		bl getstring

		// Branch back to start of loop
		bal rasm4__while__input_not_7
	rasm4__endwhile__input_not_7:

	// Destroy the list
	ldr r0, =stringList
	ldr r0, [r0]
	bl d_List

	// Terminate the program
	mov r0, #0
	mov r7, #1
	svc 0
