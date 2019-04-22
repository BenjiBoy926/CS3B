/*
IMPLICIT CLASS DEFN
-------------------
public class Node
{
	word dataPtr : any	(node + 0)
	word nextPtr : Node	(node + 4)
}

public class List
{
	word headPtr : Node	(list + 0)
	word tailPtr : Node	(list + 4)
}
-------------------
NOTES:
	If an argument/comment claims to represent a "list" or "node", 
this means that the register is a pointer to a block of memory that
contains all the data shown in the above definitions

	Let's say I have r0 = 0x10.  If I claim that r0 points to a "list",
what I mean is that the block of memory at the address 0x10 has two 
words (eight bytes) of data allocated to it.  The first word is the 
head pointer and the second word is the tail pointer
	
	Suppose r0 = 0x10 and it points to a list. If I want to store the 
		mov r1, #0x14
		ldr r1, [r1]
	
	Or, assuming r0 has a pointer to this list, I could write:
		ldr r1, [r0, #4]

	In fact, this second piece of code will work to get the tail pointer of ANY list,
provided that the register points to a block of data that represents a list 
(otherwise, you could could garbage data or seg faults if (r0 + 8) has not been allocated)
---------------------
*/

/******************
FUNCTION PROTOTYPES
*******************/

/*
r0 =node <constructor>(r0 dataPtr, r1 dataLen)
----------------------------------------------
Allocate a block of data for a node and return a pointer to it

The data pointer in the node points to a new block of data
of dataLen length with dataLen bytes from the dataPtr
copied into it

The "next" pointer is initialized to nullptr
----------------------------------------------
*/
.global Node

/*
void <destructor>(r0 node)
--------------------------
Free the memory for a node pointed to by r0
--------------------------
*/
.global d_Node

/*
r0 =list <constructor>()
------------------------
Allocate a block of data for a list and return a pointer to it
head = 0, tail = 0
------------------------
*/
.global List

/*
r0 =dataPtr List_get(r0 list, r1 index)
---------------------------------------
Get a pointer to the data in the node in the list
at index. Return null pointer if index is 
outside the bounds of the list 
---------------------------------------
*/
.global List_get

/*
void List_set(r0 list, r1 index, r2 dataPtr, r3 dataLen)
--------------------------------------------------------
Replace the data pointer in the node at the given index with
a copy of the data at the given dataPtr
--------------------------------------------------------
*/
.global List_set

/*
void List_setstr(r0 list, r1 index, r2 str)
-------------------------------------------
Assumes the data pointer points to a string of memory with a
null terminator, and sets the data pointer of the node
-------------------------------------------
*/
.global List_setstr

/*
r0 =prevNode, r1 =currentNode List_getNodePair(r0 list, r1 index)
-----------------------------------------------------------------
Given a list and an index in the list, return the node at the index
in r1 and return the node before the index in r0 
-----------------------------------------------------------------
*/
.global List_getNodePair

/*
void List_add(r0 list, r1 dataPtr, r2 dataLen)
----------------------------------------------
Add a node to the list by copying #dataLen bytes
pointed to by dataLen into a new memory block

A node is constructed with dataPtr and nextPtr
that points to the copy of the data that was created
----------------------------------------------
*/
.global List_add

/*
void List_addstr(r0 list, r1 dataPtr)
-------------------------------------
Special case of the List_add routine that assumes 
the data points to a null-terminated string of bytes
-------------------------------------
*/
.global List_addstr

/*
void List_remove(r0 list, r1 index)
-----------------------------------
Remove the node at index from the linked list
Does nothing if index is out of bounds
-----------------------------------
*/
.global List_remove

/*
void List_foreach(r0 list, r1 actionRoutine)
--------------------------------------------
Call the given routine for every data pointer in every node
in the list

actionRoutine is a subroutine with the following signature:
	void action(r1 dataPtr)
--------------------------------------------
*/
.global List_foreach

/*
void List_foreachMatch(r0 list, r1 dataPtr, r2 comparerRoutine, r3 actionRoutine)
---------------------------------------------------------------------------------
Given a list and data pointer, go through each node in the list and perform the
given action for each data pointer where the given comparer returns true

comparerRoutine is a subroutine with the following signature:
	r0 =boolean cmp(r1 data1, r2 data2)
Where r0 = 1 if the data is equal and r0 = 0 if they are unequal

actionRoutine is a suroutine with the following signature:
	void action(r1 dataPtr)
---------------------------------------------------------------------------------
*/
.global List_foreachMatch

/*
void List_print(r0 list)
------------------------
Interprets all data pointers in all nodes as null-terminated
strings and attempts to print out the ascii representation
------------------------
*/
.global List_print

/*
void List_printMatch(r0 list, r1 dataPtr, r2 comparerRoutine)
-------------------------------------------------------------
Print all data for which the comparer routine returns true (r0 = 1)
-------------------------------------------------------------
*/
.global List_printMatch

/*
void <destructor>(r0 list)
--------------------------
Destoy the list by freeing memory of all the nodes in the list
--------------------------
*/
.global d_List

/*
void print_string_and_endline(r1 str)
-------------------------------------
Print the null-terminated string pointed to by r1,
followed by a carriage return
-------------------------------------
*/
.global print_string_and_endline

// Let the dynamic linker resolve references
// to malloc and free
.extern malloc
.extern free

/***********
DATA SEGMENT
************/

.data
cCR:	.byte 10	// Carriage return ascii code

/*************
IMPLEMENTATION
**************/

.text
.balign 4

// r0 =node <constructor>(r0 dataPtr, r1 dataLen)
Node:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments in non-volatile registers
	mov r4, r0
	mov r5, r1

	// Allocate 8 bytes for the node - four for
	// the data pointer and four for the next pointer
	mov r0, #8
	bl malloc
	mov r6, r0

	// Allocate a data segment of the size of the data
	mov r0, r5
	bl malloc
	mov r7, r0

	// Copy the data given into the new
	// data allocated
	mov r1, r4
	mov r2, r0
	mov r3, r5
	bl memcpy

	// Move zero into eight - this will be the node's next pointer
	mov r8, #0

	// Store the data pointer in the first word of r6,
	// then store null in the second word
	str r7, [r6]
	str r8, [r6, #4]

	// Move the node pointer r6 into r0 and return
	mov r0, r6

	pop {r4-r8, r10-r12, pc}

// void <destructor>(r0 node)
d_Node:
	push {r4, lr}

	mov r4, r0

	// Free the memory pointed to by the node's data pointer
	ldr r0, [r4]
	bl free

	// Free the memory used to hold the data pointer and next pointer
	mov r0, r4
	bl free

	pop {r4, pc}

// r0 =list <constructor>()
List:
	push {r4-r8, r10-r12, lr}

	// Allocate eight bytes - four for "head"
	// and four for "tail"
	mov r0, #8
	bl malloc
	
	mov r1, #0
	// Store null pointer in "head" data word
	str r1, [r0]
	// Store null pointer in "tail" data word
	str r1, [r0, #4]

	pop {r4-r8, r10-r12, pc}

// r0 =dataPtr List_get(r0 list, r1 index)
List_get:
	push {lr}

	// Return the current node's data pointer
	bl List_getNodePair

	// Check to see if current is null and branch accordingly
	cmp r1, #0
	beq lget__elif__current_is_null

	// If current is not null, return its data pointer
	lget__if__current_not_null:
		ldr r0, [r1]
		bal lget__end
	// If current is null, return null
	lget__elif__current_is_null:
		mov r0, #0
	lget__end:
		pop {pc}
	
// void List_set(r0 list, r1 index, r2 dataPtr, r3 dataLen)
List_set:
	push {r4-r8, r10-r12, lr}
	
	// Preserve values of argument registers
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3

	// Get the node pair at the given index
	bl List_getNodePair

	// Branch to end if current is null
	cmp r1, #0
	beq lset__end

	lset__if__current_not_null:
		// Store current node
		mov r8, r1

		// Allocate a data segment of the size of the data
		mov r0, r7
		bl malloc
		mov r10, r0

		// Copy the data given into the new
		// data allocated
		mov r1, r6
		mov r2, r10
		mov r3, r7
		bl memcpy
		
		// Free the data pointed to by the node to change
		ldr r0, [r8]
		bl free

		// Store the new pointer in the data pointer
		// of the current node
		str r10, [r8]

	lset__end:
		pop {r4-r8, r10-r12, pc}

// void List_setstr(r0 list, r1 index, r2 str)
List_setstr:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments in variable registers
	mov r4, r0
	mov r5, r1
	mov r6, r2

	// Get the length of the string
	mov r1, r6
	bl strlen
	mov r7, r0

	// Set the data in the node,
	// plus one for the null terminator
	mov r0, r4
	mov r1, r5
	mov r2, r6
	add r3, r7, #1
	bl List_set

	pop {r4-r8, r10-r12, pc}	

// r0 =prevNode, r1 =currentNode List_getNodePair(r0 list, r1 index)
List_getNodePair:
	push {r4-r8, r10-r12, lr}

	// Branch to fail case if index is less than zero
	cmp r1, #0
	blt lgetnp__fail_case

	mov r2, #0	// Use r2 as a pointer to the previous node

	// Use r3 as a pointer to the current node
	// Start at the list's head pointer
	ldr r3, [r0]	

	lgetnp__while__index_not_zero__and__current_not_null:
		// If the current node pointer is null,
		// branch to fail case
		cmp r3, #0
		beq lgetnp__fail_case

		// Branch to found case if 
		// current index is zero
		cmp r1, #0
		ble lgetnp__found_case

		// Update previous with current pointer
		mov r2, r3
		// Load the current node pointer 
		// with it's own "next" pointer
		ldr r3, [r3, #4]
		// Decrement the index
		sub r1, r1, #1

		// Branch back to loop start
		bal lgetnp__while__index_not_zero__and__current_not_null

	// In the failure case, return null pointer
	lgetnp__fail_case:
		mov r0, #0
		mov r1, #0
		bal lgetnp__end

	// In the correct case, return r2 as the previous node
	// and return r1 as the current node
	lgetnp__found_case:
		mov r0, r2
		mov r1, r3

	lgetnp__end:
		pop {r4-r8, r10-r12, pc}

// void List_add(r0 list, r1 dataPtr, r2 dataLen)
List_add:
	push {r4-r8, r10-r12, lr}

	// Preserve the list pointer in r4
	mov r4, r0

	// Construct a node from the given data
	mov r0, r1
	mov r1, r2
	bl Node

	ldr r3, [r4, #4]	// Load r3 with the tail pointer

	// If the tail pointer is null, branch to first node case
	// If tail is not null, branch to not first node case
	cmp r3, #0
	beq ladd__if__first_node
	bal ladd__elif__not_first_node

	// If this is the first node,
	// both head and tail should point to it
	ladd__if__first_node:
		str r0, [r4]
		str r0, [r4, #4]
		bal ladd__end

	// Branch here if this is not the first node
	ladd__elif__not_first_node:
		// Store the pointer to the newly constructed node 
		// in the "next" word pointed to by the tail pointer
		str r0, [r3, #4]
		// Store the pointer to the newly constructed node
		// in the "tail" word pointed to by the list pointer
		str r0, [r4, #4]

	ladd__end:
		pop {r4-r8, r10-r12, pc}

// void List_addstr(r0 list, r1 dataPtr)
List_addstr:
	push {r4-r8, r10-r12, lr}

	// Preserve arguments in variable registers
	mov r4, r0
	mov r5, r1

	// Get the length of the string
	mov r1, r5
	bl strlen
	mov r6, r0

	// Add the data to the list, plus one
	// to include null terminator
	mov r0, r4
	mov r1, r5
	add r2, r6, #1
	bl List_add

	pop {r4-r8, r10-r12, pc}	

// void List_remove(r0 list, r1 index)
List_remove:
	push {r4-r8, r10-r12, lr}

	// Preserve argument registers
	mov r4, r0
	mov r5, r1

	// Get the node to delete in r1 and the node before it in r0
	bl List_getNodePair

	// Check the previous pointer and branch
	cmp r0, #0
	beq lrm__elif__previous_is_null

	// If previous node is not null, make previous point
	// to the node after current
	lrm__if__previous_not_null:
		ldr r2, [r1, #4]
		str r2, [r0, #4]
		bal lrm__endif__previous_not_null

	// If the previous node is null, update the head of the 
	// list to the node after the node to delete
	lrm__elif__previous_is_null:
		ldr r2, [r1, #4]
		str r2, [r4]

	lrm__endif__previous_not_null:

	// If the current node is not the tail node,
	// branch past the if statement
	ldr r2, [r4, #4]
	cmp r1, r2
	bne lrm__endif__current_is_tail

	// If current node is the tail node,
	// update the tail to point to previous node
	lrm__if__current_is_tail:
		str r0, [r4, #4]
	lrm__endif__current_is_tail:

	// Destroy the current node
	mov r0, r1
	bl d_Node

	pop {r4-r8, r10-r12, pc}

// void List_foreach(r0 list, r1 actionRoutine)
// void actionRoutine(r1 dataPtr)
List_foreach:
	push {r4-r8, r10-r12, lr}

	// Preserve the arguments in non-volatile registers
	mov r4, r0
	mov r5, r1
	
	ldr r6, [r4]	// Use r6 as the "current" pointer, starting at the head

	lforeach__while__current_not_null:
		// Compare the current node with null
		cmp r6, #0
		beq lforeach__end
	
		// Load r1 with the data pointer of the current node
		// and branch to the action routine
		ldr r1, [r6]
		blx r5

		// Load current node pointer with its own next pointer
		ldr r6, [r6, #4]
		bal lforeach__while__current_not_null

	lforeach__end:
		pop {r4-r8, r10-r12, pc}

// void List_foreachMatch(r0 list, r1 dataPtr, r2 comparerRoutine, r3 actionRoutine)
// r0 =boolean cmp(r1 data1, r2 data2)
// void action(r1 dataPtr)
List_foreachMatch:
	push {r4-r8, r10-r12, lr}

	// Preserve the arguments in non-volatile registers
	mov r4, r0
	mov r5, r1
	mov r7, r2
	mov r8, r3
	
	ldr r10, [r4]	// Use r6 as the "current" pointer, starting at the head

	lforeachmatch__while__current_not_null:
		// Compare the current node with null
		cmp r10, #0
		beq lforeachmatch__end
	
		// Branch to the routine that compares the data
		// in the current pointer with the pointer given
		ldr r1, [r10]
		mov r2, r5
		blx r7

		// Do the action if r0 is true,
		// otherwise skip the action
		cmp r0, #0
		bne lforeachmatch__do_action
		bal lforeachmatch__skip_action

		// Load r1 with the data pointer of the current node
		// and branch to the action routine
		lforeachmatch__do_action:
			ldr r1, [r10]
			blx r8
		lforeachmatch__skip_action:

		// Load current node pointer with its own next pointer
		ldr r10, [r10, #4]
		bal lforeachmatch__while__current_not_null

	lforeachmatch__end:
		pop {r4-r8, r10-r12, pc}

// void List_print(r0 list)
List_print:
	push {lr}

	// Put each string plus an endline 
	ldr r1, =print_string_and_endline
	bl List_foreach

	pop {pc}

// void List_printMatch(r0 list, r1 dataPtr, r2 comparerRoutine)
List_printMatch:
	push {lr}

	// Print string and endline for each match by the comparer routine
	ldr r3, =print_string_and_endline
	bl List_foreachMatch

	pop {pc}

// void <destructor>(r0 list)
d_List:
	push {r4-r8, r10-r12, lr}

	// Preserve the arguments in non-volatile registers
	mov r4, r0
	
	mov r5, #0		// Use r5 as the "previous" node pointer
	ldr r6, [r4]	// Use r5 as the "current" pointer, starting at the head

	dl__while__current_not_null:
		// Compare the current node with null
		cmp r6, #0
		beq dl__end
	
		// Update previous to current, 
		// update current to the node after it
		mov r5, r6
		ldr r6, [r6, #4]
		
		// Delete the previous node
		mov r0, r5
		bl d_Node

		// Branch back to loop
		bal dl__while__current_not_null

	dl__end:
		pop {r4-r8, r10-r12, pc}

// void print_string_and_endline(r1 str)
print_string_and_endline:
	push {lr}

	// Display string specified
	bl putstring

	// Put an endline
	ldr r1, =cCR
	bl putch

	pop {pc}
