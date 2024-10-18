import csv
import sys
from fuzzywuzzy import fuzz

def is_an_oak(name):
    """
    Determines if the genus name in the input string closely matches 'Quercus' using fuzzy matching.

    Args:
        name (str): The scientific name of a plant species (genus and species).

    Returns:
        bool: True if the genus part of the name is close enough to 'Quercus', otherwise False.

    Examples:
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
    """
    Processes a CSV file to filter out rows where the genus name is identified as 'Quercus'
    (i.e., an oak tree). Writes the filtered data to another CSV file.

    Args:
        argv (list): Command-line arguments (not used in this case).

    Returns:
        int: Status code (0 for success).

    Behavior:
        - Reads data from '../data/TestOaksData.csv'
        - Writes rows with oak trees (genus close to 'Quercus') to '../data/JustOaksData.csv'

    Raises:
        IOError: If the input or output file cannot be opened.
    """
    # Open files
    try:
        f = open('../data/TestOaksData.csv', 'r')
        g = open('../data/JustOaksData.csv', 'w')
    except IOError as e:
        print(f"Error opening file: {e}")
        return 1

    # Read and write CSV data
    taxa = csv.reader(f)
    csvwrite = csv.writer(g)

    # Iterate through each row in the CSV file
    for row in taxa:
        print(row)
        print("The genus is:")
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
