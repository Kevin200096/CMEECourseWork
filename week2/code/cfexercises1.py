#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: cfexercises1.py
# Description: Demonstrates basic Python functions for calculations, including square roots,
# finding the maximum of two numbers, sorting, and calculating factorials.
# Outputs: Printed results of test cases for each function.
# Date: Oct 2024

"""
A script containing a collection of functions to demonstrate basic calculations.
Includes finding the square root, determining the larger of two numbers, sorting numbers,
and calculating factorials using various methods.

The script also demonstrates testing these functions via a `main` function.
"""

__author__ = 'Kevin Zhao (kz1724@ic.ac.uk)'
__version__ = '0.0.2'

import sys

# Define the functions

def foo_1(x):
    """
    Calculate the square root of a given number.

    Args:
        x (float): The number for which to calculate the square root.

    Returns:
        float: The square root of the given number.

    Example:
        >>> foo_1(9)
        3.0
    """
    return x ** 0.5

def foo_2(x, y):
    """
    Return the larger of two given numbers.

    Args:
        x (int or float): The first number.
        y (int or float): The second number.

    Returns:
        int or float: The larger of the two numbers.

    Example:
        >>> foo_2(10, 5)
        10
    """
    return max(x, y)

def foo_3(x, y, z):
    """
    Sort three numbers and return them in ascending order.

    Args:
        x (int or float): The first number.
        y (int or float): The second number.
        z (int or float): The third number.

    Returns:
        list: A list containing the three numbers in ascending order.

    Example:
        >>> foo_3(5, 4, 3)
        [3, 4, 5]
    """
    return sorted([x, y, z])

def factorial(x):
    """
    Calculate the factorial of a number iteratively.

    Args:
        x (int): The number to calculate the factorial of.

    Returns:
        int: The factorial of the given number.

    Example:
        >>> factorial(5)
        120
    """
    result = 1
    for i in range(1, x + 1):
        result *= i
    return result

# The main function to test the above functions
def main(argv):
    """
    Main entry point for running test cases. Executes a series of test cases for the functions 
    defined in this module and prints their results.

    Args:
        argv (list): Command-line arguments (not used in this script).

    Returns:
        int: Status code (0 for success).
    """
    print(f"foo_1(10): {foo_1(10)}")  # Test case: Square root of 10
    print(f"foo_2(10, 5): {foo_2(10, 5)}")  # Test case: Larger of 10 and 5
    print(f"foo_3(5, 4, 3): {foo_3(5, 4, 3)}")  # Test case: Sorting 5, 4, 3
    print(f"factorial(5): {factorial(5)}")  # Test case: Factorial of 5
    print(f"factorial(10): {factorial(10)}")  # Test case: Factorial of 10
    return 0  # Return success status code

if __name__ == "__main__":
    # Pass the system arguments to the main function and exit with the status code returned
    status = main(sys.argv)
    sys.exit(status)
