.global _start
.global _end

.equ BUFSIZE, 32

.data
prompt: .asciz "Enter a whole number: "
space: .asciz "   "
int1: .skip BUFSIZE
int2: .skip BUFSIZE
int3: .skip BUFSIZE
int4: .skip BUFSIZE
addr: .skip 16  // Stores the addresses of the integers to be output

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

    ldr r1, =int1
    mov r2, #BUFSIZE
    bl getstring

    @ Prompt for second integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =int2
    mov r2, #BUFSIZE
    bl getstring

    @ Prompt for third integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =int3
    mov r2, #BUFSIZE
    bl getstring

    @ Prompt for fourth integer
    ldr r1, =prompt
    bl putstring

    ldr r1, =int4
    mov r2, #BUFSIZE
    bl getstring

    // Store the base address of the data at addr
    ldr r4, =addr

    // Store the address of int1 in addr
    ldr r1, =int1
    str r1, [r4]
    
    // Print the address of int1
    ldr r1, =addr
    mov r2, 16
    bl _stdout

    // Put empty space for readability
    ldr r1, =space
    bl putstring

    // Store the address of int2 in addr
    ldr r1, =int2
    str r1, [r4]    

    // Print the address of int2
    ldr r1, =addr
    mov r2, 16
    bl _stdout

    // Put empty space for readability
    ldr r1, =space
    bl putstring

    // Store the address of int2 in addr
    ldr r1, =int3
    str r1, [r4]    

    // Print the address of int2
    ldr r1, =addr
    mov r2, 16
    bl _stdout

    // Put empty space for readability
    ldr r1, =space
    bl putstring

    // Store the address of int2 in addr
    ldr r1, =int4
    str r1, [r4]    

    // Print the address of int2
    ldr r1, =addr
    mov r2, 16
    bl _stdout

    @ Service call to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
