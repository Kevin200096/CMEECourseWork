#!/bin/bash

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then # $# represents the number of arguments passed to the script
    echo "Error: Please provide the input filename."
    echo "Usage: $0 <InputCSVFile>"
    exit 1
fi

input_file="$1"

# Check if the input file exists and is readable
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' does not exist."
    exit 1
fi

if [ ! -r "$input_file" ]; then
    echo "Error: Input file '$input_file' does not readable."
    exit 1
fi

# Define the output directory and create the output directory automaticlly when 0 output detected
output_dir="../results"
mkdir -p "$output_dir"

# To avoid creating a file with a path in the ../results directory, basename should be used to extract the file name as path information is included in the $1 file may be path issues
# Uses the basename function to get the input file’s base name and Names the output file
base_name=$(basename "$input_file" .csv)
output_file="$output_dir/${base_name}_result.csv"

# Convert CSV to space-separated values and handle any conversion errors
if ! tr ',' ' ' < "$input_file" > "$output_file"; then
    echo "Error: Failed to convert the file."
    exit 1
fi

# Output success message
echo "Successfully converted '$input_file' to '$output_file'"
exit 0
