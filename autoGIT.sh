#!/bin/sh

if [ $# -ne 1 ]
then
	echo "Usage: ./autoGIT.sh <comentari>"
	exit 1
fi

COMENTARI=$1

git add /home/daidan/bash-scripts/
git commit -m "$COMENTARI"
git push
