#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: lc2.py
# Description: Demonstrates the use of list comprehensions and loops to filter and extract rainfall data.
# Outputs: Prints the results of filtering rainfall data above 100 mm and below 50 mm using both methods.
# Date: Oct 2024

"""
This script demonstrates two methods (list comprehensions and loops) for filtering and
extracting rainfall data. It identifies months with rainfall above 100 mm and below 50 mm,
and prints the results.
"""

# Average UK Rainfall (mm) for 1910 by month
# Source: http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (
    ('JAN', 111.4),
    ('FEB', 126.1),
    ('MAR', 49.9),
    ('APR', 95.3),
    ('MAY', 71.8),
    ('JUN', 70.2),
    ('JUL', 97.1),
    ('AUG', 140.2),
    ('SEP', 27.0),
    ('OCT', 89.4),
    ('NOV', 128.4),
    ('DEC', 142.2),
)

# (1) Filter months with rainfall > 100 mm using list comprehension
rain_above_100 = [(month, rain) for month, rain in rainfall if rain > 100]
print("Months and rainfall values when the amount of rain was greater than 100mm:")
print(rain_above_100)

# (2) Filter months with rainfall < 50 mm using list comprehension
rain_below_50 = [month for month, rain in rainfall if rain < 50]
print("\nMonths with rainfall less than 50mm:")
print(rain_below_50)

# (3) Filter months with rainfall > 100 mm using a conventional loop
rain_above_100_loop = []
for month, rain in rainfall:
    if rain > 100:
        rain_above_100_loop.append((month, rain))
print("\nMonths and rainfall > 100 mm (using loops):", rain_above_100_loop)

# Filter months with rainfall < 50 mm using a conventional loop
rain_below_50_loop = []
for month, rain in rainfall:
    if rain < 50:
        rain_below_50_loop.append(month)
print("Months with rainfall < 50 mm (using loops):", rain_below_50_loop)
