 #!/bin/sh

if [ $# -lt 2 ]
then
	echo "USAGE: ./biggerThan2.sh <MAXSIZE> <FOLDER>[...]"
	exit 1
fi

echo "[$(date '+%d/%m/%y %H:%M:%S')] | Script started" >> /var/log/biggerThan/output2.log

MAX=$1
shift

while [ $# -gt 0 ]
do
	DIR=$1
	DIR=${DIR%/}

	if [ ! -d $DIR ]
	then
		echo "[$(date '+%d/%m/%y %H:%M:%S')] | Directory '$DIR' not found" >> /var/log/biggerThan/output2.log
	fi

	find "$DIR"/ -mindepth 1 -type f | while read FILE
	do
		FILESIZE=$(du -b "$FILE" | cut -f1)
		if [ $FILESIZE -gt $MAX ]
		then
			echo "[$(date '+%d/%m/%y %H:%M:%S')] | File '$FILE' is $(($FILESIZE-$MAX)) bytes over the limit" >> /var/log/biggerThan/output2.log
		fi
	done
	shift
done
