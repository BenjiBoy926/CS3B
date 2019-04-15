.global String_inrange

/*
r0 String_inrange(r1 num, r2 min, r3 max)
-----------------------------------------
Puts the value 1 (true) or 0 (false) in r0 if the
number in r1 is within the range specified by r2 and r3
Behaviour is undefined if r2 > r3
-----------------------------------------
*/

String_inrange:
    // Branch to "out of range" label if num < min
    cmp r1, r2
    blt str__outrange
    // Branch to "out of range" label if num > max
    cmp r1, r3
    bgt str__outrange
    // If we make it to here, we know the number is in range
    bal str__inrange
    // Branch here if the number is out of range
    str__outrange:
        mov r0, #0
        bal str_inrange__end
    // Branch here if the number is in range
    str__inrange:
        mov r0, #1
    str_inrange__end:
        // Branch back to the instruction specified by the link register
        mov pc, lr

