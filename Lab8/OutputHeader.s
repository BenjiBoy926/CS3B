.global OutputHeader

.data
namePrompt:     .asciz "Author:  "
datePrompt:     .asciz "Date:    "
programPrompt:  .asciz "Program: "
endl:           .byte 10
retAddr:	.word 0

/*
void OutputHeader(r0 author, r1 date, r2 program)
-------------------------------------------------
Output a neat header with author, date, and program name
Pass addresses of nul-terminated strings to r0, r1, and r2
that will be displayed
-------------------------------------------------
*/

.text
.balign 4
OutputHeader:
    // Move argument addresses into different registers to preserve them
    mov r3, r0
    mov r4, r1
    mov r5, r2
    // Preserve the current contents of the link register
    ldr r1, =retAddr
    str r14, [r1]
    // Output name prompt
    ldr r1, =namePrompt
    bl putstring
    // Put the author's name
    mov r1, r3
    bl putstring
    // Put an endline
    ldr r1, =endl
    bl putch
    // Output date prompt
    ldr r1, =datePrompt
    bl putstring
    // Put the date
    mov r1, r4
    bl putstring
    // Put an endline
    ldr r1, =endl
    bl putch
    // Output program name prompt
    ldr r1, =programPrompt
    bl putstring
    // Put the author's name
    mov r1, r5
    bl putstring
    // Put and endline
    ldr r1, =endl
    bl putch
    // Put one last endline
    ldr r1, =endl
    bl putch
    // Make the program counter point back
    // to the the address it came from
    ldr r0, =retAddr
    ldr r15, [r0]

