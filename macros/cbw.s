.global cbw

word .req r0
byte .req r1

/*
r0 cbw(r1 byte)
---------------
Convert the given signed byte value 
to a signed word value
---------------
*/

cbw:
	cmp byte, #0
	blt _if__byteneg
	bal _elif__bytepos
	_if__byteneg:
		mov word, #0xffffff00
		orr word, word, byte
		bal _endif__byteneg
	_elif__bytepos:
		mov word, #0
		mov word, byte
	_endif__byteneg:
		bx lr

