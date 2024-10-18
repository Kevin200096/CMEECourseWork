import csv
import sys
from fuzzywuzzy import fuzz

# Define function
def is_an_oak(name):
    """
    Determines whether a given tree belongs to the Quercus genus (oak tree) using fuzzy matching.

    Args:
    name (str): The name of the tree to be checked, typically in the form 'Genus species'.

    Returns:
    bool: True if the genus name is sufficiently similar to 'Quercus', False otherwise.

    Example:
    >>> is_an_oak('Quercus robur')
    True
    >>> is_an_oak('quercus cerris')
    True
    >>> is_an_oak('Fraxinus excelsior')
    False
    >>> is_an_oak('Quercuss cerris')
    True  # "Quercuss" should be accepted as a fuzzy match
    >>> is_an_oak('Querqus robur')
    True  # "Querqus" should also be accepted
    """
    genus = name.strip().lower().split()[0]
    return fuzz.ratio(genus, 'quercus') >= 85  # Allow for some typos with a threshold of 85%

def main(argv): 
    """
    Main function to read tree data from a CSV file, filter out oaks, and write the results to another CSV file.

    Args:
    argv (list): List of command-line arguments (not used in this script).

    Side Effects:
    Writes oak tree data to the file 'JustOaksData.csv'.
    """
    # Open input and output files
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

    # Close input and output files
    f.close()
    g.close()
    
    return 0

if __name__ == "__main__":
    """
    Entry point of the script. Runs the main function and executes doctests.

    Side Effects:
    Runs doctests and exits the program with the appropriate status code.
    """
    import doctest
    doctest.testmod()  # Run doctests
    status = main(sys.argv)