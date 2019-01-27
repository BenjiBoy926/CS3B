.global _start  @ Declare pointer to the start of the program

_start:
    mvn r0, #4  @ Move negativve into r0 to test bit shifting 
    mov r1, r0  @ Create copy of r0 to demonstrate differences between arithmetic and logical shifts 
    mov r2, #1  @ Used to store the number of times we want to shift
    asl r0, r2  @ Arithmetic left shift preserves negative, R0 = -12
    lsl r1, r2  @ Logical left shift discards negative, R1 = +12
  
    mov r0, #0	@indicate normal completion  
    mov r7, #1	@tell linux to terminate the program
    svc 0
    .end
