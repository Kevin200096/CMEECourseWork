#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: cfexercises2.py
# Description: Contains a series of functions demonstrating loops and control flow in Python.
# Outputs: Printed 'hello' messages based on various loop conditions.
# Date: Oct 2024

"""
This script demonstrates basic control flow and looping mechanisms in Python.
It includes examples of `for` and `while` loops, nested loops, and break conditions.
"""

########################
def hello_1(x):
    """
    Prints 'hello' for each number divisible by 3 within the range [0, x).

    Args:
        x (int): The range limit (exclusive).

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_1(12)
        hello
        hello
        hello
        hello
    """
    for j in range(x):
        if j % 3 == 0:
            print('hello')
    print(' ')


hello_1(12)

########################
def hello_2(x):
    """
    Prints 'hello' for each number in range [0, x) where:
    - The number modulo 5 equals 3, or
    - The number modulo 4 equals 3.

    Args:
        x (int): The range limit (exclusive).

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_2(12)
        hello
        hello
        hello
        hello
    """
    for j in range(x):
        if j % 5 == 3:
            print('hello')
        elif j % 4 == 3:
            print('hello')
    print(' ')


hello_2(12)

########################
def hello_3(x, y):
    """
    Prints 'hello' for every number in the range [x, y).

    Args:
        x (int): Start of the range (inclusive).
        y (int): End of the range (exclusive).

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_3(3, 17)
        hello
        hello
        ...
        (14 lines of 'hello')
    """
    for i in range(x, y):
        print('hello')
    print(' ')


hello_3(3, 17)

########################
def hello_4(x):
    """
    Prints 'hello' repeatedly, incrementing x by 3 each time,
    until x equals 15.

    Args:
        x (int): Starting value.

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_4(0)
        hello
        hello
        hello
        hello
        hello
    """
    while x != 15:
        print('hello')
        x = x + 3
    print(' ')


hello_4(0)

########################
def hello_5(x):
    """
    Prints 'hello' based on specific conditions within a loop:
    - If x equals 31, prints 'hello' 7 times (nested loop).
    - If x equals 18, prints 'hello' once.
    - Increments x until it reaches 100.

    Args:
        x (int): Starting value.

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_5(12)
        hello
        hello
        hello
        ...
        (Prints based on conditions)
    """
    while x < 100:
        if x == 31:
            for k in range(7):
                print('hello')
        elif x == 18:
            print('hello')
        x = x + 1
    print(' ')


hello_5(12)

########################
def hello_6(x, y):
    """
    Prints 'hello' followed by the value of y in a loop until
    y equals 6. The loop breaks when y equals 6.

    Args:
        x (bool): Determines if the loop runs (True to start).
        y (int): Starting value of y.

    Returns:
        None: Outputs directly to the console.

    Example:
        >>> hello_6(True, 0)
        hello! 0
        hello! 1
        ...
        hello! 5
    """
    while x:  # while x is True
        print("hello! " + str(y))
        y += 1  # increment y by 1
        if y == 6:
            break
    print(' ')


hello_6(True, 0)
