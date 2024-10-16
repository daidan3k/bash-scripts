#!/bin/sh

if [ $# -ne 1 ]
then
	echo "Usage ./cpuAverage.sh <PID>"
	exit 1
fi

clean_number=$(expr $number + 0)


PID=$1
DADES=$(ps -p $PID -o cputime=,etime=)

CPUTIME=$(echo $DADES | cut -d " " -f1 | sed -E 's/^0([89])/\1/')
ETIME=$(echo $DADES | cut -d " " -f2 | sed -E 's/^0([89])/\1/')

# CPU Time
HHcpu=$(echo $CPUTIME | cut -d ":" -f1 | sed -E 's/^0([89])/\1/')
MMcpu=$(echo $CPUTIME | cut -d ":" -f2 | sed -E 's/^0([89])/\1/')
SScpu=$(echo $CPUTIME | cut -d ":" -f3 | sed -E 's/^0([89])/\1/')

SScpu=$(($HHcpu * 3600 + $MMcpu * 60 + $SScpu))

# Elapsed Time
MMe=$(echo $ETIME | cut -d ":" -f1 | sed -E 's/^0([89])/\1/')
SSe=$(echo $ETIME | cut -d ":" -f2 | sed -E 's/^0([89])/\1/')

SSe=$(( $MMe * 60 + $SSe ))

# Average
AVG=$(( 100 * $SScpu / $SSe ))
echo "$AVG"
