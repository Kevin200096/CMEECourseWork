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

rainfall_greater_100 = [month for month in rainfall if month[1] > 100]
print("Months and rainfall values when the amount of rain was greater than 100mm:", rainfall_greater_100)
# Use list comprehension to create a list of month-rainfall tuples when the amount of rain was greater than 100mm.
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

rainfall_less_50 = [month for month in rainfall if month[1] < 50]
print("Months and rainfall values when the amount of rain was less than 50mm:", rainfall_less_50)
# Use list comprehension to create a list of month-rainfall tuples when the amount of rain was less than 50mm.

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

Rainfall_greater_100 = []
# Initialize an empty list to store the tuples
for month in rainfall:
    if month[1] > 100:
        Rainfall_greater_100.append(month)
        # Iterate through the 'rainfall' tuple and add tuples to the result list
print("Months and rainfall values when the amount of rain was greater than 100mm:", Rainfall_greater_100)

Rainfall_less_50 = []
# Initialize an empty list to store the tuples
for month in rainfall:
    if month[1] < 50:
        Rainfall_less_50.append(month)
        # Iterate through the 'rainfall' tuple and add tuples to the result list
print("Months and rainfall values when the amount of rain was less than 50mm:", Rainfall_less_50)


# A good example output is:
#
# Step #1:
# Months and rainfall values when the amount of rain was greater than 100mm:
# [('JAN', 111.4), ('FEB', 126.1), ('AUG', 140.2), ('NOV', 128.4), ('DEC', 142.2)]
# ... etc.

