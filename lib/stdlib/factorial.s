.global factorial

/*
r0 factorial(r1 n)
------------------
r0 = r1!
Uses recursion
------------------
*/

factorial:
	// Base case if r1 <= 1
	cmp r1, #1
	ble _factorial__base_case
	// Recursive case if r1 > 1
	bal _factorial__recursive_case
	// In the base case, return 1
	_factorial__base_case:
		mov r0, #1
		bx lr
	_factorial__recursive_case:
		push {r1, lr}
		// Compute the factorial of r1 - 1
		sub r1, r1, #1
		bl factorial
		// Restore r1 and multiply 
		// the result of the recusive call
		pop {r1}
		mul r0, r1, r0
		// Pop lr into the pc
		pop {pc}

