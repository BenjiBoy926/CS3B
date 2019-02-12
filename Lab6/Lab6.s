.global _start
.global _end

.equ BUFSIZE, 11

.data
prompt: .asciz "Enter a whole number: "
space: .asciz "   "

// Array contains blocks of memory for the ascii inputs from the user
inputstrings:
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
.skip BUFSIZE
endinputstrings:
// Array of data words of the inputs converted to ints
ints:
.word 0
.word 0
.word 0
.word 0
endints:

@ Register Table
@ --------------
@ r0 -> device / intConvertedFromAscii                       
@ r1 -> baseAddr                              
@ r2 -> buffLen                                 
@ r3 -> internal                                
@ r4 -> inputCurrentAddr      
@ r5 -> inputsEndAddr 
@ r6 -> intsCurrentAddr  

.text
.balign 4
_start:
    _loopinit:
        // Intialize base address and end address of the array of inputs
        ldr r4, =inputstrings
        ldr r5, =endinputstrings
        ldr r6, =ints

    _loopcheck:
        // Branch to the end if currentAddr >= endAddr (r4 >= r5)
        cmp r4, r5
        beq _loopend
        bpl _loopend

    _loopbody:
        @ Prompt for first integer
        ldr r1, =prompt
        bl putstring

        @ Get string from console and store it 
        @ in the block currently pointed to by r4
        mov r1, r4
        mov r2, #BUFSIZE
        bl getstring

        @ Branch to ascint macro to convert data pointed to by r1 to an int
        bl ascint32
        
        @ Store r0 into the current byte word pointed to by r6
        mov r1, r6
        str r0, [r1]

    _loopchange:
        @ Add the size of one item in the input array to
        @ r4 so it points to the next input block
        add r4, r4, #BUFSIZE
        add r6, r6, #4
        bal _loopcheck
    
    _loopend:
    @ Service call to terminate the program
    mov r0, #0
    mov r7, #1
    swi 0
    .end
