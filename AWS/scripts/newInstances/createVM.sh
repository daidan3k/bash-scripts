#!/bin/sh

NAME=$1
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

echo $(aws ec2 run-instances \
--image-id "$AMI" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"SubnetId":"subnet-07a60e4be91dcc4eb", "AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-04be9947c7de985a9"]}' \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"'"$NAME"'"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1" \
--query 'Instances[0].InstanceId' \
--output text)

