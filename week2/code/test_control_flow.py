#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: test_control_flow.py
# Description: Demonstrates the use of doctests to test control statements in Python.
# Outputs: Prints results of test cases and doctest outputs to the console.
# Date: Oct 2024

"""
This script demonstrates the use of control statements in Python and verifies their correctness
using doctests. It includes an example function to determine whether a number is even or odd.
"""

import sys
import doctest  # Import the doctest module

def even_or_odd(x=0):
    """
    Determine whether a number is even or odd.

    Args:
        x (int): The number to check (default is 0).

    Returns:
        str: A message indicating whether x is even or odd.

    Examples:
        >>> even_or_odd(10)
        '10 is Even!'
        >>> even_or_odd(5)
        '5 is Odd!'
        >>> even_or_odd(-2)
        '-2 is Even!'
    """
    if x % 2 == 0:
        return f"{x} is Even!"
    return f"{x} is Odd!"

def main(argv):
    """
    Main function to demonstrate the even_or_odd function.

    Args:
        argv (list): Command-line arguments (not used).

    Returns:
        int: Exit status (0 for success).
    """
    print(even_or_odd(22))
    print(even_or_odd(33))
    return 0

if __name__ == "__main__":
    import doctest
    doctest.testmod()  # Run embedded tests
    status = main(sys.argv)
    sys.exit(status)
