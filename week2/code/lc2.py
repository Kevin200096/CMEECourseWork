#!/usr/bin/env python3

# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
rain_above_100 = [(month, rain) for month, rain in rainfall if rain > 100]
print("Months and rainfall values when the amount of rain was greater than 100mm:")
print(rain_above_100)

# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 
rain_below_50 = [month for month, rain in rainfall if rain < 50]
print("\nMonths with rainfall less than 50mm:")
print(rain_below_50)

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 
# Conventional loop for (1) (rainfall > 100 mm)
rain_above_100_loop = []
for month, rain in rainfall:
    if rain > 100:
        rain_above_100_loop.append((month, rain))
print("\nMonths and rainfall > 100 mm (using loops):", rain_above_100_loop)

# Conventional loop for (2) (rainfall < 50 mm)
rain_below_50_loop = []
for month, rain in rainfall:
    if rain < 50:
        rain_below_50_loop.append(month)
print("Months with rainfall < 50 mm (using loops):", rain_below_50_loop)

# My output:
#
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
#
# Months with rainfall less than 50mm:
# ['MAR', 'SEP']
#
# Months and rainfall > 100 mm (using loops): [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# Months with rainfall < 50 mm (using loops): ['MAR', 'SEP']

# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.