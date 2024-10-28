#!/bin/sh


NAME=$1
shift
TYPE=$1
shift

EC2=$(/home/daidan/bash-scripts/AWS/scripts/createVM.sh $NAME $TYPE)

echo $EC2

while [ $# -ne 0 ]
do
	PORT=$1
	SG=$(/home/daidan/bash-scripts/AWS/scripts/createSG.sh $PORT)
	/home/daidan/bash-scripts/AWS/scripts/applySG.sh $SG
	shift
done
