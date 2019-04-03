.global cbw

/*
r0 cbw(r1 byte)
---------------
Convert the given signed byte value 
to a signed r0 value
---------------
*/

cbw:
	cmp r1, #0x7f
	bgt cbw__if__byteneg
	bal cbw__elif__bytepos
	cbw__if__byteneg:
		mov r0, #0xffffff00
		orr r0, r0, r1
		bal cbw__endif__byteneg
	cbw__elif__bytepos:
		mov r0, r1
	cbw__endif__byteneg:
		bx lr

