@need to look at test4, works with mov r1, r0, need it to work when storing into s4
/* -- RASM3.s -- */

/* -- Data Section -- */
	.data

strName:	.asciz 	"Names:   Joseph Llamas(String1.a), Codey(String2.a)"
strProgram:	.asciz 	"Program: RASM3"
strClass:	.asciz 	"Class:   CS 3B"
strDate:	.asciz 	"Date:    April 17, 2019"

strPrompt1:	.asciz 	"Please enter the first string (s1): "
strPrompt2:	.asciz 	"Please enter the second string (s2): "
strPrompt3:	.asciz	"Please enter the third string (s3): "
strPrompt4:	.asciz 	"Please enter a starting substring to check in s1, at index 11: "
strPrompt5:	.asciz 	"Please enter another starting substring to check in s1: "
strPrompt6:	.asciz	"Please enter ending substring to check in s1: "
strPrompt7:	.asciz	"Please enter starting index for check on s1: "

strTrue:	.asciz	"TRUE"
strFalse:	.asciz	"FALSE"

strTest:	.asciz	"(Joseph) String1.a Tests #1-10:"
strTestCont:	.asciz 	"(Cody) String2.a Tests #11-20:" 
strTest1:	.asciz	"1.  Lengths of s1, s2, s3: "
strTest2a:	.asciz	"2a. String_equals(s1, s3): "
strTest2b:	.asciz	"2b. String_equals(s1, s1): "
strTest3a:	.asciz	"3a. String_equalsIgnoreCase(s1, s3): "
strTest3b:	.asciz	"3b. String_equalsIgnoreCase(s1, s2): "
strTest4:	.asciz	"4.  String_copy(s1) output s1, s4: "
strTest5:	.asciz	"5.  String_substring_1(s3, 4, 13): "
strTest6:	.asciz	"6.  String_substring_2(s3, 7): "
strTest7:	.asciz	"7.  String_charAt(s2, 4): "
strTest8:	.asciz	"8.  String_startsWith_1(s1, hat., 11): "
strTest9:	.asciz	"9.  String_startsWith_2(s1, Cat): "
strTest10:	.asciz	"10. String_endsWith(s1, in the hat.): "

length:		.skip 	12	@ Used to store length of variable for output
output:		.skip 	100	@ Used to store output when needed
s1:		.skip 	100	@ Used to store user input (limited to 100 characters)
s2:		.skip 	100	@ Used to store user input (limited to 100 characters)
s3:		.skip 	100	@ Used to store user input (limited to 100 characters)
s4:		.skip 	100	@ Used to store sopy of s1 (limited to 100 characters)

subString1:	.skip 	100	@ Used to store user input in test8
subString2:	.skip	100	@ Used to store uner input in test9
subString3:	.skip	100	@ Used to store user input in test10

cCR:		.byte 	10,0	@ Used to print a Caridge Return (aka endline)
cCO:		.ascii 	","	@ Used to print a comma
cSP:		.ascii 	" "	@ Used to print a space

/* -- Code Section -- */
	.text

	.global _start 		@ Provide a program starting address to Linker
	.equ	BUFSIZE, 100	@ Size of input buffer can be changed
	.balign 4		@ Aligns data

_start:
	@Display programmers info
	ldr	r1, =strName	@ Displays programmer name
	bl	putstring	@ Call subroutine to print 

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print
	
	ldr	r1, =strProgram	@ Displays assignment title
	bl	putstring	@ Call subroutine to print 

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print
	
	ldr	r1, =strClass	@ Displays date
	bl	putstring	@ Call subroutine to print 

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	ldr	r1, =strDate	@ Displays date
	bl	putstring	@ Call subroutine to print 

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	@Gets the users inputs and stores input into 'variables'

	@1st input
	ldr	r1, =strPrompt1	
	bl	putstring	@ Outputs prompt for user to input 1st string

	ldr	r1, =s1		@ Going to store 1st user input into 's1'
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	@2nd input
	ldr	r1, =strPrompt2	@ Outputs prompt for user to input 1st string
	bl	putstring

	ldr	r1, =s2		@ Going to store 2nd user input into 's2'
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	@3rd input
	ldr	r1, =strPrompt3	@ Outputs prompt for user to input 1st string
	bl	putstring

	ldr	r1, =s3		@ Going to store 3rd user input into 's3'
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Tests all String functions from String1.a #1-10 in order
	ldr	r1, =strTest	
	bl	putstring	@ Outputs display header for String1 tests

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test1
	ldr	r1, =strTest1	
	bl	putstring	@ Outputs prompt for 1st Test

	@length s1
	ldr	r1, =s1
	bl	String_length	@ Obtains the length of s1

	ldr	r1, =length
	str 	r0, [r1]	@ Stores length into 'variable'

	ldr	r1, =length
	bl	intasc32	@ Converts length from in to ascii

	ldr	r1, =length
	bl	putstring	@ Outputs length

	ldr	r1, =cCO	
	bl	putch		@ Outputs a comma

	ldr	r1, =cSP	
	bl	putch		@ Outputs a space

	@length s1
	ldr	r1, =s2
	bl	String_length	@ Obtains the length of s2

	ldr	r1, =length
	str 	r0, [r1]	@ Stores length into 'variable'

	ldr	r1, =length
	bl	intasc32	@ Converts length from in to ascii

	ldr	r1, =length
	bl	putstring	@ Outputs length

	ldr	r1, =cCO	
	bl	putch		@ Outputs a comma

	ldr	r1, =cSP	
	bl	putch		@ Outputs a space

	@length s3
	ldr	r1, =s3
	bl	String_length	@ Obtains the length of s3

	ldr	r1, =length
	str 	r0, [r1]	@ Stores length into 'variable'

	ldr	r1, =length
	bl	intasc32	@ Converts length from in to ascii

	ldr	r1, =length
	bl	putstring	@ Outputs length

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test2a
	ldr	r1, =strTest2a	
	bl	putstring	@ Outputs prompt for 2nd Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =s3		@ Loads r2, with s3
	bl	String_equals	@ Check to see if equal
	bl	Boolean_output	@ Outputs results

	@Test2b
	ldr	r1, =strTest2b	
	bl	putstring	@ Outputs prompt for 2nd Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =s1		@ Loads r2, with s1
	bl	String_equals	@ Check to see if equal
	bl	Boolean_output	@ Outputs results


	@Test3a
	ldr	r1, =strTest3a	
	bl	putstring	@ Outputs prompt for 3rd Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =s3		@ Loads r2, with s3
	bl	String_equalsIgnoreCase	@ Check to see if equal while ignoring cases
	bl	Boolean_output	@ Outputs results

	@Test3b
	ldr	r1, =strTest3b	
	bl	putstring	@ Outputs prompt for 3rd Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =s2		@ Loads r2 with s2
	bl	String_equalsIgnoreCase	@ Check to see if equal while ignoring cases
	bl	Boolean_output	@ Outputs results


	@Test4
	ldr	r1, =strTest4	
	bl	putstring	@ Outputs prompt for 4th Test

	ldr	r1, =s1	
	bl	putstring	@ Outputs s1

	ldr	r1, =s1		@ Loads r1 with s1
	bl	String_copy	@ Copies given string into new dynamic string

	ldr	r1, =cCO	
	bl	putch		@ Outputs a comma

	ldr	r1, =cSP	
	bl	putch		@ Outputs a space

	@ldr 	r1, =s4
	@strb	r0, [r1]	@ Loads output into r1
	@bl	putstring	@ Outputs results (s4)

	mov	r1, r0
	bl	putstring	@ Outputs s4

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test5
	ldr	r1, =strTest5
	bl	putstring	@ Outputs prompt for 5th Test

	ldr	r1, =s3		@ Loads r1 with s3
	mov	r2, #4		@ Start index = 4
	mov	r3, #13		@ End index = 13
	bl	String_substring_1 @ Creates new substring

	mov	r1, r0
	bl	putstring	@ Outputs new substring created

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test6
	ldr	r1, =strTest6
	bl	putstring	@ Outputs prompt for 6th Test

	ldr	r1, =s3		@ Loads r1 with s3
	mov	r2, #7		@ Start index = 7
	bl	String_substring_2 @ Creates new substring

	mov	r1, r0
	bl	putstring	@ Outputs new substring created

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test7
	ldr	r1, =strTest7
	bl	putstring	@ Outputs prompt for 7th Test

	ldr	r1, =s2		@ Loads r1 with s2
	mov	r2, #4		@ Start index = 4
	bl	String_charAt	@ Get the character at a desires index

	ldr 	r1, =output
	strb	r0, [r1]	@ Loads output into r1
	bl	putch		@ Outputs results

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test8
	@get substring input
	ldr	r1, =strPrompt4	
	bl	putstring	@ Outputs prompt for user to input a substring

	ldr	r1, =subString1	@ Going to store user input into subString1
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	ldr	r1, =strTest8
	bl	putstring	@ Outputs prompt for 8th Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =subString1	@ Loads in "hat." from user input
	mov	r3, #11		@ Start index = 11
	bl	String_startsWith_1 @ Check to see if string start with given substring at specified index
	bl	Boolean_output	@ Outputs results

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test9
	@get substring input
	ldr	r1, =strPrompt5	
	bl	putstring	@ Outputs prompt for user to input a substring

	ldr	r1, =subString2	@ Going to store user input into subString2
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	ldr	r1, =strTest9
	bl	putstring	@ Outputs prompt for 9th Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =subString2	@ Loads in "Cat" from user input
	bl	String_startsWith_2 @ Check to see if string start with given substring
	bl	Boolean_output	@ Outputs results

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character


	@Test10
	@get substring input
	ldr	r1, =strPrompt6	
	bl	putstring	@ Outputs prompt for user to input a substring

	ldr	r1, =subString3	@ Going to store user input into subString3
	mov	r2, #BUFSIZE	@ Maximum number of bytes to receive
	bl	getstring	@ Call subroutine to get keyboard input

	ldr	r1, =strTest10
	bl	putstring	@ Outputs prompt for 10th Test

	ldr	r1, =s1		@ Loads r1 with s1
	ldr	r2, =subString3	@ Loads in "in the hat." from user input
	bl	String_endsWith	@ Check to see if string ends with given substring
	bl	Boolean_output	@ Outputs results

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	ldr	r1, =strTestCont
	bl	putstring	@ Outputs header for String2.a tests

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	@Codey's tests
	
	b	exit


@ Subroutine Boolean_output: This method outputs whether the results of a function was true or false
@
@ Entering register contents:
@	R0: Contains the boolean value
@	LR: Contains return address
@
@ Returned register contents:
@	None
@
@ All required AAPC registers are preserved

	.global 	Boolean_output

Boolean_output:
	push 	{R4-R8, R10-R11, LR}
	push	{SP}

	cmp	r0, #1		@ Compares to determine whether true or false
	beq	true		@ If equal branch to true, else false

	ldr	r1, =strFalse	
	bl	putstring	@ Outputs FALSE

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character

	b	return

true:
	ldr	r1, =strTrue	
	bl	putstring	@ Outputs TRUE

	ldr	r1, =cCR	
	bl	putch		@ Outputs an endline character

return:
	pop	{SP}
	pop 	{R4-R8, R10-R11, LR}

	bx	LR


exit:
	mov 	r0, #0 		@ Exit Status code set to 0 to indicate "normal completion"
    	mov 	r7, #1 		@ service command code (1) will terminate this program
    	svc 	0 		@ Issue Linux command to terminate program

    .end
