#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: MyExampleScript.py
# Description: Demonstrates a simple function that squares a number and prints the result.
# Outputs: Prints the squared value of the input.
# Date: Oct 2024

"""
This script defines a simple function `foo` that squares a number and prints the result.
It demonstrates basic function definition and usage in Python.
"""

def foo(x):
    """
    Squares the input value and prints the result.

    Args:
        x (int or float): The number to be squared.

    Returns:
        None: Prints the squared value directly.

    Example:
        >>> foo(2)
        4
    """
    x *= x  # Same as x = x * x
    print(x)

# Call the function with an example value
foo(2)
