#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: basic_csv.py
# Description: Reads a CSV file containing species data, prints species information, and writes a new CSV file with selected columns.
# Outputs: Prints species details and generates a new CSV file containing species name and body mass.
# Date: Oct 2024

"""
This script demonstrates reading data from a CSV file, processing the data,
and writing selected columns to a new CSV file. It also prints details of
each species to the console.
"""

import csv

# Read a file containing: 'Species','Infraorder','Family','Distribution','Body mass male (Kg)'
with open('documents/CMEECourseWork/week2/data/testcsv.csv', 'r') as f:
    csvread = csv.reader(f)
    temp = []
    for row in csvread:
        temp.append(tuple(row))
        print(row)
        print("The species is", row[0])

# Write a file containing only species name and body mass
with open('documents/CMEECourseWork/week2/data/testcsv.csv', 'r') as f:
    with open('documents/CMEECourseWork/week2/data/bodymass.csv', 'w') as g:
        csvread = csv.reader(f)
        csvwrite = csv.writer(g)
        for row in csvread:
            print(row)
            csvwrite.writerow([row[0], row[4]])

