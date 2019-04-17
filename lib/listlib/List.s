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
.global d__Node

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
void List_remove(r0 list, r1 index)
-----------------------------------
Remove the node at index from the linked list
Does nothing if index is out of bounds
-----------------------------------
*/
.global List_remove

/*
void List_foreach_cmp(r0 list, r1 dataPtr, r2 comparerRoutine, r3 actionRoutine)
--------------------------------------------------------------------------------
Given a list and data pointer, go through each node in the list and perform the
given action for each data pointer where the given comparer returns true

comparerRoutine is a subroutine with the following signature:
	r0 =boolean cmp(r1 data1, r2 data2)
Where r0 = 1 if the data is equal and r0 = 0 if they are unequal

actionRoutine is a suroutine with the following signature:
----------------------------------------------------------------------------
*/
.global List_foreach_cmp

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
void <destructor>(r0 list)
--------------------------
Destoy the list by freeing memory of all the nodes in the list
--------------------------
*/
.global d__List

// Let the dynamic linker resolve references
// to malloc and free
.extern malloc
.extern free

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
	push {r4-r8, r10-r12, lr}

	// Branch to fail case if index is less than zero
	cmp r1, #0
	blt lget__fail_case

	ldr r2, [r0]	// Assign the head pointer to r2

	lget__while__index_not_zero__and__current_not_null:
		// If the current node pointer is null,
		// branch to fail case
		cmp r2, #0
		beq lget__found_case

		// Branch to found case if 
		// current index is zero
		cmp r1, #0
		ble lget__found_case

		// Load the current node pointer 
		// with it's own "next" pointer
		ldr r2, [r2, #4]
		// Decrement the index
		sub r1, r1, #1

		// Branch back to loop start
		bal lget__while__index_not_zero__and__current_not_null

	// In the failure case, return null pointer
	lget__fail_case:
		mov r0, #0
		bal lget__end

	// In the correct case, return the first word
	// pointed to by r2, the data pointer of the node
	lget__found_case:
		ldr r0, [r2]

	lget__end:
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

	// Branch here if this is not the first node
	ladd__elif__not_first_node:
		// Store the pointer to the newly constructed node 
		// in the "next" word pointed to by the tail pointer
		str r0, [r3, #4]
		// Store the pointer to the newly constructed node
		// in the "tail" word pointed to by the list pointer
		str r0, [r4, #4]

	pop {r4-r8, r10-r12, pc}

// void List_foreach(r0 list, r1 actionRoutine)
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
