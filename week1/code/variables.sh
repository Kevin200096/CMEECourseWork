#!/bin/sh
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: variables.sh
# Description: Demonstrates the use of variables and arithmetic operations in a shell script
# Arguments: None (all input is provided interactively by the user)
# Date: Dec 2024

# Demonstrating special variables
# - $# provides the number of arguments passed to the script
# - $0 gives the name of the script
# - $@ lists all the arguments passed to the script
# - $1 and $2 represent the first and second arguments respectively (if provided)
echo "This script was called with $# parameters"
echo "The script's name is $0"
echo "The arguments are: $@"
echo "The first argument is: $1"
echo "The second argument is: $2"

# Demonstrating explicitly assigned variables
# - MY_VAR is assigned the string 'some string'
# - The user is then prompted to provide a new value for MY_VAR
MY_VAR='some string' 
echo "The current value of the variable is: $MY_VAR"
echo "Please enter a new string:" # Prompt the user to enter a new value
read MY_VAR # Read user input and store it in MY_VAR
echo "The current value of the variable is: $MY_VAR"

# Reading multiple values from user input
# - Prompt the user to input two numbers, separated by spaces
echo "Enter two numbers separated by spaces:"
read a b # Read two inputs and store them in variables 'a' and 'b'

# Validating user input
# - Ensure both inputs are integers
# - The condition uses a combination of `[ "$a" -eq "$a" ]` and `2>/dev/null` to suppress errors if the input is not numeric
if ! [ "$a" -eq "$a" ] 2>/dev/null || ! [ "$b" -eq "$b" ] 2>/dev/null; then
    echo "Error: Both inputs must be valid integers." # Inform the user of invalid input
    exit 1 # Exit with status code 1 (indicates failure)
fi

# Display the inputs and their sum
# - $((...)) is used for arithmetic operations in a modern and efficient way
echo "You entered $a and $b; Their sum is:"
MY_SUM=$((a + b)) # Calculate the sum of 'a' and 'b'
echo $MY_SUM # Output the result
