#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: control_flow.py
# Description: Demonstrates the use of control statements in Python through example functions.
# Outputs: Prints results of the control statement operations to the console.
# Date: Oct 2024

"""
This script demonstrates the use of control statements in Python through several
example functions, including determining even or odd numbers, finding divisors,
checking for primes, and listing all primes up to a given number.
"""

import sys

def even_or_odd(x=0):
    """
    Determine whether a number is even or odd.

    Args:
        x (int): The number to check (default is 0).

    Returns:
        str: A message indicating whether x is even or odd.

    Example:
        >>> even_or_odd(2)
        '2 is Even!'
    """
    if x % 2 == 0:
        return f"{x} is Even!"
    return f"{x} is Odd!"

def largest_divisor_five(x=120):
    """
    Find the largest divisor of x among 2, 3, 4, and 5.

    Args:
        x (int): The number to check (default is 120).

    Returns:
        str: A message indicating the largest divisor of x, or that no divisor was found.

    Example:
        >>> largest_divisor_five(120)
        'The largest divisor of 120 is 5'
    """
    largest = 0
    if x % 5 == 0:
        largest = 5
    elif x % 4 == 0:
        largest = 4
    elif x % 3 == 0:
        largest = 3
    elif x % 2 == 0:
        largest = 2
    else:
        return f"No divisor found for {x}!"
    return f"The largest divisor of {x} is {largest}"

def is_prime(x=70):
    """
    Determine whether an integer is a prime number.

    Args:
        x (int): The number to check (default is 70).

    Returns:
        bool: True if x is a prime number, False otherwise.

    Example:
        >>> is_prime(59)
        59 is a prime!
        True
    """
    for i in range(2, x):
        if x % i == 0:
            print(f"{x} is not a prime: {i} is a divisor")
            return False
    print(f"{x} is a prime!")
    return True

def find_all_primes(x=22):
    """
    Find all prime numbers up to a given number.

    Args:
        x (int): The upper limit to find primes (default is 22).

    Returns:
        list: A list of all prime numbers up to x.

    Example:
        >>> find_all_primes(10)
        There are 4 primes between 2 and 10
        [2, 3, 5, 7]
    """
    allprimes = []
    for i in range(2, x + 1):
        if is_prime(i):
            allprimes.append(i)
    print(f"There are {len(allprimes)} primes between 2 and {x}")
    return allprimes

def main(argv):
    """
    Main function to demonstrate the control flow functions.

    Args:
        argv (list): Command-line arguments (not used).

    Returns:
        int: Exit status (0 for success).
    """
    print(even_or_odd(22))
    print(even_or_odd(33))
    print(largest_divisor_five(120))
    print(largest_divisor_five(121))
    print(is_prime(60))
    print(is_prime(59))
    print(find_all_primes(100))
    return 0

if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)
