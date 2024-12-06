#!/bin/bash
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: tiff2png.sh
# Description: Converts all .tif files in the current directory to .png format using ImageMagick's convert command
# Arguments: none (the script operates on all .tif files in the current directory)
# Date: Dec 2024

# Check if ImageMagick (convert) is installed
# - The `command -v` checks if the `convert` command is available in the system's PATH
# - If not found, the script exits with an error message
if ! command -v convert &> /dev/null; then
    echo "Error: ImageMagick (convert) is not installed. Please install it to use this script."
    exit 1 # Exit with status code 1 (indicates failure)
fi

# Check if there are any .tif files in the directory
# - `ls *.tif` lists all .tif files in the current directory
# - Redirecting both stdout and stderr to `/dev/null` prevents unwanted output if no files are found
if ! ls *.tif 1> /dev/null 2>&1; then
    echo "No .tif files found in the current directory." # Inform the user there are no files to process
    exit 0 # Exit with status code 0 (indicates success, but no files were processed)
fi

# Convert each .tif file to .png
# - Loop through all .tif files in the current directory
# - For each file, generate a corresponding .png output
for f in *.tif; do
    echo "Converting $f..." # Inform the user of the current file being processed
    
    # Prepare the output file name
    # - `basename "$f" .tif` removes the .tif extension from the file name
    # - Add the .png extension to create the output file name
    output_file="$(basename "$f" .tif).png"
    
    # Use ImageMagick's convert command to perform the conversion
    # - If the conversion succeeds, inform the user
    # - If it fails, print an error message and skip to the next file
    if convert "$f" "$output_file"; then
        echo "Successfully converted $f to $output_file."
    else
        echo "Error: Failed to convert $f. Skipping..."
    fi
done

# Inform the user that all conversions are complete
echo "All conversions completed."
