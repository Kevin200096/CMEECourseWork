#!/usr/bin/env python3

birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
        )

# Birds is a tuple of tuples of length three: latin name, common name, mass.
# write a (short) script to print these on a separate line or output block by
# species 
# Loop through each tuple and print the formatted output
for bird in birds:
    latin_name, common_name, mass = bird
    print(f"Latin name: {latin_name} Common name: {common_name} Mass: {mass}")

# My output:
# Latin name: Passerculus sandwichensis Common name: Savannah sparrow Mass: 18.7
# Latin name: Delichon urbica Common name: House martin Mass: 19
# Latin name: Junco phaeonotus Common name: Yellow-eyed junco Mass: 19.5
# Latin name: Junco hyemalis Common name: Dark-eyed junco Mass: 19.6
# Latin name: Tachycineata bicolor Common name: Tree swallow Mass: 20.2

# A nice example output is:
# 
# Latin name: Passerculus sandwichensis Common name: Savannah sparrow Mass: 18.7
# ... etc.