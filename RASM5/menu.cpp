#include "menu.h"
using namespace std;

void display_menu(int fileCount, chrono::seconds cppBubblesortTime, chrono::seconds asmBubblesortTime)
{
	// Display header
	display_menu_header(fileCount, cppBubblesortTime, asmBubblesortTime);

	// Display all menu options
	for(int i = 0; i < TOTAL_MENU_OPTIONS; i++)
	{
		cout << '<' << i + 1 << "> " << MENU_OPTIONS[i] << endl;
	}
	output_characters('-', MENU_WIDTH);
	cout << endl;
}

int get_menu_input()
{
	int input = 0;

	do // while(input <= 0 || input > TOTAL_MENU_OPTIONS);
	{
		cout << "Enter your selection: ";
		cin >> input;

		if(cin.fail())
		{
			cout << "*** ERROR: please input an integer ***" << endl;
			cin.clear();
			cin.ignore(100, '\n');
		}
		else if(input <= 0 || input > TOTAL_MENU_OPTIONS)
		{
			cout << "*** ERROR: please input a value between 1 and " << TOTAL_MENU_OPTIONS << endl;
		}

	}while(input <= 0 || input > TOTAL_MENU_OPTIONS);

	return input;
}

void display_menu_header(int fileCount, chrono::seconds cppBubblesortTime, chrono::seconds asmBubblesortTime)
{
	output_centered("RASM5 C vs Assembly", MENU_WIDTH);
	cout << endl;

	output_centered("File Element Count: " + to_string(fileCount), MENU_WIDTH);
	cout << endl;

	output_characters('-', MENU_WIDTH);
	cout << endl;

	cout << "Cpp Bubblesort Time: " << cppBubblesortTime.count() << " seconds" << endl;

	cout << "Asm Bubblesort Time: " << asmBubblesortTime.count() << " seconds" << endl;

	output_characters('-', MENU_WIDTH);
	cout << endl;
}

void output_characters(char ch, int numChars)
{
	cout << setfill(ch); 
	cout << setw(numChars) << ch;
	cout << setfill(' ');
}

void output_centered(const string& str, int space)
{
	int leftBuff = (space - str.length()) / 2;

	cout << setw(leftBuff) << ' ';
	cout << str;
	cout << setw(leftBuff + (space % 2)) << ' ';
}
