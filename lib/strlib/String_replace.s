.global String_replace

/*
void String _replace(r1 str, r2 initialChar, r3 replaceChar)
------------------------------------------------------------
Search the string for all occurrences of initialChar and replace
each character with replaceChar
------------------------------------------------------------
*/

String_replace:
	push {lr}
	rep__while__current_not_null:
		// Get a pointer to r2, the character to replace
		bl String_findPtr
		// String_findPtr returns r0 = null if the character was not found,
		// so check and branch to end if r0 == null
		cmp r0, #0
		beq rep__end
		// Store the replacement byte in the part of the string
		// pointed to by r0
		strb r3, [r0]
		bal rep__while__current_not_null
	rep__end:
		// Pop the link register back into the PC
		pop {pc}
