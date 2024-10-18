#!/usr/bin/env python3

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 
latin_names = [bird[0] for bird in birds]
common_names = [bird[1] for bird in birds]
mean_masses = [bird[2] for bird in birds]

# Output the results
print("Latin names: ", latin_names)
print("Common names: ", common_names)
print("Mean body masses:", mean_masses)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

latin_names_loop = []
common_names_loop = []
mean_masses_loop = []

# Populate the lists using loops
for bird in birds:
    latin_names_loop.append(bird[0])
    common_names_loop.append(bird[1])
    mean_masses_loop.append(bird[2])

# Output the results
print("Latin names (using loops):", latin_names_loop)
print("Common names (using loops):", common_names_loop)
print("Mean body masses (using loops):", mean_masses_loop)

# My output:
# Latin names:  ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# Common names:  ['Savannah sparrow', 'House martin', 'Yellow-eyed junco', 'Dark-eyed junco', 'Tree swallow']
# Mean body masses: [18.7, 19, 19.5, 19.6, 20.2]
# Latin names (using loops): ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# Common names (using loops): ['Savannah sparrow', 'House martin', 'Yellow-eyed junco', 'Dark-eyed junco', 'Tree swallow']
# Mean body masses (using loops): [18.7, 19, 19.5, 19.6, 20.2]

# A nice example output is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.