#!/bin/bash
#SBATCH --array=1-10%2        # Job array from 1 to 10, limit to 2 tasks at once
#SBATCH --job-name=array_task
#SBATCH --output=TP2_EX1_output.txt   

CONFIG_FILE="config.txt"


line=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $CONFIG_FILE)


ArrayTaskID=$(echo $line | awk '{print $1}')
SampleName=$(echo $line | awk '{print $2}')
Sex=$(echo $line | awk '{print $3}')


echo "This is array task ${ArrayTaskID}, the sample name is ${SampleName} and the sex is ${Sex}." >> TP2_EX1_output.txt
