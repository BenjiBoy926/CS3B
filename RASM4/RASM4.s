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

// Menu output
bytes:	.asciz	" bytes -"
menu1:	.asciz	"-----------------------------------------------------"
menu2:	.asciz	"-                 RASM4 TEXT EDITOR                 -"
menu3:	.asciz	"-----------------------------------------------------"
menu4:	.asciz	"- Data Structure Memory Consumption: "
menu5:	.asciz	"-                                                   -"
menu6:	.asciz	"- <1> View all strings                              -"
menu7:	.asciz	"- <2> Add string                                    -" 
menu8:	.asciz	"-	<a> From keyboard                           -"
menu9:	.asciz	"-	<b> From file (input.txt)                   -"
menu10:	.asciz	"- <3> Delete string                                 -"
menu11:	.asciz	"- <4> Edit string                                   -"
menu12:	.asciz	"- <5> Search string                                 -"
menu13:	.asciz	"- <6> Save file                                     -"
menu14:	.asciz	"- <7> Quit                                          -"
menu15:	.asciz	"-----------------------------------------------------"

// Memory Consumption
memoryBytes:	.skip 12

// Prompt for user to enter a index #
stringIndex:	.asciz	"Enter an Index #: "

// Prompt user to enter a string
stringReplace:	.asciz	"Enter a string to replace old string: "

// Prompt user for string to seach
stringSearch:	.asciz	"Enter a string you would like to search: "

// Displays String has been deleted
deleted:	.asciz "String has been DELETED!"

// Displays String has been replaced
replaced:	.asciz "String has been REPALCED!"

// Stores a pointer to the string list used to dynamically store all of the strings
stringList:	.word 0

// Feedback displayed if user enters invalid option
inputInvalidPrompt:	.asciz "*** ERROR: please input a number between 1 and 7 ***\n"

// Endline ascii code
endl:	.byte 10

// Clear command for the c++ system call
clearCmd:	.asciz "clear"

// Prompt user for any key
pausePrompt:	.asciz "Press <ENTER> to continue... "

// Buffer used for user input
strBuffer:	.skip BUFSIZE

// User input
userIndex:	.word 0
userString:	.skip 512

// Buffer where user input goes when paused. The buffer is never actually used
pauseBuffer:	.skip BUFSIZE

// Confirm to the user that the list was saved
outputConfirmPrompt:	.asciz "List saved to file "

// Name of the file to output the list to
outputFileName:	.asciz "output.txt"

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
	
		// Output menu screen
		ldr r1, =menu1
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu2
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu3
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu4
		bl putstring

		// Gets data consumption for menu output
		ldr r0, =stringList
		ldr r0, [r0]
		bl  List_length

		mov r2, #8
		mul r0, r0, r2
		ldr r1, =memoryBytes
		bl intasc32

		ldr r1, =memoryBytes
		bl putstring

		ldr r1, =bytes
		bl  putstring

		// Continue with menu
		ldr r1, =endl
		bl putch
		ldr r1, =menu5
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu6
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu7
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu8
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu9
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu10
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu11
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu12
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu13
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu14
		bl putstring
		ldr r1, =endl
		bl putch
		ldr r1, =menu15
		bl putstring
		ldr r1, =endl
		bl putch

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
			/*
			OPTION 1 - display the list
			*/
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

			/*
			OPTION 2 - add to the list
			*/
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

			/*
			OPTION 3 - delete from the list
			*/
			cmp r4, #3
			beq rasm4__if__delete_from_list
			bal rasm4__endif__delete_from_list

			rasm4__if__delete_from_list:
				// Gets index # input from the user
				ldr r1, =stringIndex
				bl putstring

				ldr r1, =strBuffer
				mov r2, #BUFSIZE
				bl getstring

				// Converts input from ascii to int
				ldr r1, =strBuffer
				bl ascint32

				ldr r1, =userIndex
				str r0, [r1]

				// r0= string list, r1= index#
				// Calls List_remove to delete node from list
				ldr r0, =stringList
				ldr r0, [r0]
				ldr r1, =userIndex
				ldr r1, [r1]
				sub r1, #1	@ Aligns index for user
				bl  List_remove

				ldr r1, =deleted
				bl putstring

				ldr r1, =endl
				bl putch

				ldr r1, =endl
				bl putch

			rasm4__endif__delete_from_list:

			// Branch out of the switch
			cmp r4, #3
			beq rasm4__endswitch__options

			/*
			OPTION 4 - replace in list
			*/
			cmp r4, #4
			beq rasm4__if__replace_in_list
			bal rasm4__endif__replace_in_list

			rasm4__if__replace_in_list:
				// Gets index # input from the user
				ldr r1, =stringIndex
				bl putstring

				ldr r1, =strBuffer
				mov r2, #BUFSIZE
				bl getstring

				// Converts input from ascii to int
				ldr r1, =strBuffer
				bl ascint32

				ldr r1, =userIndex
				str r0, [r1]

				// Prompt user for the string to replace old string
				ldr r1, =stringReplace
				bl putstring

				ldr r1, =userString
				mov r2, #BUFSIZE
				bl getstring

				mov r3, r0
				ldr r0, =stringList
				ldr r0, [r0]
				ldr r1, =userIndex
				ldr r1, [r1]
				sub r1, #1	@ Aligns index for user
				ldr r2, =userString
				bl List_setstr

				ldr r1, =replaced
				bl putstring

				ldr r1, =endl
				bl putch

				ldr r1, =endl
				bl putch
				

			rasm4__endif__replace_in_list:

			// Branch out of the switch
			cmp r4, #4
			beq rasm4__endswitch__options

			/*
			OPTION 5 - string search
			*/
			cmp r4, #5
			beq rasm4__if__search_list
			bal rasm4__endif__search_list

			rasm4__if__search_list:
				// Prompt user for the string
				ldr r1, =stringSearch
				bl putstring

				ldr r1, =userString
				mov r2, #BUFSIZE
				bl getstring

				ldr r0, =stringList
				ldr r0, [r0]
				ldr r1, =userString
				ldr r2, =String_containsIgnoreCase
				bl  List_printMatch

			rasm4__endif__search_list:
			
			// helper recieves a substring and displays all string with the substring in them
			// Branch out of the switch
			cmp r4, #5
			beq rasm4__endswitch__options

			/*
			OPTION 6 - output to file "output.txt"
			*/
			cmp r4, #6
			beq rasm4__if__output_list
			bal rasm4__endif__output_list

			rasm4__if__output_list:
				// Output the list to the file
				ldr r0, =stringList
				ldr r0, [r0]
				ldr r1, =outputFileName
				bl List_outputToFile

				// Confirm to the user that the list was saved
				ldr r1, =outputConfirmPrompt
				bl putstring
				ldr r1, =outputFileName
				bl putstring

				// Put two endlinds
				ldr r1, =endl
				bl putch
				ldr r1, =endl
				bl putch
			rasm4__endif__output_list:
			
		rasm4__endswitch__options:

		// Put the pause prompt
		ldr r1, =pausePrompt
		bl putstring

		// Get the pause input
		ldr r1, =pauseBuffer
		mov r2, #BUFSIZE
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
