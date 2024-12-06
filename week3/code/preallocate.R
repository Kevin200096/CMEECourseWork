#!/usr/bin/env Rscript
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: preallocate.R
# Description: Compares the performance of a function with and without preallocation of vectors in R.
# Outputs: Execution time and memory usage of both approaches.
# Date: Oct 2024

NoPreallocFun <- function(x) {
    a <- vector() # empty vector
    for (i in 1:x) {
        a <- c(a, i) # concatenate
        print(a)
        print(object.size(a))
    }
}

system.time(NoPreallocFun(10))

PreallocFun <- function(x) {
    a <- rep(NA, x) # pre-allocated vector
    for (i in 1:x) {
        a[i] <- i # assign
        print(a)
        print(object.size(a))
    }
}

system.time(PreallocFun(10))