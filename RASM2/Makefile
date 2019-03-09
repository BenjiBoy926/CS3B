EXEC = RAMS2
OBJS = RAMS2.o GetIntInput.o OutputHeader.o
LIB = ../macros/barnett_15feb19.a

# Compile and link all programs
all: $(EXEC)
	
# Link all programs
$(EXEC): $(OBJS)
	ld -o $(EXEC) $(OBJS) $(LIB)

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	

# Clear out object files and executables
clean:
	rm -f *.o
