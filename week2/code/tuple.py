#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: tuple.py
# Description: Iterates through a tuple of bird data and prints each species' information in a formatted manner.
# Outputs: Prints the Latin name, common name, and mass of each species to the console.
# Date: Oct 2024

"""
This script processes a tuple of bird data, where each entry contains the
Latin name, common name, and mass of a bird species. It prints the details
of each species in a formatted manner.
"""

# Dataset of birds: (Latin name, Common name, Mass)
birds = (
    ('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
    ('Delichon urbica', 'House martin', 19),
    ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
    ('Junco hyemalis', 'Dark-eyed junco', 19.6),
    ('Tachycineata bicolor', 'Tree swallow', 20.2),
)

# Loop through each tuple and print the formatted output
for bird in birds:
    latin_name, common_name, mass = bird
    print(f"Latin name: {latin_name} Common name: {common_name} Mass: {mass}")
