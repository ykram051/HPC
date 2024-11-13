#!/bin/bash

#SBATCH --job-name=ex3
#SBATCH --partition=shortq
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=ex3_output.txt
#SBATCH --error=ex3_error.txt
#SBATCH --mem=160G
python3 ex3.py
