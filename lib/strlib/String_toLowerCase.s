.global String_toLowerCase

.data
.equ ASCII_UPPERCASE_START, 65
.equ ASCII_UPPERCASE_END, 90
.equ ASCII_CASE_DIFF, 32

/*
void String_toLowerCase(r1 str)
-------------------------------
Converts each uppercase letter in a string to lowercase
-------------------------------
*/

.text
.balign 4
String_toLowerCase:
	push {lr}
	mov r2, r1
	tolow__while__byte_not_zero:
		// Load the byte currently pointed to by r1
		ldrb r1, [r2]
		// Check to see if this is the end of the string
		cmp r1, #0
		beq tolow__end
		// Check to see if the current byte r1
		// is a lowercase letter
		push {r1, r2}
		mov r2, #ASCII_UPPERCASE_START
		mov r3, #ASCII_UPPERCASE_END
		bl String_inrange
		pop {r1, r2}
		// If the current character is lower case character,
		// change it to upper case
		cmp r0, #1
		beq change_uppercase_letter
		// Branch to update loop
		bal tolow__while__byte_not_zero__loop_update
	change_uppercase_letter:
		// Add case difference to current byte,
		// and store result in current pointer of string
		add r1, r1, #ASCII_CASE_DIFF
		strb r1, [r2]
	tolow__while__byte_not_zero__loop_update:
		add r2, r2, #1
		bal tolow__while__byte_not_zero
	tolow__end:
		pop {pc}
