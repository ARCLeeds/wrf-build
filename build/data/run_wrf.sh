#!/bin/bash

# Run the code from the current working directory and with the current module environment
#$ -V -cwd

# Specify a runtime- 12 hours in this case
#$ -l h_rt=12:00:00

# Request a full node (16 cores and 32GB on ARC2)
#$ -l nodes=1 


#$ -m be
#$ -M uitjr@leeds.ac.uk

# Concatenate output and error files
#$ -j y
#$ -o wrftest5.out

# Set The MPICH Abort Environment Variable

export MPICH_ABORT_ON_ERROR=1
ulimit -c unlimited



# Run WRF

mpirun wrf.exe

