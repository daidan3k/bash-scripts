#!/bin/bash

DIR="/home/daidan/bash-scripts/cpuAverage"

if [ $# -ne 0 ]
then
	echo "Usage: ./cpuAverage.sh"
	exit 1
fi

mapfile -t PIDS < <(ps -e -o pid=)

declare -A AVERAGES

echo Calculating average CPU consumption of every process...
for PID in "${PIDS[@]}"
do
	if [ $PID -ne $$ ]
	then
		AVERAGES[$PID]="$($DIR/cpuPID.sh $PID)"
	fi
done

for PID in "${!AVERAGES[@]}"
do
	echo $PID ' - ' ${AVERAGES["$PID"]}
done | sort -rn -k3
