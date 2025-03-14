#!/bin/bash

###############################################################################
# run_MiniProject.sh
# Description:
#   A shell script to:
#     1) Execute R scripts for data prep, model fitting, and plotting.
#     2) Compile a LaTeX file (with references) into PDF.
#     3) Cleanup auxiliary files.
#
# Usage:
#   chmod +x run_MiniProject.sh
#   ./run_MiniProject.sh          # uses default Mini_Report.tex
#   OR ./run_MiniProject.sh file.tex  # to compile another .tex if desired
#
# Author: Kevin Zhao
# Date:   March 2025
###############################################################################

# Exit if any command fails
set -e

echo "=== (1) Running data preparation script ==="
Rscript Mini_data_prep.R

echo "=== (2) Running model fitting script ==="
Rscript Mini_model_fit.R

echo "=== (3) Generating plots ==="
Rscript Mini_plots.R

echo "=== (4) Compiling LaTeX document ==="

# Default .tex filename (without the suffix)
DEFAULT_TEX="Mini_Report"

# If user provided a filename, parse it; otherwise use default
suffix=".tex"
if [[ -z "$1" ]]; then
    # No argument given, use default
    filename="$DEFAULT_TEX"
else
    # Check if user included ".tex" suffix
    if [[ "$1" == *"$suffix"* ]]; then
        # strip off the ".tex" part
        filename=${1%"$suffix"}
    else
        filename=$1
    fi
fi

echo "Compiling LaTeX: $filename.tex"

# Compile step
pdflatex -shell-escape "$filename.tex"
bibtex "$filename"
pdflatex -shell-escape "$filename.tex"
pdflatex -shell-escape "$filename.tex"

# Optional: open PDF on Linux
if command -v evince &> /dev/null
then
    evince "$filename.pdf" &
else
    echo "evince not found. Skipping automatic PDF open."
fi

echo "=== Cleaning up auxiliary LaTeX files ==="
rm -f *.aux *.log *.bbl *.blg *.out *.toc *.synctex.gz *.nav *.snm
rm Miniproject-words.sum

echo "=== All steps completed successfully! ==="