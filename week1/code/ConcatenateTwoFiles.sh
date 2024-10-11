#!/bin/bash

# Check if exactly three arguments are provided
if [ $# -ne 3 ]; then # $# represents the number of arguments passed to the script
    echo "Error. Format: $0 <InputFile1> <InputFile2> <OutputFile>"
    exit 1
fi

# Check if the input files exist
for file in "$1" "$2"; do
    if [ ! -f "$file" ]; then
        echo "Error: Input file '$file' does not exist."
        exit 1
    fi
done

# Debug: Display the content of both input files
#echo "File 1 content:"
#cat "$1"
#echo "File 2 content:"
#cat "$2"
#Run above content with scrpt if error disply during two input files and one output file progress

# Concatenate the two input files into the output file
cat "$1" > "$3"
cat "$2" >> "$3"

# Output the merged file content
echo "Merged File is:"
cat "$3"
echo "Done!"
exit 0 # Indicate the script completed successfully