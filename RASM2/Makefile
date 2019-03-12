EXEC = exec
SOURCES = $(wildcard *.s)
OBJS = $(SOURCES:.s=.o)
LIB = $(wildcard ../macros/*.a)

# Compile and link all programs
all: $(EXEC)
	
objects: $(OBJS)

# Link all programs
$(EXEC): $(OBJS)
	ld -o $(EXEC) $(OBJS) $(LIB)

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	

# Clear out object files and executables
clean:
	rm -f *.o
