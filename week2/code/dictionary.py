#!/usr/bin/env python3

taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a python script to populate a dictionary called taxa_dic derived from
# taxa so that it maps order names to sets of taxa and prints it to screen.
# (1) Create taxa_dic mapping orders to sets of species using regular method
taxa_dic = {}
for species, order in taxa:
    if order not in taxa_dic:
        taxa_dic[order] = set()  # Initialize an empty set if order is not already in the dictionary
    taxa_dic[order].add(species)

# Print the dictionary in standard collection format
print("Output using regular method:")
for order, species_set in taxa_dic.items():
    print(f"'{order}': {species_set}")

# Now write a list comprehension that does the same (including the printing after the dictionary has been created)  
# (2) Using list comprehension to achieve the same result
taxa_dic_comp = {}
[taxa_dic_comp.setdefault(order, set()).add(species) for species, order in taxa]

# Print the dictionary in standard collection format using list comprehension
print("\nOutput using list comprehension:")
for order, species_set in taxa_dic_comp.items():
    print(f"'{order}': {species_set}")

# My output:
# Output using regular method:
# 'Chiroptera': {'Myotis lucifugus'}
# 'Rodentia': {'Peromyscus crinitus', 'Cleithrionomys rutilus', 'Gerbillus henleyi', 'Mus domesticus'}
# 'Afrosoricida': {'Microgale dobsoni', 'Microgale talazaci'}
# 'Carnivora': {'Arctocephalus gazella', 'Canis lupus', 'Lyacon pictus'}

# Output using list comprehension:
# 'Chiroptera': {'Myotis lucifugus'}
# 'Rodentia': {'Peromyscus crinitus', 'Cleithrionomys rutilus', 'Gerbillus henleyi', 'Mus domesticus'}
# 'Afrosoricida': {'Microgale dobsoni', 'Microgale talazaci'}
# 'Carnivora': {'Arctocephalus gazella', 'Canis lupus', 'Lyacon pictus'}

# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc