#!/bin/sh

# Crear SG
aws ec2 create-security-group --group-name hackaton-sg --description "Security Group for Hackaton" > /dev/null 2>&1
ECODE=$?

# Guardar ID
ID=$(echo $(aws ec2 describe-security-groups --filter Name=group-name,Values="hackaton-sg" --query 'SecurityGroups[0].[GroupId]' --output text))

# Error
if [ $ECODE -ne 0 ] && [ $ECODE -ne 254 ]
then
        exit 2
fi

# Entrada
aws ec2 authorize-security-group-ingress --group-id $ID --protocol tcp --port 22 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol udp --port 389 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol icmp --port -1 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol tcp --port 3389 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol udp --port 88 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol tcp --port 88 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol tcp --port 53 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol udp --port 53 --cidr 0.0.0.0/0 > /dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-id $ID --protocol tcp --port 389 --cidr 0.0.0.0/0 > /dev/null 2>&1

echo $ID
