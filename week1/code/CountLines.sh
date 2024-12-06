#!/bin/bash
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: CountLines.sh
# Description: Counts the number of lines in a file and checks for common errors
# Arguments: 1 -> InputFile (the file to count lines for)
# Date: Dec 2024

# Check if exactly one argument is provided
# - $# holds the number of arguments passed to the script.
if [ $# -ne 1 ]; then
    echo "Error: Incorrect usage." # Output error message if arguments are not exactly 1
    echo "Usage: $0 <InputFile>"  # Provide correct usage format
    exit 1                       # Exit with error code 1 (indicates failure)
fi

# Check if the input file exists and is a regular file
# - $1 refers to the first argument passed to the script (InputFile).
# - [ ! -f "$1" ] checks if the file does NOT exist or is not a regular file.
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist. Please check the file path and try again."
    exit 1 # Exit with error code 1
fi

# Count the number of lines in the file
# - wc -l counts the number of lines in the input.
# - $(...) captures the output of the command.
NumLines=$(wc -l < "$1") # Redirect input from file and store result in NumLines variable

# Output the result
# - Display the filename and the line count.
echo "The file '$1' has $NumLines lines."

# Indicate the script has successfully completed
echo "Done!" # Notify user of completion
exit 0       # Exit with code 0 (indicates success)
