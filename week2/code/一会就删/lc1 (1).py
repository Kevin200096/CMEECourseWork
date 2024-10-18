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
print("Latin names: ", latin_names)

common_names = [bird[1] for bird in birds]
print("Common names", common_names)

mean_masses = [bird[2] for bird in birds]
print("Mean body masses:", mean_masses)

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

Latin_names = []
#Initialize empty list 
for bird in birds:
        Latin_names.append(bird[0])
        #Iterate through the 'birds' tuple
print("Latin names: ", Latin_names)

#Same for the below
Common_names = []
for bird in birds:
        Common_names.append(bird[0])
print("Common names", Common_names)

Mean_masses = []
for bird in birds:
        Mean_masses.append(bird[0])
print("Mean body masses:", Mean_masses)

# A nice example out out is:
# Step #1:
# Latin names:
# ['Passerculus sandwichensis', 'Delichon urbica', 'Junco phaeonotus', 'Junco hyemalis', 'Tachycineata bicolor']
# ... etc.
 