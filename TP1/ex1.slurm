#!/bin/bash
#SBATCH --job-name=TP1_ex1
#SBATCH --nodes=1
#SBATCH --nodelist=node03
#SBATCH --ntasks=1
#SBATCH --output=TP1_ex1_output_%j.log
#SBATCH --error=TP1_ex1_error_%j.log

module load python  

python ex1.py
