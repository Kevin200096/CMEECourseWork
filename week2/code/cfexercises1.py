#!/usr/bin/env python3

"""Some functions to demonstrate basic calculations"""
__author__ = 'Your Name (your.email@domain.com)'
__version__ = '0.0.1'

import sys

# Define the functions

def foo_1(x):
    """Calculate the square root of a number."""
    return x ** 0.5

def foo_2(x, y):
    """Return the larger of two numbers."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Sort three numbers and return them in ascending order."""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x):
    """Calculate the factorial of a number iteratively."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """Calculate the factorial of a number recursively."""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x):
    """Calculate the factorial of a number using a while loop."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

# The main function to test the above functions
def main(argv):
    """Main entry for running test cases."""
    print(f"foo_1(9): {foo_1(9)}")  # Should return the square root of 9 (3.0)
    print(f"foo_2(10, 20): {foo_2(10, 20)}")  # Should return 20, since 20 > 10
    print(f"foo_3(5, 2, 8): {foo_3(5, 2, 8)}")  # Should return [2, 5, 8] as sorted order
    print(f"foo_4(5): {foo_4(5)}")  # Should return 120 (5 factorial)
    print(f"foo_5(5): {foo_5(5)}")  # Should return 120 (recursive factorial)
    print(f"foo_6(5): {foo_6(5)}")  # Should return 120 (factorial using while loop)
    return 0

# Standard boilerplate code to call the main() function when the script is executed
if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)

#######################################

#!/usr/bin/env python3

"""Some functions to demonstrate basic calculations"""
__author__ = 'Your Name (your.email@domain.com)'
__version__ = '0.0.1'

import sys

# Define the functions

def foo_1(x):
    """Calculate the square root of a number."""
    return x ** 0.5

def foo_2(x, y):
    """Return the larger of two numbers."""
    if x > y:
        return x
    return y

def foo_3(x, y, z):
    """Sort three numbers and return them in ascending order."""
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x):
    """Calculate the factorial of a number iteratively."""
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x):
    """Calculate the factorial of a number recursively."""
    if x == 1:
        return 1
    return x * foo_5(x - 1)

def foo_6(x):
    """Calculate the factorial of a number using a while loop."""
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

# The main function to test the above functions
def main(argv):
    """Main entry for running test cases."""
    print(f"foo_1(10): {foo_1(10)}")  # Test case: Square root of 10
    print(f"foo_2(10, 5): {foo_2(10, 5)}")  # Test case: Larger of 10 and 5
    print(f"foo_3(5, 4, 3): {foo_3(5, 4, 3)}")  # Test case: Sorting 5, 4, 3
    print(f"foo_4(5): {foo_4(5)}")  # Test case: Factorial of 5
    print(f"foo_5(10): {foo_5(10)}")  # Test case: Factorial of 10 (recursive)
    print(f"foo_6(5): {foo_6(5)}")  # Test case: Factorial of 5 (while loop)
    return 0

# Standard boilerplate code to call the main() function when the script is executed
if __name__ == "__main__":
    status = main(sys.argv)
    sys.exit(status)
