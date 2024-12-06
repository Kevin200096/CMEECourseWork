#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: debugme.py
# Description: Contains a function with intentional bugs to illustrate debugging techniques.
# Outputs: May raise errors during execution, demonstrating edge cases and debugging.
# Date: Oct 2024

"""
This script demonstrates a buggy function for educational purposes.
It includes intentional errors to illustrate debugging techniques and the importance
of handling edge cases in Python functions.
"""

def buggyfunc(x):
    """
    Demonstrates a buggy function with a potential division by zero error.

    Args:
        x (int): A positive integer input.

    Returns:
        float: The result of the final calculation.

    Raises:
        ZeroDivisionError: If the function attempts to divide by zero.
    """
    y = x
    for i in range(x):
        y = y - 1
        z = x / y  # Potential division by zero when y becomes 0
    return z

# Test the function with an example input
buggyfunc(20)
