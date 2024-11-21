#!/bin/sh

IP=$1
DOMAIN=$2

sed "s|domain.name|$2|g" ./forestScript.ps1 > ./setupForest.ps1

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa_AWS_WS Administrator@$IP powershell -Command - < setupForest.ps1 > /dev/null 2>&1
