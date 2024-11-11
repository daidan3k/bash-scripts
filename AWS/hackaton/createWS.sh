#!/bin/sh

SG=$1

ID=$(echo $(aws ec2 run-instances \
--image-id "ami-05f283f34603d6aed" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["'"$1"'"]}' \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"WS22"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1" \
--query 'Instances[0].InstanceId' \
--output text))

# Assignar IP elastica
sleep 15
aws ec2 associate-address --instance-id $ID --allocation-id $(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)

echo $(aws ec2 describe-instances --instance-ids $ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text | cut -d " " -f 5)
