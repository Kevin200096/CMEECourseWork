#!/usr/bin/env Rscript
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: control_flow.R
# Description: Demonstrates control flow structures in R, including if-else statements, for loops, and while loops.
# Outputs: Prints results of control flow operations to the console.
# Date: Oct 2024

a <- TRUE
if (a == TRUE) {
    print ("a is TRUE")
} else {
    print ("a is FALSE")
}

z <- runif(1) ## Generate a uniformly distributed random number
if (z <= 0.5) {print ("Less than a half")}

for (i in 1:10) {
    j <- i * i
    print(paste(i, " squared is", j ))
}

1:10

for(species in c('Heliodoxa rubinoides', 
                 'Boissonneaua jardini', 
                 'Sula nebouxii')) {
      print(paste('The species is', species))
}

v1 <- c("a","bc","def")
for (i in v1) {
    print(i)
}

i <- 0
while (i < 10) {
    i <- i+1
    print(i^2)
}