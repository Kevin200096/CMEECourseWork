#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: basic_io1.py
# Description: Demonstrates basic file input operations, including reading lines and skipping blank lines.
# Outputs: Prints lines from the file to the console.
# Date: Oct 2024

"""
This script demonstrates basic file input operations in Python. It reads the contents
of a file and prints each line to the console. It also includes functionality to skip
blank lines when reading a file.
"""

#############################
# FILE INPUT
#############################

# Open a file for reading and print all lines
with open('../sandbox/test.txt', 'r') as f:
    # use "implicit" for loop:
    # if the object is a file, Python will cycle over lines
    for line in f:
        print(line)

# Open the file again and print non-blank lines
with open('../sandbox/test.txt', 'r') as f:
    for line in f:
        if len(line.strip()) > 0:
            print(line)
