.global _start	@ starting line of the program

_start:
	mov r0, #0	@ Status flag "0" indicates normal completion
	mov r7, #1	@ Move linux command code "1" into the linux command register
	svc 0	@ Tell linux to terminate the program
	.end
