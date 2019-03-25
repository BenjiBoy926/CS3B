.global abs

absNum	.req r0
num		.req r1

/*
r0 abs(r1 num)
--------------
Return the absolute value of the number stored in r1
--------------
*/

abs:
	mov absNum, num
	cmp absNum, #0
	// Branch to correct if header
	ble _if__numneg
	bal _endif__numneg
	// If value is negative, subtract and move the logical negative
	_if__numneg:
		sub absNum, #1
		mvn absNum, absNum
	_endif__numneg:
		bx lr
		