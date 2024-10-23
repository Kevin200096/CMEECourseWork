#!/usr/bin/env python3

"""
Use functions to find the longest matching sequence in two files of DNA sequences and save the result as a pickle file
"""
__author__ = 'Kevin Zhao (kz1724@ic.ac.uk)'
__version__ = '0.2.0'

import sys
import pickle
import os


def read_file(file_name):
    """Reads a fasta file and returns the sequence and the sequence name"""
    try:
        with open(file_name) as f:
            seq_name = f.readline().strip()  # Get the sequence name
            sequence = f.read().strip().replace("\n", "")  # Get the sequence data
    except FileNotFoundError:
        print(f"Error: The file {file_name} does not exist.")
        sys.exit(1)

    return seq_name, sequence


def calculate_score_and_alignment(s1, s2, l1, l2, startpoint):
    """Calculate the alignment score and returns the alignment details"""
    matched = ""  # To hold string displaying matches and mismatches
    alignment_s1 = "." * startpoint + s2  # Align s2 starting at the given point
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]:  # If the bases match
                matched += "*"
                score += 1
            else:
                matched += "-"
    return score, alignment_s1, matched


def compare_seq_score(s1, s2, l1, l2):
    """Find the best alignment and return its score and the alignment"""
    best_align = None
    best_score = -1
    best_match = None
    for i in range(l1):  # Iterate over all possible starting points
        current_score, alignment_s1, matched = calculate_score_and_alignment(s1, s2, l1, l2, i)
        if current_score > best_score:
            best_align = alignment_s1
            best_score = current_score
            best_match = matched
    return best_score, best_align, best_match


def format_alignment(s1, s2, match_line, line_length=80):
    """Format the alignment output for better readability"""
    output = ""
    for i in range(0, len(s1), line_length):
        output += s1[i:i+line_length] + "\n"
        output += match_line[i:i+line_length] + "\n"
        output += s2[i:i+line_length] + "\n\n"
    return output


def save_results(seq_name1, seq_name2, best_score, best_align, match_line, original_s1, line_length=80):
    """Save the best alignment and score as a pickle file and formatted text"""
    output_dir = "../results"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Save the result as a pickle file
    output_file_pickle = os.path.join(output_dir, "align_seqs_fasta.pkl")
    with open(output_file_pickle, "wb") as f:
        pickle.dump({'best_score': best_score, 'best_alignment': best_align}, f)
    print(f"Pickle file saved to {output_file_pickle}")

    # Format the result for text output
    formatted_alignment = format_alignment(original_s1, best_align, match_line, line_length)
    output_file_txt = os.path.join(output_dir, "align_seqs_fasta.txt")
    with open(output_file_txt, "w") as f:
        f.write(f"Alignment between {seq_name1} and {seq_name2}\n\n")
        f.write(f"Best alignment score: {best_score}\n\n")
        f.write(formatted_alignment)
    print(f"Text file saved to {output_file_txt}")


def main(file1, file2):
    """Main function to read files, compute best alignment, and save the result"""
    seq_name1, seq1 = read_file(file1)
    seq_name2, seq2 = read_file(file2)
    l1, l2 = len(seq1), len(seq2)

    # Ensure s1 is the longer sequence
    if l2 > l1:
        seq1, seq2 = seq2, seq1
        l1, l2 = l2, l1
        seq_name1, seq_name2 = seq_name2, seq_name1

    best_score, best_align, match_line = compare_seq_score(seq1, seq2, l1, l2)
    save_results(seq_name1, seq_name2, best_score, best_align, match_line, seq1)


if __name__ == "__main__":
    if len(sys.argv) == 3:
        main(sys.argv[1], sys.argv[2])
    elif len(sys.argv) == 2:
        print("Warning: Only one input file provided, using default second file.")
        main(sys.argv[1], "../data/fasta/407228326.fasta")
    elif len(sys.argv) == 1:
        print("No input provided, using default files.")
        main("../data/fasta/407228412.fasta", "../data/fasta/407228326.fasta")
    else:
        print("Error: Incorrect input format. Provide 0, 1, or 2 fasta files.")
        sys.exit(1)
