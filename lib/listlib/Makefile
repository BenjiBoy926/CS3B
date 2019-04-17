LIB = string.a
SOURCES = $(wildcard *.s)
ASMFLAGS = -g

# Build the library file
lib:
	as $(ASMFLAGS) -o $(LIB) $(SOURCES)

# Clear out generated lib file
clean:
	rm -f $(LIB)
