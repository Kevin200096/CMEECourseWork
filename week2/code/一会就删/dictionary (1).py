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
# 
# An example output is:
#  
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc. 
# OR, 
# 'Chiroptera': {'Myotis  lucifugus'} ... etc

#### Your solution here #### 

taxa_dict = {}
# Initialize an empty dictionary 
for bird in taxa:
    if bird[1] not in taxa_dict:
    # Populate the dictionary by iterating through the 'taxa' list.
        taxa_dict[bird[1]] = set()
        # Create an empty set for the order names
    taxa_dict[bird[1]].add(bird[0])
    #Add the species to the set
print(taxa_dict)

Taxa_dict = {Order_names: set(bird[0] for bird in taxa if bird[1] == Order_names) for species, Order_names in taxa }
#creating a dictionary using comprehension
print(Taxa_dict)



