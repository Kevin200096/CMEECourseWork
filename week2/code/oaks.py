#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: find_oaks.py
# Description: Identifies oak species from a list of taxa using loops and list comprehensions, and formats their names.
# Outputs: Prints sets of oak species in original and uppercase formats.
# Date: Oct 2024

"""
This script processes a list of species names to identify oak species (genus 'Quercus') using:
1. For loops
2. List comprehensions

The results are printed in their original and uppercase formats.
"""

# List of species names
taxa = [
    'Quercus robur',
    'Fraxinus excelsior',
    'Pinus sylvestris',
    'Quercus cerris',
    'Quercus petraea',
]

def is_an_oak(name):
    """
    Determines if a species belongs to the genus 'Quercus'.

    Args:
        name (str): The species name.

    Returns:
        bool: True if the species is an oak, False otherwise.

    Example:
        >>> is_an_oak('Quercus robur')
        True
        >>> is_an_oak('Pinus sylvestris')
        False
    """
    return name.lower().startswith('quercus ')

# Identify oaks using for loops
oaks_loops = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops.add(species)
print(oaks_loops)

# Identify oaks using list comprehensions
oaks_lc = set([species for species in taxa if is_an_oak(species)])
print(oaks_lc)

# Get oak names in uppercase using for loops
oaks_loops_upper = set()
for species in taxa:
    if is_an_oak(species):
        oaks_loops_upper.add(species.upper())
print(oaks_loops_upper)

# Get oak names in uppercase using list comprehensions
oaks_lc_upper = set([species.upper() for species in taxa if is_an_oak(species)])
print(oaks_lc_upper)
