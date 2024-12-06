#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: lc1.py
# Description: Demonstrates the use of list comprehensions and loops to extract information from a tuple of bird data.
# Outputs: Prints the extracted Latin names, common names, and mean body masses using both methods.
# Date: Oct 2024

"""
This script demonstrates two methods (list comprehensions and loops) for extracting
specific data fields (Latin names, common names, and mean body masses) from a dataset
of bird species.
"""

# Dataset of bird species
birds = (
    ('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
    ('Delichon urbica', 'House martin', 19),
    ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
    ('Junco hyemalis', 'Dark-eyed junco', 19.6),
    ('Tachycineata bicolor', 'Tree swallow', 20.2),
)

# (1) Extract data using list comprehensions
latin_names = [bird[0] for bird in birds]
common_names = [bird[1] for bird in birds]
mean_masses = [bird[2] for bird in birds]

# Output results from list comprehensions
print("Latin names:", latin_names)
print("Common names:", common_names)
print("Mean body masses:", mean_masses)

# (2) Extract data using conventional loops
latin_names_loop = []
common_names_loop = []
mean_masses_loop = []

for bird in birds:
    latin_names_loop.append(bird[0])
    common_names_loop.append(bird[1])
    mean_masses_loop.append(bird[2])

# Output results from loops
print("Latin names (using loops):", latin_names_loop)
print("Common names (using loops):", common_names_loop)
print("Mean body masses (using loops):", mean_masses_loop)
