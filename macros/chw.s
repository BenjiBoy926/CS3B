.global chw

word 	.req r0
hword	.req r1

/*
r0 chw(r1 hword)
----------------
Convert the given signed half-word value
to a signed word value
----------------
*/

chw:
	mov r2, #0xff
	mov r3, #0x7f00
	orr r2, r2, r3
	cmp hword, r2
	bgt _if__hwordneg
	bal _elif__hwordpos
	_if__hwordneg:
		mov word, #0xff000000
		orr word, word, #0x00ff0000 
		orr word, word, hword
		bal _endif__hwordneg
	_elif__hwordpos:
		mov word, #0
		mov word, hword
	_endif__hwordneg:
		bx lr
