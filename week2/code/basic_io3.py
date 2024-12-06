#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: basic_io3.py
# Description: Demonstrates saving and loading objects using Python's pickle module.
# Outputs: Prints the loaded object to the console.
# Date: Oct 2024

"""
This script demonstrates how to save and load Python objects using the pickle module.
It serializes a dictionary to a binary file and then deserializes it back into a Python object.
"""

#############################
# STORING OBJECTS
#############################

import pickle

# To save an object (even complex) for later use
my_dictionary = {"a key": 10, "another key": 11}

# Save the dictionary to a file
with open('../sandbox/testp.p', 'wb') as f:  # 'b' indicates binary mode
    pickle.dump(my_dictionary, f)

# Load the data again
with open('../sandbox/testp.p', 'rb') as f:
    another_dictionary = pickle.load(f)

print(another_dictionary)
