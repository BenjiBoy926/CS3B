/*
void asm_bubble_sort(r0 arrayPtr, r1 arrayLen)
----------------------------------------------
Sort the array using bubble sort algorithm
----------------------------------------------
*/
.global asm_bubble_sort

array				.req r0
i 					.req r1
j 					.req r2
length 				.req r3
sentinel			.req r4
laterElement		.req r5
earlierElement		.req r6
laterElementPtr		.req r7
earlierElementPtr	.req r8
temp				.req r10

// void asm_bubble_sort(r0 arrayPtr, r1 arrayLen)
asm_bubble_sort:
	push {r4-r8, r10-r12, lr}

	// Start the loop variables
	mov length, r1
	mov i, #0

	bbl__for__i_lt_length:
		// Branch out if i >= length
		cmp i, length
		bge bbl__endfor__i_lt_length

		// Initialize inner index
		mov j, #0

		// Initialize sentinel value
		sub temp, i, #1
		sub sentinel, length, temp

		bbl__for__j_lt_sentinel:
			// Branch out if j >= sentinel
			cmp j, sentinel
			bge bbl__endfor__j_lt_sentinel

			// earlierElement = array + (j * 4)
			add earlierElementPtr, array, j, asl #2
			ldr earlierElement, [earlierElementPtr]

			// laterElement = array + ((j + 1) * 4)
			add temp, j, #1
			add laterElementPtr, array, temp, asl #2
			ldr laterElement, [laterElementPtr]

			// If laterElement >= earlierElement, branch over the swap
			cmp laterElement, earlierElement
			bge bbl__endif__later_lt_earlier

			bbl__if__later_lt_earlier:
				// Swap the valus in the array
				str laterElement, [earlierElementPtr]
				str earlierElement, [laterElementPtr] 
			bbl__endif__later_lt_earlier:

			// Update LCV
			add j, j, #1
			bal bbl__for__j_lt_sentinel

		bbl__endfor__j_lt_sentinel:

		// Update LCV
		add i, i, #1
		bal bbl__for__i_lt_length

	bbl__endfor__i_lt_length:

	pop {r4-r8, r10-r12, pc}
