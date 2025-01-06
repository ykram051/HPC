#!/bin/bash

# Define default date range if not provided
START_DATE=${1:-"2024-01-01"}  
END_DATE=${2:-$(date +%Y-%m-%d)}  
OUTPUT_FILE="output.csv"

# Prepare the output file if it doesn't exist
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "User,CPU_Time(Hours),GPU_Time(Hours)" > $OUTPUT_FILE
fi

# Read existing data into an associative array
declare -A CPU_TIME_MAP
declare -A GPU_TIME_MAP
while IFS="," read -r USER CPU_TIME GPU_TIME; do
    if [[ "$USER" != "User" ]]; then
        CPU_TIME_MAP[$USER]=$CPU_TIME
        GPU_TIME_MAP[$USER]=$GPU_TIME
    fi
done < $OUTPUT_FILE

# Get the list of all users
USERS=$(sacctmgr list user format=User -P | tail -n +2)  # Skip the header row

# Loop through each user and calculate their total usage
for USER in $USERS; do
    # Calculate total CPU time for the user
    TOTAL_CPU_TIME=$(sacct --user=$USER --starttime=$START_DATE --endtime=$END_DATE --format=CPUTime -n -P | awk -F'|' ' {
        split($1, time, ":");
        if (length(time) == 3) {
            sum += time[1] * 3600 + time[2] * 60 + time[3];
        } else if (length(time) == 2) {
            sum += time[1] * 60 + time[2];
        } else {
            sum += time[1];
        }
    } END {print sum / 3600}')  # Convert seconds to hours

    # Calculate total GPU time for the user
    TOTAL_GPU_TIME=$(sacct --user=$USER --starttime=$START_DATE --endtime=$END_DATE --format=AllocGRES,ElapsedRaw -n -P | awk -F'|' ' {
        if ($1 ~ /gpu/) {
            sum += $2;
        }
    } END {print sum / 3600}')  # Convert seconds to hours

    # If no CPU or GPU time is found, set to 0
    TOTAL_CPU_TIME=${TOTAL_CPU_TIME:-0}
    TOTAL_GPU_TIME=${TOTAL_GPU_TIME:-0}

    # Update or add the user entry
    CPU_TIME_MAP[$USER]=$TOTAL_CPU_TIME
    GPU_TIME_MAP[$USER]=$TOTAL_GPU_TIME
done

# Write the updated data back to the CSV file
echo "User,CPU_Time(Hours),GPU_Time(Hours)" > $OUTPUT_FILE
for USER in "${!CPU_TIME_MAP[@]}"; do
    echo "$USER,${CPU_TIME_MAP[$USER]},${GPU_TIME_MAP[$USER]}" >> $OUTPUT_FILE
done

# Display the results
cat $OUTPUT_FILE

