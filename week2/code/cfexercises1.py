#!/usr/bin/env python3

"""
A collection of functions to demonstrate basic calculations, including finding the 
square root, determining the larger of two numbers, sorting numbers, and calculating 
factorials using various methods (iterative, recursive, and while-loop-based approaches).
"""

__author__ = 'Kevin Zhao (kz1724@ic.ac.uk)'
__version__ = '0.0.1'

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
    if x > y:
        return x
    return y

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
    # Compare x and y, swap if x is greater than y
    if x > y:
        tmp = y
        y = x
        x = tmp
    # Compare y and z, swap if y is greater than z
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z] # Return the sorted values as a list

def foo_4(x):
    """
    Calculate the factorial of a number iteratively.

    Args:
        x (int): The number to calculate the factorial of.

    Returns:
        int: The factorial of the given number.

    Example:
        >>> foo_4(5)
        120
    """
    result = 1 # Initialize result to 1 (the factorial of 0 is also 1)
    # Iterate from 1 to x (inclusive) and multiply each number to result
    for i in range(1, x + 1):
        result = result * i
    return result # Return the computed factorial

def foo_5(x):
    """
    Calculate the factorial of a number recursively.

    Args:
        x (int): The number to calculate the factorial of.

    Returns:
        int: The factorial of the given number.

    Example:
        >>> foo_5(5)
        120
    """
    if x == 1: # Base case: factorial of 1 is 1
        return 1
    return x * foo_5(x - 1) # Recursive call

def foo_6(x):
    """
    Calculate the factorial of a number using a while loop.

    Args:
        x (int): The number to calculate the factorial of.

    Returns:
        int: The factorial of the given number.

    Example:
        >>> foo_6(5)
        120
    """
    facto = 1 # Initialize result as 1
    while x >= 1: # Continue the loop while x is greater than or equal to 1
        facto = facto * x # Multiply the current value of x to facto
        x = x - 1 # Decrement x by 1
    return facto # Return the computed factorial

# The main function to test the above functions
def main(argv):
    """
    Main entry point for running test cases. Executes a series of test cases for the functions 
    defined in this module and prints their results.

    Args:
        argv (list): Command-line arguments (not used in this script).

    Returns:
        int: Status code (0 for success).

    Example:
        Running the script will display the test results of each function.
    """
    print(f"foo_1(10): {foo_1(10)}")  # Test case: Square root of 10
    print(f"foo_2(10, 5): {foo_2(10, 5)}")  # Test case: Larger of 10 and 5
    print(f"foo_3(5, 4, 3): {foo_3(5, 4, 3)}")  # Test case: Sorting 5, 4, 3
    print(f"foo_4(5): {foo_4(5)}")  # Test case: Factorial of 5
    print(f"foo_5(10): {foo_5(10)}")  # Test case: Factorial of 10 (recursive)
    print(f"foo_6(5): {foo_6(5)}")  # Test case: Factorial of 5 (while loop)
    return 0 # Return success status code

# Standard boilerplate code to call the main() function when the script is executed
if __name__ == "__main__":
    # Pass the system arguments to the main function and exit with the status code returned
    status = main(sys.argv)
    sys.exit(status)