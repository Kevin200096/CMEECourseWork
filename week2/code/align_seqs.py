#!/usr/bin/env python3
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: align_seqs.py
# Description: Aligns two DNA sequences to find the best alignment and calculates the alignment score.
# Outputs: Best alignment, alignment score, and an output file with results.
# Date: Oct 2024

"""
This script aligns two DNA sequences to find the best alignment based on a scoring method
and outputs the results to a file. It demonstrates the use of string manipulation and
file I/O in Python.
"""

import os
import sys

def calculate_score(s1, s2, l1, l2, startpoint):
    """
    Calculate the alignment score by comparing two sequences starting from a specific position.

    Args:
        s1 (str): The longer DNA sequence.
        s2 (str): The shorter DNA sequence.
        l1 (int): Length of the longer sequence.
        l2 (int): Length of the shorter sequence.
        startpoint (int): The starting index in the longer sequence for alignment.

    Returns:
        int: The number of matching bases.
    """
    matched = ""  # To hold string displaying alignments
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]:  # If the bases match
                matched += "*"  # Matching base
                score += 1  # Increase score for matching bases
            else:
                matched += "-"  # Non-matching base

    # Print alignment details for debugging
    print(f"Alignment starting at position {startpoint}:")
    print("." * startpoint + matched)
    print("." * startpoint + s2)
    print(s1)
    print(f"Score: {score}\n")

    return score

def find_best_alignment(seq1, seq2):
    """
    Find the best alignment between two DNA sequences.

    Args:
        seq1 (str): First DNA sequence.
        seq2 (str): Second DNA sequence.

    Returns:
        tuple: Best alignment string, best score, and the longer sequence.
    """
    l1, l2 = len(seq1), len(seq2)
    if l1 >= l2:
        s1, s2 = seq1, seq2
    else:
        s1, s2 = seq2, seq1
        l1, l2 = l2, l1  # Swap the two lengths

    best_align = None
    best_score = -1

    # Iterate through all possible starting points and find the best score
    for i in range(l1):
        score = calculate_score(s1, s2, l1, l2, i)
        if score > best_score:
            best_align = "." * i + s2  # Track the alignment
            best_score = score  # Track the best score

    return best_align, best_score, s1

def save_alignment_to_file(output_file, best_align, best_score, s1):
    """
    Save the best alignment and its score to a file.

    Args:
        output_file (str): Path to the output file.
        best_align (str): Best alignment string.
        best_score (int): Best score.
        s1 (str): The longer DNA sequence.
    """
    with open(output_file, 'w') as file:
        file.write(f"Best alignment:\n{best_align}\n{s1}\n")
        file.write(f"Best score: {best_score}\n")

def read_sequences_from_file(file_path):
    """
    Read two DNA sequences from a file.

    Args:
        file_path (str): Path to the input file.

    Returns:
        tuple: Two DNA sequences.
    """
    with open(file_path, 'r') as file:
        sequences = file.read().splitlines()  # Read all lines as sequences
    if len(sequences) < 2:
        raise ValueError("The input file must contain at least two sequences.")
    return sequences[0], sequences[1]

def main():
    """
    Main function to perform sequence alignment.
    """
    # Define the file paths
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_dir = os.path.join(current_dir, "..", "data")  # Relative path to data folder
    results_dir = os.path.join(current_dir, "..", "results")  # Relative path to results folder

    input_file = os.path.join(data_dir, "sequences.csv")  # Input file path
    output_file = os.path.join(results_dir, "best_alignment.txt")  # Output file path

    # Read sequences from the input file
    try:
        seq1, seq2 = read_sequences_from_file(input_file)
    except Exception as e:
        print(f"Error reading sequences: {e}")  # Print error message and exit if there's an issue reading the file
        sys.exit(1)

    # Find the best alignment and score
    best_align, best_score, s1 = find_best_alignment(seq1, seq2)

    # Save the best alignment and score to a file
    try:
        save_alignment_to_file(output_file, best_align, best_score, s1)
    except Exception as e:
        print(f"Error saving alignment: {e}")  # Print error message and exit if there's an issue writing the file
        sys.exit(1)

    # Output the best alignment and score to the console for the user
    print(f"Best alignment saved to {output_file}")
    print(f"Best alignment:\n{best_align}\n{s1}")
    print(f"Best score: {best_score}")

if __name__ == "__main__":
    main()
