CC = g++
FLAGS = -std=c++17 -Wall -g
SOURCES = $(wildcard *.cpp) #$(wildcard *.s)
OBJS = $(SOURCES:.cpp=.o) #$(SOURCES:.s=.o)
EXE = $(notdir $(CURDIR))
NAME = CH
TAR = $(NAME)$(EXE)

all: $(EXE)

$(EXE): $(OBJS)
	$(CC) $(OBJS) -o $(EXE)

%.o: %.cpp %.h
	$(CC) $(FLAGS) -c $< -o $@

#%.o: %.s
#	as -g -o $@ $<

clean:
	rm $(OBJS) $(EXE) $(EXE).scr

tar:
	tar cf $(TAR).tar $(EXE).scr Makefile *.cpp *.h

submission:
	script -c "make commands" $(EXE).scr; make tar; make clean

commands:
	date; ls -l; make all; ls -l; valgrind ./$(EXE); exit
	
