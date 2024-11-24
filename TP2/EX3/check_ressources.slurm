#!/bin/bash

# Default minimum requirements (can be overridden by arguments or environment variables)
MIN_CPUS=${MIN_CPUS:-4}
MIN_GPUS=${MIN_GPUS:-1}
PARTITION=${PARTITION:-gpu}

# Parse command-line arguments for minimum requirements
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --cpus) MIN_CPUS="$2"; shift ;;
        --gpus) MIN_GPUS="$2"; shift ;;
        --partition) PARTITION="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Checking resources with minimum requirements:"
echo "  CPUs: $MIN_CPUS"
echo "  GPUs: $MIN_GPUS"
echo "  Partition: $PARTITION"

AVAILABLE_CPUS=$(sinfo -o "%C" | awk 'NR==2 {split($0, arr, "/"); print arr[2]}' | grep -o '^[0-9]\+')
AVAILABLE_GPUS=$(sinfo -p $PARTITION --format="%G" | grep -o '[0-9]*' | awk '{sum+=$1} END {print sum}')


NODE_STATES=$(sinfo -o "%t" | sort | uniq -c)

QUEUED_JOBS=$(squeue -u $USER | wc -l)

echo "Available CPUs: $AVAILABLE_CPUS"
echo "Available GPUs in partition '$PARTITION': $AVAILABLE_GPUS"
echo "Node states summary:"
echo "$NODE_STATES"
echo "Jobs in queue for user $USER: $((QUEUED_JOBS - 1))"

# Validate resource availability
if [[ -z "$AVAILABLE_CPUS" || "$AVAILABLE_CPUS" -lt $MIN_CPUS ]]; then
    echo "Insufficient CPUs available. Minimum required: $MIN_CPUS, Available: $AVAILABLE_CPUS"
    exit 1
fi

if [[ -z "$AVAILABLE_GPUS" || "$AVAILABLE_GPUS" -lt $MIN_GPUS ]]; then
    echo "Insufficient GPUs available in partition '$PARTITION'. Minimum required: $MIN_GPUS, Available: $AVAILABLE_GPUS"
    exit 1
fi

echo "Sufficient resources available. Ready for job submission."
