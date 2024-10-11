#!/bin/sh
# Author: zh1323@ic.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2023

if [ $# -ne 1 ]; then
#when the input files are not 1, the message comes out using echo
    echo "Error. Format: $0 <InputFile1>"
    exit
fi

if [ ! -f "$1" ]; then
#test if the files exist
    echo "Input file does not exist"
    exit
fi

echo "creating a comma delimited version of $1 ..."
cat $1 | tr -s "\t" "," >> "../results/$(basename "$1").csv"
echo "Done!"
exit