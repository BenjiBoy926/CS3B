.global chw

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
	cmp r1, r2
	bgt chw__if__hwordneg
	bal chw__elif__hwordpos
	chw__if__hwordneg:
		mov r0, #0xff000000
		orr r0, r0, #0x00ff0000 
		orr r0, r0, r1
		bal chw__endif__hwordneg
	chw__elif__hwordpos:
		mov r0, #0
		mov r0, r1
	chw__endif__hwordneg:
		bx lr
