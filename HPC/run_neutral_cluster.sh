#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb
#PBS -J 1-100

# This script follows an official HPC approach for the neutral model.

module load R

# Create a destination directory in your home if it doesn't exist
mkdir -p $HOME/neutral_outputs

# Copy needed files into $TMPDIR
cp $PBS_O_WORKDIR/kz1724_HPC_2024_neutral_cluster.R $TMPDIR
cp $PBS_O_WORKDIR/Demographic.R $TMPDIR
cp $PBS_O_WORKDIR/kz1724_HPC_2024_main.R $TMPDIR

cd $TMPDIR
echo "Starting neutral cluster array job, index = $PBS_ARRAY_INDEX"

Rscript kz1724_HPC_2024_neutral_cluster.R

mv neutral_cluster_output_*.rda $HOME/neutral_outputs

echo "Finished neutral cluster array job, index = $PBS_ARRAY_INDEX"
