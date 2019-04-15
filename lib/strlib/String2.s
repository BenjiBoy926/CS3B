// Global definitions of all the functions in String2.s
.global memcpy

.global String_compare

.global String_concat

.global String_findPtr

.global String_indexOf
.global String_indexOfFrom
.global String_indexOfString

.global String_indexPtr

.global String_inrange

.global String_lastIndexOf
.global String_lastIndexOfFrom
.global String_lastIndexOfString

.global String_replace

.global String_toUpperCase

.global strlen

// Help the linker resolve the reference to malloc
.extern malloc

.data
// Start/end of uppercase ascii letters
.equ ASCII_UPPERCASE_START, 65
.equ ASCII_UPPERCASE_END, 90

// Start/end of lowercase ascii letters
.equ ASCII_LOWERCASE_START, 97
.equ ASCII_LOWERCASE_END, 122

// Ascii codepoint difference between letter cases
.equ ASCII_CASE_DIFF, 32

// Allign the opcodes
.text
.balign 4

/*
void memcpy(r1 source, r2 destination, r3 bytes)
------------------------------------------------
Copy the source byte-for-byte into the destination
------------------------------------------------
*/

memcpy:
	_mem__while__bytes_not_zero:
		// If number of bytes to copy is currently zero, branch to end
		cmp r3, #0
		ble _mem__end
		// Load the byte at r1 into r0,
		// then store r0 into the byte at r2
		ldrb r0, [r1], #1
		strb r0, [r2], #1
		// Decrement r3
		sub r3, r3, #1
		bal _mem__while__bytes_not_zero
	_mem__end:
		bx lr

/*
r0 String_compare(r1 str, r2 otherStr)
--------------------------------------
Compare the two strings. r0 = 1 if they are equal 
and 0 if they are unequal

NOTE: this routine returns true even if one string
is null terminated while the other has trailing
characters.  Thus it may be more accurate to say that the
function returns true if one string is found directly
at the beginning of the other
--------------------------------------
*/

String_compare:
	// Preserve r4, r5 and the link register
	push {r4, r5, lr}
	_while__bytes_equal__AND__neither_null_encountered:
		// Store bytes pointed to by r1 and r2 in r4 and r5, respectively
		ldrb r4, [r1], #1
		ldrb r5, [r2], #1
		// Branch to label if the current byte of either
		// string is the null terminator
		cmp r4, #0
		beq _if__either_null_encountered
		cmp r5, #0
		beq _if__either_null_encountered
		// Compare the two bytes together
		cmp r4, r5
		bne _if__bytes_unequal
		// Branch back to the start of the loop
		bal _while__bytes_equal__AND__neither_null_encountered
	// Branch here if we reached the end of either string
	// before finding unequal characters
	_if__either_null_encountered:
		mov r0, #1
		bal cmp__end
	// Branch here if unequal bytes are found in the strings
	_if__bytes_unequal:
		mov r0, #0
	cmp__end:
		// Restore r4/r5 and put lr value in the pc
		pop {r4, r5, pc}

/*
r0 String_concat(r1 str1, r2 str2)
----------------------------------
Return a pointer to a dynamically allocated string 
with the characters in r1 followed by the characters in r2
----------------------------------
REGISTER TABLE:
	r4 = str1
	r5 = str2
	r6 = str1Len
	r7 = str2Len
	r8 = newString
----------------------------------
*/

String_concat:
	// Preserve arguments and the link register
	push {r4-r8, lr}
	mov r4, r1
	mov r5, r2
	// Get the length of string r1 and put it into r4
	mov r1, r4
	bl strlen
	mov r6, r0
	// Get the length of string in r2
	mov r1, r5
	bl strlen
	mov r7, r0
	// Allocate memory the size of both strings,
	// plus one for the null terminator
	add r0, r6, r7
	add r0, r0, #1
	bl malloc
	mov r8, r0
	// Copy first string (r4) into destination (r8)
	mov r1, r4
	mov r2, r8
	mov r3, r6
	bl memcpy
	// Copy second string (r5) into part of destination 
	// just beyond the first string (r8 + r6)
	mov r1, r5
	add r2, r8, r6
	add r3, r7, #1
	bl memcpy
	// Restore registers, putting preserved link register contents
	// into the program counter
	mov r0, r8
	pop {r4-r8, pc}

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

/*
r0 String_indexOf(r1 str, r2 ch)
--------------------------------
Find the byte in r2 in the sequence of bytes
pointed to by r1
--------------------------------
*/

String_indexOf:
	mov r0, #0
	mov r3, r1
	io__while__byte_not_equal:
		// Load the byte pointed to by r1
		// Increment r1's address after
		ldrb r3, [r1], #1
		// If the current byte is zero,
		// we reached the end of the string, 
		// and the byte could not be found
		cmp r3, #0
		beq io__if__byte_not_found
		// Branch to the end if current byte matches
		cmp r3, r2
		beq io__end
		// Increment each time an unequal byte is compared
		add r0, r0, #1
		bal io__while__byte_not_equal
	io__if__byte_not_found:
		// If byte was not found, return value is -1
		mvn r0, #0
	io__end:
		bx lr

/*
r0 String_indexOfFrom(r1 str, r2 ch, r3 startIndex)
---------------------------------------------------
Search the string for the given character starting 
at the given index
---------------------------------------------------
*/

String_indexOfFrom:
	// Preserve r2, r3 and link register
	push {r2-r3, lr}
	// Get a pointer to the part of the string
	// starting at the index
	mov r2, r3
	bl String_indexPtr
	// Restore r2 and r3
	pop {r2-r3}	
	// If indexPtr returned null pointer,
	// the index is out of range of the string
	cmp r0, #0
	beq iof__if__index_out_of_range
	// Preserve r3 so it is not modified in the next subroutine
	push {r3}
	// Find the index of the character
	// starting at the part of the string
	// in the index specified
	mov r1, r0
	bl String_indexOf
	// Restore r3
	pop {r3}
	// If r0 = -1, branch to end and return it
	cmp r0, #0xffffffff
	beq iof__end
	// Add the starting index to the index in the other string
	add r0, r0, r3
	bal iof__end
	// If index given is out of range, 
	// return = -1
	iof__if__index_out_of_range:
		mvn r0, #0
	iof__end:
		// Pop the preserved lr into the program counter
		pop {pc}

/*
r0 String_indexOfString(r1 str, r2 otherStr)
--------------------------------------------
Find the index of the other string in this string
--------------------------------------------
*/

String_indexOfString:
	// Preserve registers from calling routine
	push {r4-r5, lr}
	// Get the length of the first string
	push {r1, r2}
	bl strlen
	mov r4, r0
	pop {r1, r2}
	// Get the length of the other string
	push {r1, r2}
	mov r1, r2
	bl strlen
	pop {r1, r2}
	// If the first string is smaller than the second,
	// return string not found
	mov r5, r0
	cmp r4, r5
	blt ios__if__string_not_found
	// Use r3 as the current index
	mov r3, #0
	ios__while__byte_not_null:
		// Load the next byte of the bigger string into r4
		ldrb r4, [r1]
		// If this byte is the null terminator, the string was not found
		cmp r4, #0
		beq ios__if__string_not_found
		// Compare string at r1 with string at r2
		push {r1, r2}
		bl String_compare
		pop {r1, r2}
		// If strings are equal, we found the string
		cmp r0, #1
		beq ios__if__string_found
		// Increment the index and the current string being checked
		add r3, r3, #1
		add r1, r1, #1
		bal ios__while__byte_not_null
	// If string is found, return r3, the index
	ios__if__string_found:
		mov r0, r3
		bal ios__end
	// If string not found, return -1
	ios__if__string_not_found:
		mvn r0, #0
	ios__end:
		pop {r4-r5, pc}

/*
r0 String_indexPtr(r1 str, r2 index)
------------------------------------
Get a pointer to the point in the string
indexed by r2. If index points outside
the string, r0 = 0 (nullptr)

Negative value in r2 simply returns r1
------------------------------------
*/

String_indexPtr:
	mov r0, r1
	iptr__while__index_gt_zero:
		// Load the current byte of r0 in r3
		ldrb r3, [r0]
		// If r3 currently stores the null terminator, 
		// the index is out of range of the string
		cmp r3, #0
		beq iptr__if__index_out_of_range
		// Compare index with zero
		cmp r2, #0
		// If index is negative, it is out of range
		blt iptr__if__index_out_of_range
		// If index is equal to zero, we've finished the routine
		beq iptr__end
		// Decrement the index
		sub r2, r2, #1
		// Increment the string pointer
		add r0, r0, #1
		bal iptr__while__index_gt_zero
	iptr__if__index_out_of_range:
		// Move 0 into r0 if index is out of range
		mov r0, #0
	iptr__end:
		bx lr

/*
r0 String_inrange(r1 num, r2 min, r3 max)
-----------------------------------------
Puts the value 1 (true) or 0 (false) in r0 if the
number in r1 is within the range specified by r2 and r3
Behaviour is undefined if r2 > r3
-----------------------------------------
*/

String_inrange:
    // Branch to "out of range" label if num < min
    cmp r1, r2
    blt str__outrange
    // Branch to "out of range" label if num > max
    cmp r1, r3
    bgt str__outrange
    // If we make it to here, we know the number is in range
    bal str__inrange
    // Branch here if the number is out of range
    str__outrange:
        mov r0, #0
        bal str_inrange__end
    // Branch here if the number is in range
    str__inrange:
        mov r0, #1
    str_inrange__end:
        // Branch back to the instruction specified by the link register
        mov pc, lr

/*
r0 String_lastIndexOf(r1 str, r2 char)
--------------------------------------
Find the index of the last occurrence of the value of r2 in the
null terminated string pointered to by r1

The algorithm works by simply using "indexOf" on each part of the string
When it finds the character, it checks the rest of the string after
the character for another occurrence of the same character
Keeps a running total of the indeces in r6 and returns it
--------------------------------------
*/

String_lastIndexOf:
	// Preserve modified registers used as local variables
	push {r4-r7, lr}
	// r4 and r5 will be used to keep values of r1 and r2, respectively
	mov r4, r1
	mov r5, r2
	// Use r6 to preserve the index of the character
	mov r6, #-1
	// Use r7 to use indexOf on different parts of the string
	mov r7, r1
	lio__while__index_valid:
		// Find the index of the current character
		// in the current string
		mov r1, r7
		mov r2, r5
		bl String_indexOf
		// Check to see if the character was found in the string
		cmp r0, #-1
		beq lio__end
		// Add current index in substring to current index in whole string
		add r6, r6, r0
		add r6, r6, #1
		// Move r7 to point to the character 
		// one past the character found in the string
		add r7, r7, r0
		add r7, r7, #1
		bal lio__while__index_valid
	lio__end:
		// Return the contents of r3, the index of result from previous call
		mov r0, r6
		// Restore old register values, popping link register into program counter
		pop {r4-r7, pc}

/*
r0 String_lastIndexOfFrom(r1 str, r2 char, r3 startIndex)
-----------------------------------------------------
Find that last index of a character in the string, starting
at the given index
-----------------------------------------------------
*/

String_lastIndexOfFrom:
	// Preserve r2, r3 and link register
	push {r2-r3, lr}
	// Get a pointer to the part of the string
	// starting at the index
	mov r2, r3
	bl String_indexPtr
	// Restore r2 and r3
	pop {r2-r3}	
	// If indexPtr returned null pointer,
	// the index is out of range of the string
	cmp r0, #0
	beq liof__if__index_out_of_range
	// Preserve r3 so it is not modified in the next subroutine
	push {r3}
	// Find the index of the character
	// starting at the part of the string
	// in the index specified
	mov r1, r0
	bl String_lastIndexOf
	// Restore r3
	pop {r3}
	// If r0 = -1, branch to end and return it
	cmp r0, #0xffffffff
	beq liof__end
	// Add the starting index to the index in the other string
	add r0, r0, r3
	bal liof__end
	// If index given is out of range, 
	// return = -1
	liof__if__index_out_of_range:
		mvn r0, #0
	liof__end:
		// Pop the preserved lr into the program counter
		pop {pc}


/*
r0 String_lastIndexOfString(r1 str, r2 otherStr)
------------------------------------------------
Find the last occurrence of the given character sequence
------------------------------------------------
*/

String_lastIndexOfString:
	// Preserve registers from calling routine
	push {r4-r8, lr}
	// Get the length of the first string
	push {r1, r2}
	bl strlen
	mov r4, r0
	pop {r1, r2}
	// Get the length of the other string
	push {r1, r2}
	mov r1, r2
	bl strlen
	mov r5, r0
	pop {r1, r2}
	// Preserve the length of the other string in r8
	mov r8, r5
	// Move the negative of the length 
	// of the second string into r6
	mvn r6, r8
	add r6, r6, #1
	// If the first string is smaller than the second,
	// return string not found
	cmp r4, r5
	blt lios__end
	// r4 and r5 will be used to keep values of r1 and r2, respectively
	mov r4, r1
	mov r5, r2
	// Use r7 to use indexOfString on different parts of the string
	mov r7, r1
	lios__while__index_valid:
		// Find the index of the other string in the index
		// of the current part of the string to check
		mov r1, r7
		mov r2, r5
		bl String_indexOfString
		// Load the next byte of the bigger string into r4
		cmp r0, #-1
		beq lios__end
		// Add the current index plus the length of the other string
		add r6, r6, r0
		add r6, r6, r8
		// Move r7 to point to the character 
		// one past the substring found in the string
		add r7, r7, r0
		add r7, r7, r8
		bal lios__while__index_valid
	lios__end:
		// Check to see if index is negative
		cmp r6, #0
		blt lios__if__index_negative
		bal lios__endif__index_negative
		// If the index is any negative, make sure it's exacly -1
		lios__if__index_negative:
			mvn r6, #0
		lios__endif__index_negative:
		// Move the index into r0 and return
		mov r0, r6 
		pop {r4-r8, pc}

/*
void String_replace(r1 str, r2 initialChar, r3 replaceChar)
------------------------------------------------------------
Search the string for all occurrences of initialChar and replace
each character with replaceChar
------------------------------------------------------------
*/

String_replace:
	push {lr}
	rep__while__current_not_null:
		// Get a pointer to r2, the character to replace
		push {r1-r3}
		bl String_findPtr
		pop {r1-r3}
		// String_findPtr returns r0 = null if the character was not found,
		// so check and branch to end if r0 == null
		cmp r0, #0
		beq rep__end
		// Store the replacement byte in the part of the string
		// pointed to by r0
		strb r3, [r0]
		// Make r1 point to the next character in the sequence
		add r1, r1, #1
		bal rep__while__current_not_null
	rep__end:
		// Pop the link register back into the PC
		pop {pc}

/*
void String_toUpperCase(r1 str)
-------------------------------
Converts each undercase letter in a string to uppercase
-------------------------------
*/

String_toUpperCase:
	push {lr}
	mov r2, r1
	toup__while__byte_not_zero:
		// Load the byte currently pointed to by r1
		ldrb r1, [r2]
		// Check to see if this is the end of the string
		cmp r1, #0
		beq toup__end
		// Check to see if the current byte r1
		// is a lowercase letter
		push {r1, r2}
		mov r2, #ASCII_LOWERCASE_START
		mov r3, #ASCII_LOWERCASE_END
		bl String_inrange
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
		sub r1, r1, #ASCII_CASE_DIFF
		strb r1, [r2]
	toup__while__byte_not_zero__loop_update:
		add r2, r2, #1
		bal toup__while__byte_not_zero
	toup__end:
		pop {pc}

/*
r0 strlen(r1 str)
-----------------
Given a pointer to an area of memory, counts the 
number of bytes until it finds a zero. Great for
getting the length of a null-terminated string
-----------------
*/

strlen:
	mov r0, #0
	mov r2, r1
	len__while__byte_not_zero:
		// Load the byte pointed to by r1
		// Increment r1's address after
		ldrb r2, [r1], #1
		// If the current byte is zero,
		// exit the loop
		cmp r2, #0
		beq len__endwhile__byte_not_zero
		// Increment each time an unequal byte is compared
		add r0, r0, #1
		bal len__while__byte_not_zero
	len__endwhile__byte_not_zero:
		bx lr
