.global AllNums

.data
startAscii: .byte 48
endAscii:   .byte 57

/*
r0 AllNums(vol r1 c_str)
-------------------------
Puts 1 (true) or 0 (false) in r0 if each byte in the string
pointed to by r1 is the ascii code for some number
r1 is expected to be null-terminated
-------------------------
*/

.balign 4
.text
AllNums:
    _loopinit:
    _loopcheck:
    _loopbody:
    _loopchange:
    _loopend:
        // Branch back to the instruction in the linker register
        bx lr
