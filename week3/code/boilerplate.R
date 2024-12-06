#!/usr/bin/env Rscript
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: Boilerplate.R
# Description: Demonstrates the structure of a simple R script and a function definition.
# Outputs: Prints the types and values of the arguments passed to the function.
# Date: Oct 2024

MyFunction <- function(Arg1, Arg2) {
  
  # Statements involving Arg1, Arg2:
  print(paste("Argument", as.character(Arg1), "is a", class(Arg1))) # print Arg1's type
  print(paste("Argument", as.character(Arg2), "is a", class(Arg2))) # print Arg2's type
    
  return (c(Arg1, Arg2)) #this is optional, but very useful
}

MyFunction(1,2) #test the function
MyFunction("Riki","Tiki") #A different test