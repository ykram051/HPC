#!/bin/bash
#SBATCH --job-name=root_calculation
#SBATCH --output=job_B.out
#SBATCH --dependency=afterok:$1  # $1 is the job ID of Job A passed as an argument

python root_calculation.py 1 -5  # Corresponding to a=1, b=-5
