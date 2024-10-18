# source /Users/kevin/myenv/bin/activate
# Its a command used to activate a virtual environment. 
# Its function is to enter a created Python virtual environment and use isolated Python packages and dependencies in that environment.
# deactivate
# Exit the virtual environment with this command.

#!/usr/bin/env python3

import csv # To handle CSV file reading and writing
import sys # To handle command-line arguments
from fuzzywuzzy import fuzz # For fuzzy string matching

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
    # Use fuzzy matching to determine if genus is close to "quercus"
    genus = name.strip().lower().split()[0]  # Strip any extra whitespace and convert to lowercase, then split to extract the genus
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
    # Print error message and exit if there's an issue opening the file
        print(f"Error opening file: {e}")
        return 1 # Return error code 1 to indicate failure

    # Read and write CSV data
    taxa = csv.reader(f) # Read the rows from the input CSV
    csvwrite = csv.writer(g) # Prepare to write rows to the output CSV

    # Iterate through each row in the CSV file
    for row in taxa:
        print(row)
        print("The genus is:")
        print(row[0] + '\n')
        # Check if the genus is identified as an oak using the is_an_oak function
        if is_an_oak(row[0]):
            print('FOUND AN OAK!\n') # Notify that an oak has been found
            csvwrite.writerow([row[0], row[1]]) # Write the genus and species to the output file

    # Close files
    f.close()
    g.close()

    return 0 # Return 0 to indicate successful completion

if __name__ == "__main__":
    import doctest
    doctest.testmod()  # Run doctests
    status = main(sys.argv) # Call the main function and pass command-line arguments