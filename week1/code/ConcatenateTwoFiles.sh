#!/bin/bash
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Description: Concatenates two input files into a specified output file
# Arguments: 
#   1 -> InputFile1: First file to concatenate
#   2 -> InputFile2: Second file to concatenate
#   3 -> OutputFile: File to save the concatenated output
# Date: Oct 2024

# Check if exactly three arguments are provided
# - $# holds the number of arguments passed to the script
# - The script requires exactly three arguments: two input files and one output file
if [ $# -ne 3 ]; then
    echo "Error: Incorrect usage." # Inform the user of incorrect usage
    echo "Format: $0 <InputFile1> <InputFile2> <OutputFile>" # Provide correct usage format
    exit 1 # Exit with status code 1 (indicates failure)
fi

# Check if the input files exist
# - Loop through the first two arguments (input files)
# - [ ! -f "$file" ] checks if the file does NOT exist or is not a regular file
for file in "$1" "$2"; do
    if [ ! -f "$file" ]; then
        echo "Error: Input file '$file' does not exist." # Inform the user about the missing file
        exit 1 # Exit with status code 1
    fi
done

# Check if the output file already exists
# - [ -f "$3" ] checks if the output file exists
# - If it exists, the script exits to avoid overwriting the file
if [ -f "$3" ]; then
    echo "Error: Output file '$3' already exists. Please choose a different name." # Warn the user
    exit 1 # Exit with status code 1
fi

# Debug mode: Uncomment the lines below to display file contents before merging
# - Useful for verifying input file content during script development
# echo "File 1 content:"
# cat "$1"
# echo "File 2 content:"
# cat "$2"

# Concatenate the two input files into the output file
# - The first input file content is written to the output file using `>`
# - The second input file content is appended using `>>`
cat "$1" > "$3" # Write content of InputFile1 to OutputFile
cat "$2" >> "$3" # Append content of InputFile2 to OutputFile

# Provide feedback to the user
# - Inform the user that the files have been merged
echo "Files '$1' and '$2' have been merged into '$3'."

# Display the merged file content
# - Show the content of the newly created output file
echo "Merged file content:"
cat "$3"

# Display the size of the merged file
# - Use `stat -c%s` to get the size of the file in bytes
echo "The size of the merged file is $(stat -c%s "$3") bytes."

# Indicate the script has successfully completed
echo "Done!" # Notify the user of successful completion
exit 0 # Exit with status code 0 (indicates success)
