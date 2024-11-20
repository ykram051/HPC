#!/bin/bash
#SBATCH --job-name=selective_sample_processing
#SBATCH --output=TP2_1_v2_output.txt
#SBATCH --array=3,5,7

readarray -t data < config.txt
line="${data[$SLURM_ARRAY_TASK_ID]}"

sample_name=$(echo $line | awk '{print $2}')
sex=$(echo $line | awk '{print $3}')

echo "This is array task $SLURM_ARRAY_TASK_ID, the sample name is $sample_name and the sex is $sex." >> TP2_1_v2_output.txt
