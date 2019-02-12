.global _start
.global _end

.equ BUFSIZE, 11

.data
prompt: .asciz "Enter a whole number: "
space: .asciz "   "
addr: .skip 16  // Stores the addresses of the integers to be output

// Array contains blocks of memory for the ascii inputs from the user
inputs:
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
endinputs:

@ Register Table
@ --------------
@ r0 -> device          -> device of input/output
@ r1 -> baseAddr        -> base address of memory input/output
@ r2 -> buffLen         -> length input/output, calculated for output
@ r3 -> internal        -> used in stdout/stdin
@ r4 -> currendAddr     -> Current address in the block of memory with all the user inputs
@ r5 -> inputsEndAddr   -> end address of the block of memory with all the user inputs 

.text
.balign 4
_start:
    _inputloopinit:
        // Intialize base address and end address of the array of inputs
        ldr r4, =inputs
        ldr r5, =endinputs

    _inputloopcheck:
        // Branch to the end if r4 >= r5
        cmp r4, r5
        beq _inputloopend
        bpl _inputloopend

    _inputloopbody:
        @ Prompt for first integer
        ldr r1, =prompt
        bl putstring

        @ Get string from console and store it 
        @ in the block currently pointed to by r4
        mov r1, r4
        mov r2, #BUFSIZE
        bl getstring

    _inputloopchange:
        @ Add the size of one item in the input array
        // r4 so it points to the next input block and
        @ branch back to the loop check
        add r4, r4, #BUFSIZE
        bal _inputloopcheck
    
    _inputloopend:
    @ Service call to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
