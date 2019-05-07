#include "menu.h"
#include "sorting.h"
using namespace std;

const int ARRAY_SIZE = 200000;
const string INPUT_FILE = "input.txt";
const string CPP_OUTPUT_FILE = "cpp_output.txt";
const string ASM_OUTPUT_FILE = "asm_output.txt";

int main()
{
	int array[ARRAY_SIZE];
	chrono::seconds cppSortTime = 0s;
	chrono::seconds asmSortTime = 0s;
	int input = 0;

	do // while(input != TOTAL_MENU_OPTIONS)
	{
		// Clear screen
		system("cls");

		// Display menu and get the input
		display_menu(ARRAY_SIZE, cppSortTime, asmSortTime);
		input = get_menu_input();

		switch(input)
		{
			case 1:
				input_from_file(array, ARRAY_SIZE, INPUT_FILE);
				// init assembly array from file
				break;
			case 2:
				cppSortTime = timed_sort(array, ARRAY_SIZE);
				output_to_file(array, ARRAY_SIZE, CPP_OUTPUT_FILE);
				break;
			case 3:
				// asm bubble sort
				// asm output to file
				break;	
		}

		// Pause if not quitting
		if(input != TOTAL_MENU_OPTIONS)
		{
			system("pause");
		}

	}while(input != TOTAL_MENU_OPTIONS);

	return 0;
}