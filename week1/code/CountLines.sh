#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then # $# represents the number of arguments passed to the script
    echo "Error: Incorrect usage."
    echo "Usage: $0 <InputFile>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then # $1 refers to the first argument (the file)
    echo "Error: Input file '$1' does not exist."
    exit 1
fi

# Count the number of lines in the file
NumLines=$(wc -l < "$1")

# Output the result and indicate completion
echo "The file $1 has $NumLines lines."
echo "Done!"
exit 0 # Indicate the script completed successfully