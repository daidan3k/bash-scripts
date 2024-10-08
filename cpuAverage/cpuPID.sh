#!/bin/sh

if [ $# -ne 1 ]
then
	echo "Usage ./cpuAverage.sh <PID>"
	exit 1
fi

PID=$1
DADES=$(ps -p $PID -o cputime=,etime=)

CPUTIME=$(echo $DADES | cut -d " " -f1)
ETIME=$(echo $DADES | cut -d " " -f2)

# CPU Time
HHcpu=$(echo $CPUTIME | cut -d ":" -f1)
MMcpu=$(echo $CPUTIME | cut -d ":" -f2)
SScpu=$(echo $CPUTIME | cut -d ":" -f3)

SScpu=$(($HHcpu * 3600 + $MMcpu * 60 + $SScpu))

# Elapsed Time
MMe=$(echo $ETIME | cut -d ":" -f1)
SSe=$(echo $ETIME | cut -d ":" -f2)

SSe=$(($MMe * 60 + $SSe))

# Average
AVG=$((100 * $SScpu / $SSe))
echo "Average CPU Usage of PID $PID in the last $ETIME is $AVG%"
