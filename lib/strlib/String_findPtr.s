.global String_findPtr

/*
r0 String_findPtr(r1 str, r2 char)
----------------------------------
Loop through a string until the given character is found,
then return a pointer to that character.
Return null pointer if the character is not in the sequence
----------------------------------
*/

String_findPtr:
	mov r0, r1
	fptr__while__byte_not_null:
		// Load the current byte of the string
		ldrb r3, [r0]
		// Check to make sure the current byte is not the null terminator
		cmp r3, #0
		beq fptr__if__byte_not_found
		// Check to see if the current byte is equal to the byte we're looking for
		cmp r3, r2
		beq fptr__end
		// Increment the string pointer
		add r0, r0, #1
		bal fptr__while__byte_not_null
	// If byte is not found, return null pointer
	fptr__if__byte_not_found:
		mov r0, #0
	fptr__end:
		bx lr
		