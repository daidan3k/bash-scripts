#!/bin/sh

DIR="/"

if [ $# -gt 1 ]
then
	echo Usage ...
	exit 1
fi

if [ $# -eq 1 ]
then
	if [ ! -d $1 ]
	then
		echo El directori '$1' no existeix
		exit 2
	fi
DIR=$1
fi

for FILE in $(find $DIR -type f 2>/dev/null)
do
	if [ -f $FILE ]
	then
		cat $FILE 2>/dev/null | grep "Password"
		if [ $? -eq 0 ]
		then
			echo "S'ha trobat 'Password' a $FILE"
		fi
	fi
done
