#!/bin/bash
#SBATCH --job-name=job_2
#SBATCH --ntasks=10               # Number of tasks
#SBATCH --gres=gpu:1              # Request 1 GPU
#SBATCH --output=ex2_output.txt   # Output file

# Run your Python script
python ex2.py
