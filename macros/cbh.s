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
	cmp byte, #0
	blt _if__byteneg
	bal _elif__bytepos
	_if__byteneg:
		mov hword, #0x0000ff00
		orr hword, hword, byte
		bal _endif__byteneg
	_elif__bytepos:
		mov hword, #0
		mov hword, byte
	_endif__byteneg:
		bx lr
