.global _start  @ Declare pointer to the start of the program

_start:
    mov r0, 0x00000008  @ Move 8d to R0
    mov r1, 0x000000ff  @ Move 255d to R1
    mov r2, 0x00001388  @ Move 5000d to R2
    mvn r3, 0x0000005f  @ Move -96d to R3
    movs r0, r3 @ STATUS SET - move r3->r1 and set status flag
    mov r1, r2  @ Move r2->r1
    svc 0
    .end
