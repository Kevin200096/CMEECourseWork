#!/usr/bin/env python3

"""Align two DNA sequences and find the best alignment score."""

# A function that computes a score by returning the number of matches starting
# from arbitrary startpoint (chosen by user)
def calculate_score(s1, s2, l1, l2, startpoint):
    matched = ""  # To hold string displaying alignments
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]:  # If the bases match
                matched = matched + "*"  # Matching base
                score += 1  # Increase score for matching bases
            else:
                matched = matched + "-"  # Non-matching base
    
    # Print alignment details for debugging
    print(f"Alignment starting at position {startpoint}:")
    print("." * startpoint + matched)
    print("." * startpoint + s2)
    print(s1)
    print(f"Score: {score}\n")
    
    return score

# Function to align two sequences and find the best alignment
def find_best_alignment(seq1, seq2):
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

# Function to save the best alignment and score to a file
def save_alignment_to_file(output_file, best_align, best_score, s1):
    with open(output_file, 'w') as file:
        file.write(f"Best alignment:\n{best_align}\n{s1}\n")
        file.write(f"Best score: {best_score}\n")

# Main function to tie everything together
def main():
    input_file = "sequences.csv"  # Input file containing the sequences
    output_file = "best_alignment.txt"  # Output file for the best alignment
    
    # Hardcoded DNA sequences for testing purposes
    seq1 = "ATCGCCGGATTACGGG"
    seq2 = "CAATTCGGAT"
    
    # Find the best alignment and score
    best_align, best_score, s1 = find_best_alignment(seq1, seq2)
    
    # Save the best alignment and score to a file
    save_alignment_to_file(output_file, best_align, best_score, s1)
    
    print(f"Best alignment saved to {output_file}")
    print(f"Best alignment:\n{best_align}\n{s1}")
    print(f"Best score: {best_score}")

# Standard boilerplate code to call the main() function when the script is executed
if __name__ == "__main__":
    main()
