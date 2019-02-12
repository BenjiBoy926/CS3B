.global _start
.global _end

.equ BUFSIZE, 32

.data
prompt:     .asciz "Enter a whole number: "
message:    .asciz "You entered: "
str1:       .skip BUFSIZE
str2:       .skip BUFSIZE
str3:       .skip BUFSIZE
str4:       .skip BUFSIZE

@ Register Table
@ --------------
@ r0 -> device   -> device of input/output
@ r1 -> baseAddr -> base address of memory input/output
@ r2 -> buffLen  -> length input/output, calculated for output
@ r3 -> internal -> used in stdout/stdin

.text
.balign 4
_start:
    @ Prompt for first integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =str1
    mov r2, #BUFSIZE
    bl getstring

    ldr r1, =message
    bl putstring

    ldr r1, =str1
    bl putstring

    @ Prompt for second integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =str2
    mov r2, #BUFSIZE
    bl getstring

    ldr r1, =message
    bl putstring

    ldr r1, =str2
    bl putstring

    @ Prompt for third integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =str3
    mov r2, #BUFSIZE
    bl getstring

    ldr r1, =message
    bl putstring

    ldr r1, =str3
    bl putstring

    @ Prompt for fourth integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =str4
    mov r2, #BUFSIZE
    bl getstring

    ldr r1, =message
    bl putstring

    ldr r1, =str4
    bl putstring

    @ Service call to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
