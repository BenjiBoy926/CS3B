EXEC = exec
SOURCES = $(wildcard *.s)
OBJS = $(SOURCES:.s=.o)
LIB = $(wildcard ../lib/*/*.a) /usr/lib/arm-linux-gnueabihf/libc.so
LINKER = /lib/ld-linux-armhf.so.3

# Compile and link all programs
all: $(EXEC)
	
objects: $(OBJS)

# Link all programs
$(EXEC): $(OBJS)
	ld -o $(EXEC) $(OBJS) $(LIB) -dynamic-linker $(LINKER)

# Build each object by assembling the assembly file of the same name
%.o: %.s
	as -g -o $@ $<	

# Remove generated files
clean:
	rm -f $(EXEC) *.o
