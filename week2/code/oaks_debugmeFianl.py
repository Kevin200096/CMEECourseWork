import csv
import sys
from fuzzywuzzy import fuzz

# Define function
def is_an_oak(name):
    """
    Returns True if the genus name is close enough to 'Quercus' using fuzzy matching.

    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('quercus cerris')
    True
    >>> is_an_oak('Fraxinus excelsior')
    False
    >>> is_an_oak('Quercuss cerris')
    True
    >>> is_an_oak('Querqus robur')
    True
    """
    genus = name.strip().lower().split()[0]
    return fuzz.ratio(genus, 'quercus') >= 85  # Lower threshold to 85% to match more errors

def main(argv): 
    # Open files
    f = open('../data/TestOaksData.csv','r')
    g = open('../data/JustOaksData.csv','w')
    
    # Read and write CSV data
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)

    # Iterate through each row in the CSV file
    for row in taxa:
        print(row)
        print("The genus is: ") 
        print(row[0] + '\n')
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n')
            csvwrite.writerow([row[0], row[1]])

    # Close files
    f.close()
    g.close()
    
    return 0

if __name__ == "__main__":
    import doctest
    doctest.testmod()  # Run doctests
    status = main(sys.argv)