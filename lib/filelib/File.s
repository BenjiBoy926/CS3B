/*********
PROTOTYPES
**********/

/*
r0 =string getline(r0 filehandle, )
*/
.global getline

/***********
DATA SECTION
************/

.data

.equ EOF, 3	// End of file ascii code
.equ BUFSIZE, 512	// Size of the buffer used to read from file

buffer:	.skip BUFSIZE