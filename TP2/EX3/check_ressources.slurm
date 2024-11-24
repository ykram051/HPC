#!/bin/bash

# Minimum requirements
MIN_CPUS=4
MIN_GPUS=1

# Partition to check
PARTITION="gpu"

AVAILABLE_CPUS=$(sinfo -o "%C" | awk 'NR==2 {split($0, arr, "/"); print arr[2]}' | grep -o '^[0-9]\+')


echo "Raw CPU Info:"
sinfo -o "%C"
echo "Parsed Available CPUs: $AVAILABLE_CPUS"

# Extract GPU availability in the specified partition
AVAILABLE_GPUS=$(sinfo -p $PARTITION --format="%G" | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum}')


NODE_STATES=$(sinfo -o "%t" | sort | uniq -c)

echo "Available CPUs: $AVAILABLE_CPUS"
echo "Available GPUs in partition '$PARTITION': $AVAILABLE_GPUS"
echo "Node states summary:"
echo "$NODE_STATES"


if [[ -z "$AVAILABLE_CPUS" || "$AVAILABLE_CPUS" -lt $MIN_CPUS ]]; then
    echo "Insufficient CPUs available. Minimum required: $MIN_CPUS, Available: $AVAILABLE_CPUS"
    exit 1
fi

if [[ -z "$AVAILABLE_GPUS" || "$AVAILABLE_GPUS" -lt $MIN_GPUS ]]; then
    echo "Insufficient GPUs available in partition '$PARTITION'. Minimum required: $MIN_GPUS, Available: $AVAILABLE_GPUS"
    exit 1
fi

echo "Sufficient resources available. Submitting job..."

JOB_NAME="TP2_ex3_job"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="${JOB_NAME}_${TIMESTAMP}.out"

sbatch --job-name=$JOB_NAME --output=$OUTPUT_FILE TP2_ex3_submit_job.slurm
