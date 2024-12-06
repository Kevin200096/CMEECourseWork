#!/bin/sh
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: tabtocsv.sh
# Description: Converts a tab-delimited file into a CSV format by replacing tabs with commas.
# Saves the output in the ../results/ directory with a .csv extension.
# Arguments: 
#   1 -> InputFile: The tab-delimited file to be converted
# Date: Oct 2024

# Check if exactly one argument is provided
# - $# represents the number of arguments passed to the script.
# - The script requires exactly one argument: the path to the input file.
if [ $# -ne 1 ]; then
    echo "Error: Incorrect usage." # Inform the user of incorrect usage
    echo "Usage: $0 <InputFile>"  # Provide the correct usage format
    echo "Please provide the path to a tab-delimited file as the argument."
    exit 1 # Exit with status code 1 (indicates failure)
fi

# Check if the input file exists and is a regular file
# - $1 represents the first argument passed to the script (input file).
# - [ ! -f "$1" ] checks if the file does NOT exist or is not a regular file.
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist." # Inform the user the file is missing
    echo "Please check the file path and ensure the file exists before running the script."
    exit 1 # Exit with status code 1
fi

# Ensure the ../results directory exists
# - [ ! -d "../results" ] checks if the directory does NOT exist.
# - mkdir -p creates the directory if it doesn't exist (the -p flag avoids errors if it already exists).
if [ ! -d "../results" ]; then
    mkdir -p "../results"
fi

# Prepare the output file path
# - basename "$1" extracts the filename from the full file path (removes directory components).
# - The second argument to basename (".txt") removes the .txt extension from the filename.
# - The resulting file will be saved as ../results/<filename>.csv
output_file="../results/$(basename "$1" .txt).csv"

# Convert tabs to commas and save the output
# - tr -s "\t" "," replaces all tab characters ("\t") with commas (",").
# - < "$1" reads the input file.
# - > "$output_file" writes the transformed content to the output file.
echo "Creating a comma-delimited version of '$1'..."
tr -s "\t" "," < "$1" > "$output_file"

# Provide feedback to the user
# - Inform the user that the operation was successful and show the path of the output file.
echo "Done! The comma-delimited file is saved as '$output_file'."
exit 0 # Exit with status code 0 (indicates success)
