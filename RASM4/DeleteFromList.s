.global DeleteFromList

.data
indexPrompt:		.asciz "Enter an index in the list to delete: "
listEmptyPrompt:	.asciz "You cannot delete from the list because the list is empty!\n\n"

/*
void DeleteFromList(r0 list)
----------------------------
Get user input of an index in the list to delete
and delete the element at that indexs
----------------------------
*/

.text
.balign 4
DeleteFromList:
	push {r4-r8, r10-r12, lr}

	// Store pointer to list
	mov r4, r0

	// Get the length of the list
	bl List_length
	mov r5, r0

	// Branch if list is empty
	cmp r5, #0
	beq dfl__if__list_is_empty

	dfl__if__list_not_empty:
		bl GetIntInput

	// If list is emtpy, output list is empty prompt
	dfl__if__list_is_empty:
		ldr r1, =listEmptyPrompt
		bl putstring
	dlf__endif__list_not_empty:

	pop {r4-r8, r10-r12, pc}
	