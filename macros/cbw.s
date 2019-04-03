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
	cmp byte, #0x7f
	bgt cbw__if__byteneg
	bal cbw__elif__bytepos
	cbw__if__byteneg:
		mov word, #0xffffff00
		orr word, word, byte
		bal cbw__endif__byteneg
	cbw__elif__bytepos:
		mov word, byte
	cbw__endif__byteneg:
		bx lr

