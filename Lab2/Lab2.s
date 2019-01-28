.global _start  @ Declare pointer to the start of the program

_start:
    @ Exercise 1 Initialize
    mvn r0, #4  @ Move negativve into r0 to test bit shifting 
    mov r1, r0  @ Create copy of r0 to demonstrate differences between arithmetic and logical shifts 
    mov r2, #1  @ Used to store the number of times we want to shift
    
    @ Exercise 2 Initialize
    mov r3, #5	@ Arbitrary number - used to demo using bitshift to make zero
    mov r4, #32	@ Represents the number of times r3 will be bitshifted

    @ Exercise 3 Initialize
    mov r5, #17	@ Arbitrary number used to demonstrate logical operators

    @ Exercise 1 Execute
    asr r0, r2  @ Arithmetic left shift preserves negative, R0 =  -2
    lsr r1, r2  @ Logical left shift discards negative, R1 = +2
  
    @ Exercise 2 Execute
    lsr r3, r4	@ bitshift r3 until it is zero

    @ Exercies 3 Execute
    and r5, r5, #0	@ Create zero using logic

    mov r0, #0	@indicate normal completion  
    mov r7, #1	@tell linux to terminate the program
    svc 0
    .end
