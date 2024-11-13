#!/bin/bash

#SBATCH --job-name=ex3
#SBATCH --partition=shortq
#SBATCH --ntasks=1
#SBATCH --time=00:10:00
#SBATCH --output=ex3_V1_output.txt
#SBATCH --error=ex3_V1_error.txt
python3 ex3.py
