.global cbh

hword 	.req r0
byte 	.req r1

/*
r0 cbh(r1 byte)
---------------
Convert a signed byte value to a halfword
---------------
*/

cbh:
	cmp byte, #0x7f
	bgt cbh__if__byteneg
	bal cbh__elif__bytepos
	cbh__if__byteneg:
		mov hword, #0x0000ff00
		orr hword, hword, byte
		bal cbh__endif__byteneg
	cbh__elif__bytepos:
		mov hword, byte
	cbh__endif__byteneg:
		bx lr
