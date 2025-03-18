#!/bin/bash
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 1-100

# This script follows an official HPC approach:
# 1) module load R
# 2) copy R scripts into $TMPDIR
# 3) run them in $TMPDIR
# 4) move output files back to $HOME

module load R

# Create a destination directory in your home if it doesn't exist
mkdir -p $HOME/demographic_outputs

# Copy everything needed into $TMPDIR
cp $PBS_O_WORKDIR/kz1724_HPC_2024_demographic_cluster.R $TMPDIR
cp $PBS_O_WORKDIR/Demographic.R $TMPDIR
cp $PBS_O_WORKDIR/kz1724_HPC_2024_main.R $TMPDIR

# Move into $TMPDIR
cd $TMPDIR

echo "Starting demographic cluster array job, index = $PBS_ARRAY_INDEX"

# Run the R script
Rscript kz1724_HPC_2024_demographic_cluster.R

# Move the output .rda files back to home
mv demographic_cluster_output_*.rda $HOME/demographic_outputs

echo "Finished demographic cluster array job, index = $PBS_ARRAY_INDEX"
