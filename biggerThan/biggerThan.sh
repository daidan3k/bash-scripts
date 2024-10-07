#!/bin/sh

if [ $# -lt 2 ]
then
	echo "[$(date '+%d/%m/%y %H:%M:%S')] | Script failed due to parameters error" >> /var/log/biggerThan/output.log
	exit 1
fi

echo "[$(date '+%d/%m/%y %H:%M:%S')] | Script started" >> /var/log/biggerThan/output.log

MAX=$1
shift

while [ $# -gt 0 ]
do
	FILE=$1
	FILESIZE=$(du -b $FILE | cut -f1)

	if [ ! -f $FILE ]
	then
		echo "[$(date '+%d/%m/%y %H:%M:%S')] | File '$FILE' not found" >> /var/log/biggerThan/output.log
	elif [ $FILESIZE -gt $MAX ]
        then
               	echo "[$(date '+%d/%m/%y %H:%M:%S')] | File '$FILE' is $(($FILESIZE-$MAX)) bytes over the limit" >> /var/log/biggerThan/output.log
	fi
	shift
done
