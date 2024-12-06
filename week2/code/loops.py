#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: loops.py
# Description: Demonstrates the use of `for` and `while` loops with simple examples in Python.
# Outputs: Prints the results of iterations and calculations to the console.
# Date: Oct 2024

"""
This script demonstrates basic usage of `for` and `while` loops in Python through examples
of iterating over ranges, lists, and performing calculations.
"""

# FOR loops
for i in range(5):
    print(i)

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
    print(k)

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
    total = total + s
    print(total)

# WHILE loop
z = 0
while z < 100:
    z = z + 1
    print(z)
