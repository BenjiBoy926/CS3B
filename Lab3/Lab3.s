.global _start

.data
string: .ascii "Raspberry\n"

.text
_start:
	@ Print the first letter of "string" to standard output device
	ldr r1, =string
	mov r2, #1
	bl _stdout

	@ Print the whole string to the standard output device
	mov r2, #10
	bl _stdout	

	@ branch to the end
	bal _end

_stdout:
	mov r0, #1	@ Signal stdout - the monitor
	mov r7, #4	@ Service command to write a string
	svc 0	@ issues the command to write to the monitor
	@ Move the contents of the link register back into the program counter
	@ The calling method MUST use "Branch Link" to get here 
	@ or this move could really screw things up
	mov r15, r14

_end:
	@ Terminate the program with normal completion
	mov r0, #0
	mov r7, #1
	svc 0
	.end	
