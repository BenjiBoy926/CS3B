#ifndef MENU_H_
#define MENU_H_

#include <iostream>
#include <iomanip>
#include <chrono>
#include <string>

const int MENU_WIDTH = 45;
const int TOTAL_MENU_OPTIONS = 4;
const std::string MENU_OPTIONS[TOTAL_MENU_OPTIONS] = {
	"Load input file (integers)",
	"Sort using C Bubblesort algorithm",
	"Sort using Assembly Bubblesort algorithm",
	"Quit"
};

void display_menu(int fileCount, std::chrono::seconds cppBubblesortTime,
	std::chrono::seconds asmBubblesortTime);
int get_menu_input();

void display_menu_header(int fileCount, std::chrono::seconds cppBubblesortTime,
	std::chrono::seconds asmBubblesortTime);

void output_characters(char ch, int numChars);
void output_centered(const std::string& str, int space);

#endif // MENU_H_
