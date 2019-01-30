.global _start

_start:
    @ Initialize
    mov r0, #0xff 
    mov r1, #0x91
    mov r2, #0x064
    mov r3, #0xb0
    mov r4, #0x6d
    mov r5, #0x000011
    mov r6, #0xf1
    mov r8, #0xf8
        
    @ Execute some logic instructions for testing
    and r0, #0x68
    eor r1, #0x92
    orr r2, #0x3a
    and r3, #0xb0
    and r4, #0x4a
    orr r5, #0x61
    lsl r6, #4
    ror r8, #8

    mov r7, #1	@tell linux to terminate the program
    svc 0
    .end
    