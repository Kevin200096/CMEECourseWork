# Author: Kevin Zhao kz1724@ic.ac.uk
# Script: boilerplate.sh
# Desc: simple boilerplate for shell scripts
# Arguments: none
# Date: Oct 2024

The code files contains both "UNIX and Linux" and "Shell scripting" Practicals included codes

1. UNIX and Linux
FASTA exercise:
Count how many lines there are in each file
Print everything starting from the second line for the E. coli genome
Count the sequence length of this genome
Count the matches of a particular sequence, “ATGC” in the genome of E. coli (hint: Start by removing the first line and removing newline characters)
Compute the AT/GC ratio. That is, the (A+T)/(G+C) ratio (as a single number). This is a summary measure of base composition of double-stranded DNA. DNA from different organisms and lineages has different ratios of the A-to-T and G-to-C base pairs (google “Chargaff’s rule”). For example, DNA from organisms that live in hot springs have a higher GC content, the GC base pair is more thermally stable.

In order to achieve the above 5 goals, the solutions included in the UnixPrac1.txt with further detail instrction in commend. The UnixPrac1.txt is the only file for UNIX and Linux project which saved in code documents.

2. Shell scripting
Improving scripts:
The goal of this exercise is to make each such script robust so that it gives feedback to the user and exits if the right inputs are not provided.
ConcatenateTwoFiles.sh, tabtocsv.sh and CountLines.sh have been imfroved for this task.

A new shell script:
I have write a csvtospace.sh shell script that takes a comma separated values and converts it to a space separated values file. 

Other script:
Rest of the document have been required to save in code documents via https://themulquabio.github.io/TMQB/notebooks/02-ShellScripting.html.