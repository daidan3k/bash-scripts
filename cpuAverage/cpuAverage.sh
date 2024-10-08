#!/bin/bash

DIR="/home/daidan/scripts/cpuAverage"

if [ $# -ne 0 ]
then
	echo "Usage: ./cpuAverage.sh"
	exit 1
fi

mapfile -t PIDS < <(ps -e -o pid=)

declare -A AVERAGES

for PID in "${PIDS[@]}"
do
	AVERAGES[$PID]="$($DIR/cpuPID.sh $PID)"
done

for PID in "${!AVERAGES[@]}"
do
	echo "PID: $PID CPU: ${AVERAGES[$PID]}"
done | sort -k2 -nr

