#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: oaks_debugme.py
# Description: Processes a CSV file to filter rows where the genus name matches 'Quercus' (oak trees).
# Outputs: Writes matching rows to a new CSV file and prints debug information to the console.
# Date: Oct 2024

"""
This script filters oak tree species (genus 'Quercus') from a CSV file using fuzzy string matching.
It writes the filtered results to another CSV file and prints debug information to the console.
"""

import csv  # To handle CSV file reading and writing
import sys  # To handle command-line arguments
from fuzzywuzzy import fuzz  # For fuzzy string matching

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
    genus = name.strip().lower().split()[0]  # Extract and normalize genus
    return fuzz.ratio(genus, 'quercus') >= 85  # Threshold for fuzzy matching

def main(argv):
    """
    Processes a CSV file to filter rows where the genus name is identified as 'Quercus'.
    Writes the filtered data to another CSV file.

    Args:
        argv (list): Command-line arguments (not used in this case).

    Returns:
        int: Status code (0 for success).

    Raises:
        IOError: If the input or output file cannot be opened.
    """
    # Define file paths
    input_file = '../data/TestOaksData.csv'
    output_file = '../data/JustOaksData.csv'

    try:
        # Open files
        with open(input_file, 'r') as f, open(output_file, 'w', newline='') as g:
            taxa = csv.reader(f)  # Read rows from the input CSV
            csvwrite = csv.writer(g)  # Prepare to write rows to the output CSV

            # Iterate through each row in the CSV file
            for row in taxa:
                print(row)
                print("The genus is:")
                print(row[0] + '\n')
                # Check if the genus is identified as an oak
                if is_an_oak(row[0]):
                    print('FOUND AN OAK!\n')  # Notify that an oak has been found
                    csvwrite.writerow([row[0], row[1]])  # Write genus and species to the output file

    except IOError as e:
        print(f"Error opening file: {e}")
        return 1  # Return error code 1 for failure

    return 0  # Return 0 to indicate successful completion

if __name__ == "__main__":
    import doctest
    doctest.testmod()  # Run doctests
    status = main(sys.argv)  # Call the main function and pass command-line arguments
    sys.exit(status)
