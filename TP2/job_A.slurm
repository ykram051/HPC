#!/bin/bash
#SBATCH --job-name=discriminant_calculation
#SBATCH --output=job_A.out

python calc.py 1 -5 6  # Example coefficients: a=1, b=-5, c=6


