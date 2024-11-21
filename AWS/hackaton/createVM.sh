#!/bin/sh

SG=$1
TYPE=$2
AMI=""

case $TYPE in
	"WS")
		AMI="ami-05f283f34603d6aed"
	;;
	"Debian")
		AMI="ami-064519b8c76274859"
	;;
	*)
		exit 1
	;;
esac

ID=$(echo $(aws ec2 run-instances \
--image-id "$AMI" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["'"$1"'"]}' \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"'"$TYPE"'"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1" \
--query 'Instances[0].InstanceId' \
--output text))

# Assignar IP elastica
if [ "$TYPE" = "WS" ]
then
	STATE=$(aws ec2 describe-instances --instance-ids $ID --query "Reservations[*].Instances[*].State.Name" --output "text")
	while [ "$STATE" != "running" ]
	do
	        STATE=$(aws ec2 describe-instances --instance-ids $ID --query "Reservations[*].Instances[*].State.Name" --output "text")
        	sleep 10
	done

	aws ec2 associate-address --instance-id $ID --allocation-id $(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text) > /dev/null 2>&1
fi

echo $(aws ec2 describe-instances --instance-ids $ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text | cut -d " " -f 5)
