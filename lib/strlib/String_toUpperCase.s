.global String_toUpperCase

.data
.equ ASCII_LOWERCASE_START, 97
.equ ASCII_LOWERCASE_END, 122
.equ ASCII_CASE_DIFF, 32

/*
void String_toUpperCase(r1 str)
-------------------------------
Converts each undercase letter in a string to uppercase
-------------------------------
*/

.text
.balign 4
String_toUpperCase:
	push {lr}
	mov r2, r1
	toup__while__byte_not_zero:
		// Load the byte currently pointed to by r1
		ldrb r1, [r2]
		// Check to see if this is the end of the string
		cmp r0, #0
		beq toup__end
		// Check to see if the current byte r1
		// is a lowercase letter
		push {r1, r2}
		mov r2, #ASCII_LOWERCASE_START
		mov r3, #ASCII_LOWERCASE_END
		bl inrange
		pop {r1, r2}
		// If the current character is lower case character,
		// change it to upper case
		cmp r0, #1
		beq change_lowercase_letter
		// Branch to update loop
		bal toup__while__byte_not_zero__loop_update
	change_lowercase_letter:
		// Subtract case difference from current byte,
		// and store result in current pointer of string
		sub r0, r1, #ASCII_CASE_DIFF
		strb r0, [r2]
	toup__while__byte_not_zero__loop_update:
		add r2, r2, #1
		bal toup__while__byte_not_zero
	toup__end:
		pop {pc}
