# CMEE 2024 HPC Exercises

**Author:** Kevin Zhao (kz1724)  
**Email:** [zhetao.zhao24@imperial.ac.uk](mailto:zhetao.zhao24@imperial.ac.uk)  
**Date:** March 2025  

## Overview

This repository contains the submission for the CMEE 2024 HPC (High-Performance Computing) coursework. It includes R scripts for deterministic and stochastic demographic simulations, as well as individual-based neutral theory simulations, both run locally and on the Imperial HPC cluster. The project also implements the various challenge questions (A–E) and outputs `.rda` result files and `.png` plots.

## Contents and File Structure

A rough sketch of the directory layout is as follows:

. ├── demographic_outputs/ │ ├── run_demographic_cluster.sh.o860425.1 │ ├── ... │ ├── demographic_cluster_output_1.rda │ ├── ... ├── neutral_outputs/ │ ├── run_neutral_cluster.sh.o860530.1 │ ├── ... │ ├── neutral_cluster_output_1.rda │ ├── ... ├── Demographic.R ├── kz1724_HPC_2024_demographic_cluster.R ├── kz1724_HPC_2024_neutral_cluster.R ├── kz1724_HPC_2024_main.R ├── run_demographic_cluster.sh ├── run_neutral_cluster.sh ├── challenge_A_data.rda ├── Challenge_A.png ├── Challenge_B.png ├── Challenge_C.png ├── Challenge_D.png ├── Challenge_E.png ├── Challenge_E_HPC.rda ├── processed_neutral_results.rda ├── question_1.png ├── question_2.png ├── question_5.png ├── question_6.png ├── question_14.png ├── question_18.png ├── question_22.png └── ...


### Key Files

- **Demographic.R**  
  Implements both deterministic and stochastic demographic population model functions (e.g. `deterministic_simulation()`, `stochastic_simulation()`, etc.).

- **kz1724_HPC_2024_main.R**  
  Main R script that contains:
  - Student details and user-defined settings.  
  - The “Question 1–6” and “Question 7–... Challenge” function definitions required by the assignment.  
  - Functions that read HPC `.rda` outputs, process them into final graphs/analyses (for example, `process_neutral_cluster_results()`, `plot_neutral_cluster_results()`, `question_5()`, etc.).

- **kz1724_HPC_2024_demographic_cluster.R**  
  HPC script that reads `PBS_ARRAY_INDEX` (job number) from the environment and runs the relevant demographic simulations in parallel array jobs.  
  Generates files named like `demographic_cluster_output_XX.rda`.

- **kz1724_HPC_2024_neutral_cluster.R**  
  HPC script that runs the neutral theory simulations for array jobs. Produces `neutral_cluster_output_XX.rda`.

- **run_demographic_cluster.sh** and **run_neutral_cluster.sh**  
  Bash scripts for HPC job submission. Each script:
  1. Loads an R module.  
  2. Copies relevant `.R` files to `$TMPDIR`.  
  3. Executes them with `Rscript`.  
  4. Moves generated `.rda` outputs back to the user directory (e.g., `demographic_outputs/` or `neutral_outputs/`).

- **Challenge_X.png / question_X.png**  
  Various output plots for both the main assignment questions (Q1, Q2, Q5, etc.) and the challenge questions (A–E).

- **demographic_cluster_output_*.rda** and **neutral_cluster_output_*.rda**  
  HPC job outputs containing model results for each array index.

- **processed_neutral_results.rda, challenge_A_data.rda, Challenge_E_HPC.rda, etc.**  
  Intermediate or final `.rda` files after further processing HPC results.

## Running on HPC

1. **Set up HPC environment**  
   Make sure you have the required modules loaded, for instance:
   ```bash
   module load R

2. **Submit Demographic Array Jobs**

cd HPC_scripts   # or the folder containing your scripts
qsub -J 1-100 run_demographic_cluster.sh
This starts 100 parallel HPC jobs, each running kz1724_HPC_2024_demographic_cluster.R with a different job index.

3. **Submit Neutral Theory Array Jobs**

qsub -J 1-100 run_neutral_cluster.sh
This similarly queues up neutral model simulations, writing .rda outputs to your directory.

4. Check Job Status

qstat -u <username>
Wait until the jobs finish (status changes from Q or R to no listing).

5. Collect and Analyze Results
Once completed, HPC results appear as demographic_cluster_output_*.rda or neutral_cluster_output_*.rda. Copy them locally if needed (e.g., via scp), then in R:

source("kz1724_HPC_2024_main.R")

# For demographic HPC questions:
question_5()   # Extinction probabilities
question_6()   # Stochastic vs. deterministic

# For neutral HPC:
process_neutral_cluster_results()
plot_neutral_cluster_results()
Or for the challenges, e.g.:
create_challengeE_data()
Challenge_E()


## Code Functionality
# Demographic Model
Questions 1–2

question_1() (deterministic).
question_2() (stochastic).
Each creates a .png file.
Questions 3–4
HPC array job code in kz1724_HPC_2024_demographic_cluster.R.

Questions 5–6

question_5() loads HPC results, calculates extinction fraction.
question_6() compares HPC population average to deterministic.

# Neutral Theory Model
Questions 7–13: Basic neutral steps, time series, speciation, etc.
Questions 14–22: Additional analyses/plots (question_14(), question_18(), question_22(), etc.).
neutral_cluster_run(): HPC function called by kz1724_HPC_2024_neutral_cluster.R.
Question 26: process_neutral_cluster_results() and plot_neutral_cluster_results() finalize HPC distributions.

# Challenge Questions A–E
Each Challenge_X() function does an advanced analysis, often requiring HPC outputs.
Plots are typically named Challenge_X.png.

# R Package Requirements
Base R (≥4.0)
ggplot2 for plotting
parallel (optionally, in challenge code)
Example installation:

install.packages("ggplot2")

## How to Reproduce Plots Locally
1. Collect HPC outputs
Copy or place _output_*.rda files into the same folder as kz1724_HPC_2024_main.R.

2. Open R
source("kz1724_HPC_2024_main.R")
question_1()
# => "question_1.png"
question_5()
# => "question_5.png"
...
# For Challenge E:
create_challengeE_data()
Challenge_E()
# => "Challenge_E.png"