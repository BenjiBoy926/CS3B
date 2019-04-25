/* -- File_testing.s -- */

/* -- Data Section -- */	
	.data

fileName:	.asciz	"input.txt"
fileName2:	.asciz	"output.txt"
cCR:		.byte 	10,0	@ Point to print a Caridge return (aka endline)

/* -- Code Section -- */
	.text
	
	.global _start 		@ Provide a program starting address to Linker
	
_start:
	mov	r6, #25
@2. Open the file for input, read in the string and display it to the terminal

	@open input file
	ldr 	r1, =fileName
	mov		r2, #00
	bl		open_file

	mov		r8, r0 		@ R8 holds input file handle

	@open output file
	ldr 	r1, =fileName2
	mov		r2, #0101
	bl		open_file

	mov		r7, r0		@ R7 holds output file handle
	
loop:
	mov		r0, r8		@ Move input file handle into r0
	bl 		read_line
	mov		r8, r0

	mov		r0, r7		@ Move output file handle into r0
	bl		write_to_file

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl		write_to_file
	mov		r7, r0

	sub		r6, #1		@ Decrement loop
	cmp		r6, #0
	bne		loop
	
	@close input file
	mov		r0, r8
	bl		close_file

	@close output file
	mov		r0, r7
	bl		close_file

	@exit program
	mov 	r0, #0 		@ Exit Status code set to 0 to indicate "normal completion"
    mov 	r7, #1 		@ service command code (1) will terminate this program
    svc 	0 			@ Issue Linux command to terminate program

    .end
