EXEC = Lab3
OBJS = Lab3.o

# Compile and link all programs
all: $(EXEC)
	
# Link all programs
$(EXEC): $(OBJS)
	ld -o $(EXEC) $(OBJS)

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	

# Clear out object files and executables
clean:
	rm -f *.o
