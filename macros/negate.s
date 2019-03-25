.global negate

/*
r0 negate(r1 num)
-----------------
r0 = -r1
-----------------
*/

negate:
	mov r0, r1
	sub r0, #1
	mvn r0, r0
	bx lr