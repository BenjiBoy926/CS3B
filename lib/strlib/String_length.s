.global String_length

/*
r0 String_length(r1 str)
------------------------
Given a pointer to an area of memory, counts the 
number of bytes until it finds a zero. Great for
getting the length of a null-terminated string
------------------------
*/

String_length:
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
