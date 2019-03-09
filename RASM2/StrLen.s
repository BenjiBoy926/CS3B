.global StrLen

/*
r0 StrLen(r1 strAddr)
---------------------
Get the length of a null-terminated string,
EXCLUDING the null terminator
---------------------
*/

StrLen:
	bx lr