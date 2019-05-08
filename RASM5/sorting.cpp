#include "sorting.h"
//#include <fstream>
using namespace std;

chrono::seconds timed_sort(int ar[], int length)
{
	auto start = chrono::system_clock::now();
	cpp_bubble_sort(ar, length);
	auto end = chrono::system_clock::now();
	return chrono::duration_cast<chrono::seconds>(end - start);
}

void cpp_bubble_sort(int ar[], int length)
{
	int i, j;	// Outer index and inner index

	for(i = 0; i < length; i++)
	{
		for(j = 0; j < length - i - 1; j++) 
		{
			if(ar[j + 1] < ar[j])
			{
				swap(ar[j + 1], ar[j]);
			}
		}
	}
}

void input_from_file(int ar[], int length, const std::string& filename)
{
	// Open the file with the given name
	ifstream fin;
	fin.open(filename);

	if(fin.is_open())
	{
		int current = 0;

		while(current < length && !fin.eof())
		{
			fin >> ar[current];
			current++;
		}

		fin.close();
	}
	else
	{
		throw invalid_argument("Filename " + filename + " could not be opened");
	}
}

void output_to_file(int ar[], int length, const std::string& filename)
{
	// Open the file with the given name
	ofstream fout;
	fout.open(filename);

	if(fout.is_open())
	{
		for(int i = 0; i < length; i++)
		{
			fout << ar[i] << endl;
		}

		fout.close();
	}
	else
	{
		throw invalid_argument("Filename " + filename + " could not be opened");
	}
}
