LIB = std.a
SOURCES = $(wildcard *.s)
ASFLAGS = -g

# Build the library file
lib:
	as $(ASFLAGS) -o $(LIB) $(SOURCES) 

# Clear out generated lib file
clean:
	rm -f $(LIB)
