#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: script_arguments.py
# Description: Demonstrates how to access and print command-line arguments in Python.
# Outputs: Prints the script name, number of arguments, and the list of arguments passed.
# Date: Oct 2024

"""
This script demonstrates how to use the `sys.argv` list to access command-line arguments.
It prints:
1. The script name.
2. The number of arguments passed.
3. The list of arguments.
"""

import sys

# Print script name and command-line arguments
print("This is the name of the script: ", sys.argv[0])
print("Number of arguments: ", len(sys.argv))
print("The arguments are: ", str(sys.argv))
