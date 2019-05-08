NAME = CH

# COMPILING
CC = g++
FLAGS = -std=c++17 -Wall -g

# SOURCES
CPP_SOURCES = $(wildcard *.cpp)
ASM_SOURCES = $(wildcard *.s)
SOURCES = $(CPP_SOURCES) $(ASM_SOURCES)

# OBJECTS
CPP_OBJS = $(CPP_SOURCES:.cpp=.o)
ASM_OBJS = $(ASM_SOURCES:.s=.o)
OBJS = $(CPP_OBJS) $(ASM_OBJS)

# EXECUTABLE / SUBMISSION
EXE = $(notdir $(CURDIR))
TAR = $(NAME)$(EXE)

all: $(EXE)

$(EXE): $(OBJS)
	$(CC) $(OBJS) -o $(EXE)

%.o: %.cpp %.h
	$(CC) $(FLAGS) -c $< -o $@

%.o: %.s
	as -g -o $@ $<

clean:
	rm $(OBJS) $(EXE) $(EXE).scr

tar:
	tar cf $(TAR).tar $(EXE).scr Makefile *.cpp *.h

submission:
	script -c "make commands" $(EXE).scr; make tar; make clean

commands:
	date; ls -l; make all; ls -l; valgrind ./$(EXE); exit
	
