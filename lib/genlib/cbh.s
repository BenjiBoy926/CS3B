.global cbh

/*
r0 cbh(r1 byte)
---------------
Convert a signed byte value to a halfword
---------------
*/

cbh:
	cmp r1, #0x7f
	bgt cbh__if__byteneg
	bal cbh__elif__bytepos
	cbh__if__byteneg:
		mov r0, #0x0000ff00
		orr r0, r0, r1
		bal cbh__endif__byteneg
	cbh__elif__bytepos:
		mov r0, r1
	cbh__endif__byteneg:
		bx lr
