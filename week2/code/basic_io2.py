#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: basic_io2.py
# Description: Saves elements of a list to a file, each element on a new line.
# Outputs: A text file with the list elements.
# Date: Oct 2024

"""
This script demonstrates how to write elements of a list to a file in Python.
Each element is written to a new line in the output file.
"""

#############################
# FILE OUTPUT
#############################

# Save the elements of a list to a file
list_to_save = range(100)

with open('../sandbox/testout.txt', 'w') as f:
    for i in list_to_save:
        f.write(str(i) + '\n')  # Add a new line at the end
