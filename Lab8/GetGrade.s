.global GetGrade

.equ letterAsciiStart, 65

.data
gradeLowerBounds: 
.byte 90, 80, 70, 60
endGradeLowerBounds:

/*
r0 GetGrade(const r1 intGrade)
------------------------------
Given the grade as an integer, fills r0 with the ascii
code for the letter grade
------------------------------
*/

.balign 4
.text
GetGrade:
    _loopstart:
        // Start letter grade at 'A'
        mov r0, #letterAsciiStart
        // Load r2 with the first grade bound
        ldr r2, =gradeLowerBounds
    _loopcheck:
        // If r2 points to the end of the grade array,
        // branch to the end of the loop
        ldr r3, =endGradeLowerBounds
        cmp r2, r3
        bge _loopend
    _loopbody:
        // Load r3 with current grade lower bound
        // LCV simultaneously updated, here
        ldr r3, [r2], #1
        // Break out of the loop if grade 
        // is greater than current grade lower bound
        cmp r1, r3
        bge _end
        // Increment r0 to a lower letter grade
        add r0, r0, #1
    _loopend:
        // If we got to this point, the student got an F,
        // so increment r0 past E to F
        add r0, r0, #1    
    _end:
        // Move the instruction pointed to by the link register into the program counter
        mov pc, lr