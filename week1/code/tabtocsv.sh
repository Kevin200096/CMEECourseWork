#!/bin/sh
# Author: Kevin Zhao kz1724@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2024

# Check if exactly one argument is provided
if [ $# -ne 1 ]; then # $# represents the number of arguments passed to the script
    echo "Error: Incorrect usage."
    echo "Usage: $0 <InputFile>"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' does not exist."
    exit 1
fi

# Convert tabs to commas and append to a new result file
echo "creating a comma delimited version of $1 ..."
# To avoid creating a file with a path in the ../results directory, basename should be used to extract the file name as path information is included in the $1 file may be path issues
cat $1 | tr -s "\t" "," >> "../results/$(basename "$1").csv" 
echo "Done!"
exit 0 # Indicate the script completed successfully