__author__ = 'Zhongbin Hu'
__version__ = '0.0.1'

import sys

def foo_1(x=1):
    # if not specified, x should take value 1.
    return x ** 0.5

def foo_2(x=2, y=1):
    # if not specified, x should take value 2 and y should take 1.
    if x > y:
        return x
    return y

def foo_3(x=1, y=2, z=3):
    # if not specified, x should take value 1, y should take 2 and z should take 3.
    if x > y:
        tmp = y
        y = x
        x = tmp
    if y > z:
        tmp = z
        z = y
        y = tmp
    return [x, y, z]

def foo_4(x=3):
    # if not specified, x should take value 3.
    result = 1
    for i in range(1, x + 1):
        result = result * i
    return result

def foo_5(x=1): 
    # a recursive function that calculates the factorial of x
    if x == 1:
        return 1
    return x * foo_5(x - 1)
     
def foo_6(x=1): 
    # Calculate the factorial of x in a different way; no if statement involved
    facto = 1
    while x >= 1:
        facto = facto * x
        x = x - 1
    return facto

def main(argv):
    print(foo_1(10))
    print(foo_2(10, 5))
    print(foo_3(5, 4, 3))
    print(foo_4(5))
    print(foo_5(10))
    print(foo_6(5))
    #Test all the functions
    return 0

if (__name__ == "__main__"):
    status = main(sys.argv)
    sys.exit(status)