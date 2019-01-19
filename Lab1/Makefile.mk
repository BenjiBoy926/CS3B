PROJ = Lab1

all:
	as -g -o $(PROJ).o $(PROJ).s; ld -o $(PROJ) $(PROJ).o
