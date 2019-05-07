#ifndef SORTING_H_
#define SORTING_H_

#include <chrono>
#include <utility>
#include <iostream>
#include <exception>

std::chrono::seconds timed_sort(int ar[], int length);
void cpp_bubble_sort(int ar[], int length);
void input_from_file(int ar[], int length, const std::string& filename);
void output_to_file(int ar[], int length, const std::string& filename);

#endif // SORTING_H_
