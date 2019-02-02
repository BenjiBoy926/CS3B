.global _start

.text
_start:
	MOV r1, #8	@ First operand
	MOV r2, #1	@ Second operand
	MOV r3, #4	@ Barrel shift const
	ADD r0, r1, r2, LSL r3

_end:
	MOV r7, #1
	SVC 0

.data
# data
