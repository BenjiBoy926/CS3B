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
	cmp hword, #0
	blt _if__hwordneg
	bal _elif__hwordpos
	_if__hwordneg:
		mov word, #0xffff0000
		orr word, word, hword
		bal _endif__hwordneg
	_elif__hwordpos:
		mov word, #0
		mov word, hword
	_endif__hwordneg:
		bx lr