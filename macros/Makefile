OBJS = stdin.o stdout.o

# Compile and link all programs
all: $(OBJS)	

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	
