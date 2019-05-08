#include "menu.h"
#include "sorting.h"
using namespace std;

extern "C" void asm_bubble_sort(int array[], int length);

const int ARRAY_SIZE = 20000;
const string INPUT_FILE = "input.txt";
const string CPP_OUTPUT_FILE = "cpp_output.txt";
const string ASM_OUTPUT_FILE = "asm_output.txt";

int main()
{
	int cpp_array[ARRAY_SIZE];
	int asm_array[ARRAY_SIZE];
	chrono::seconds cppSortTime = 0s;
	chrono::seconds asmSortTime = 0s;
	int input = 0;

	do // while(input != TOTAL_MENU_OPTIONS)
	{
		// Clear screen
		system("clear");

		// Display menu and get the input
		display_menu(ARRAY_SIZE, cppSortTime, asmSortTime);
		input = get_menu_input();

		switch(input)
		{
			case 1:
				input_from_file(cpp_array, ARRAY_SIZE, INPUT_FILE);
				input_from_file(asm_array, ARRAY_SIZE, INPUT_FILE);
				break;
			case 2:
				cppSortTime = timed_sort(cpp_array, ARRAY_SIZE, cpp_bubble_sort);
				output_to_file(cpp_array, ARRAY_SIZE, CPP_OUTPUT_FILE);
				break;
			case 3:
				asmSortTime = timed_sort(asm_array, ARRAY_SIZE, asm_bubble_sort);
				output_to_file(asm_array, ARRAY_SIZE, ASM_OUTPUT_FILE);
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
