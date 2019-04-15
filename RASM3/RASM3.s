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

// String test prompts: general
strTest:		.asciz	"(Joseph) String1.a Tests #1-10:"
strTestCont:	.asciz 	"(Cody) String2.a Tests #11-20:" 

// String test prompts: String1.a (Joseph)
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

// String test prompts: String2.a (Codey)
strTest11:	.asciz  "11. String_indexOf_1(s2, g): "
strTest12:	.asciz	"12. String_indexOf_2(s2, g, 9): "
strTest13:	.asciz	"13. String_indexOf_3(s2, egg): "
strTest14:	.asciz	"14. String_lastIndexOf_1(s2, g): "
strTest15:	.asciz	"15. String_lastIndexOf_2(s2, g, 9): "
strTest16:	.asciz	"16. String_lastIndexOf_3(s2, egg): "
strTest17:	.asciz	"17. String_replace(s1, C, B): "
strTest18:	.asciz	"18. String_toLowerCase(s1): "
strTest19:	.asciz	"19. String_toUpperCase(s1): "
strTest20:	.asciz	"20. String_concat(s1, <space>) + String_concat(s1, s2): "	

length:		.skip 	12	@ Used to store length of variable for output
output:		.skip 	100	@ Used to store output when needed
intBuffer:	.skip	13	@ Used to store a string representation of numbers to output
s1:		.skip 	100	@ Used to store user input (limited to 100 characters)
s2:		.skip 	100	@ Used to store user input (limited to 100 characters)
s3:		.skip 	100	@ Used to store user input (limited to 100 characters)
s4:		.skip 	100	@ Used to store sopy of s1 (limited to 100 characters)

subString1:	.skip 	100	@ Used to store user input in test8
subString2:	.skip	100	@ Used to store uner input in test9
subString3:	.skip	100	@ Used to store user input in test10

substring4:	.asciz	"egg"	@ Used to test against user in input in tests 13 and 16
substring5:	.asciz  " "		@ Used to concatenate to the first input string in test 20

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

	// Put another carriage return
	ldr 	r1, =cCR
	bl putch

	/*
	CODEY'S TESTS
	*/

	ldr	r1, =strTestCont
	bl	putstring	@ Outputs header for String2.a tests

	ldr 	r1, =cCR	@ Set point to store a caridge return
	bl 	putch		@ Call subroutine to print

	/*
	TEST 11
	*/

	// Output the prompt
	ldr	r1, =strTest11
	bl putstring

	// Get the index of 'g' in the second string
	ldr r1, =s2
	mov r2, #'g'
	bl String_indexOf

	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 12
	*/

	// Output the prompt
	ldr	r1, =strTest12
	bl putstring

	// Get the index of 'g' in the second string
	ldr r1, =s2
	mov r2, #'g'
	mov r3, #9
	bl String_indexOfFrom

	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 13
	*/

	// Output the prompt
	ldr r1, =strTest13
	bl putstring

	// Find the index of "egg" in the second input string
	ldr r1, =s2
	ldr r2, =substring4
	bl String_indexOfString

	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 14
	*/

	// Output the prompt
	ldr r1, =strTest14
	bl putstring

	// Find the index of "g" in the second input string
	ldr r1, =s2
	mov r2, #'g'
	bl String_lastIndexOf

	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 15
	*/

	// Output the prompt
	ldr r1, =strTest15
	bl putstring

	// Find the index of "g" in the second input string
	ldr r1, =s2
	mov r2, #'g'
	mov r3, #9
	bl String_lastIndexOfFrom
	
	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 16
	*/

	// Output the prompt
	ldr r1, =strTest16
	bl putstring

	// Find the index of "egg" in the second input string
	ldr r1, =s2
	ldr r2, =substring4
	bl String_lastIndexOfString
	
	// Print the index followed by endline
	bl print_int_and_endline

	/*
	TEST 17
	*/

	// Output the prompt
	ldr r1, =strTest17
	bl putstring

	// Replace 'C' with 'B' in first input string
	ldr r1, =s1
	mov r2, #'C'
	mov r3, #'B'
	bl String_replace
	
	// Output string after replace
	ldr r1, =s1
	bl putstring

	// End the line
	ldr r1, =cCR
	bl putch

	/*
	TEST 18
	*/

	// Output the prompt
	ldr r1, =strTest18
	bl putstring

	// Convert first input string to lower case
	ldr r1, =s1
	bl String_toLowerCase
	
	// Output string after change
	ldr r1, =s1
	bl putstring

	// End the line
	ldr r1, =cCR
	bl putch
	
	/*
	TEST 19
	*/

	// Output the prompt
	ldr r1, =strTest19
	bl putstring

	// Convert first input string to upper case
	ldr r1, =s1
	bl String_toUpperCase
	
	// Output string after change
	ldr r1, =s1
	bl putstring

	// End the line
	ldr r1, =cCR
	bl putch

	/*
	TEST 20
	*/

	// Output the prompt
	ldr r1, =strTest20
	bl putstring

	// Concat a space to the first string
	ldr r1, =s1
	ldr r2, =substring5
	bl String_concat

	// Concat input string 1 and 2 together
	ldr r1, =s1
	ldr r2, =s2
	bl String_concat
	
	// Output string after replace
	mov r1, r0
	bl putstring

	// End the line
	ldr r1, =cCR
	bl putch

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
	// push	{SP}

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
	// pop	{SP}
	pop 	{R4-R8, R10-R11, LR}

	bx	LR

/*
void print_int_and_endline(r0 int)
----------------------------------
Output the integer in r0 followed by carriage return
----------------------------------
*/
print_int_and_endline:
	push {lr}
	
	// Convert r0 to ascii and store in buffer
	ldr r1, =intBuffer
	bl intasc32
	
	// Output the integer string
	ldr r1, =intBuffer
	bl putstring

	// Put a carriage return
	ldr r1, =cCR
	bl putch

	pop {pc}


exit:
	mov 	r0, #0 		@ Exit Status code set to 0 to indicate "normal completion"
    	mov 	r7, #1 		@ service command code (1) will terminate this program
    	svc 	0 		@ Issue Linux command to terminate program

    .end
