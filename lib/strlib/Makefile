LIB = string.a /usr/lib/arm-linux-gnueabihf/libc.so
SOURCES = $(wildcard *.s)
ASMFLAGS = -g

# Build the library file
lib:
	as $(ASMFLAGS) -o $(LIB) $(SOURCES)

# Clear out generated lib file
clean:
	rm -f $(LIB)
