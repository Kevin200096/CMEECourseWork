#!/usr/bin/env Rscript
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: R_conditionals.R
# Description: Contains three functions to check whether a number is even, a power of 2, or a prime.
# Outputs: Messages indicating the properties of the given numbers.
# Date: Oct 2024

# Checks if an integer is even
is.even <- function(n = 2) {
  if (n %% 2 == 0) {
    return(paste(n,'is even!'))
  } else {
  return(paste(n,'is odd!'))
  }
}

is.even(6)

# Checks if a number is a power of 2
is.power2 <- function(n = 2) {
  if (log2(n) %% 1==0) {
    return(paste(n, 'is a power of 2!'))
  } else {
  return(paste(n,'is not a power of 2!'))
    }
}

is.power2(4)

# Checks if a number is prime
is.prime <- function(n) {
  if (n==0) {
    return(paste(n,'is a zero!'))
  } else if (n==1) {
    return(paste(n,'is just a unit!'))
  }
    
  ints <- 2:(n-1)
  
  if (all(n%%ints!=0)) {
    return(paste(n,'is a prime!'))
  } else {
  return(paste(n,'is a composite!'))
    }
}

is.prime(3)