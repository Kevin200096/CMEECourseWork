#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: dictionary.py
# Description: Creates a dictionary mapping taxonomic orders to sets of species using two methods.
# Outputs: Prints the dictionary created by each method to the console.
# Date: Oct 2024

"""
This script demonstrates two methods for creating a dictionary that maps taxonomic
orders to sets of species: a regular for-loop approach and a list comprehension approach.
The resulting dictionaries are printed to the console in a standard format.
"""

# Input list of taxa with species and their respective orders
taxa = [
    ('Myotis lucifugus', 'Chiroptera'),
    ('Gerbillus henleyi', 'Rodentia'),
    ('Peromyscus crinitus', 'Rodentia'),
    ('Mus domesticus', 'Rodentia'),
    ('Cleithrionomys rutilus', 'Rodentia'),
    ('Microgale dobsoni', 'Afrosoricida'),
    ('Microgale talazaci', 'Afrosoricida'),
    ('Lyacon pictus', 'Carnivora'),
    ('Arctocephalus gazella', 'Carnivora'),
    ('Canis lupus', 'Carnivora'),
]

# (1) Create taxa_dic using a regular for-loop
taxa_dic = {}
for species, order in taxa:
    if order not in taxa_dic:
        taxa_dic[order] = set()  # Initialize an empty set if order is not already in the dictionary
    taxa_dic[order].add(species)

# Print the dictionary created using the regular method
print("Output using regular method:")
for order, species_set in taxa_dic.items():
    print(f"'{order}': {species_set}")

# (2) Create taxa_dic_comp using a list comprehension
taxa_dic_comp = {}
[taxa_dic_comp.setdefault(order, set()).add(species) for species, order in taxa]

# Print the dictionary created using the list comprehension method
print("\nOutput using list comprehension:")
for order, species_set in taxa_dic_comp.items():
    print(f"'{order}': {species_set}")
