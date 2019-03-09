.global InRange

/*
r0 InRange(r1 num, r2 min, r3 max)
----------------------------------
Puts the value 1 (true) or 0 (false) in r0 if the
number in r1 is within the range specified by r2 and r3
Behaviour is undefined if r2 > r3
----------------------------------
*/

InRange:
    // Branch to "out of range" label if num < min
    cmp r1, r2
    blt _outrange
    // Branch to "out of range" label if num > max
    cmp r1, r3
    bgt _outrange
    // If we make it to here, we know the number is in range
    bal _inrange
    // Branch here if the number is out of range
    _outrange:
        mov r0, #0
        bal _end
    // Branch here if the number is in range
    _inrange:
        mov r0, #1
    _end:
        // Branch back to the instruction specified by the link register
        mov pc, lr

