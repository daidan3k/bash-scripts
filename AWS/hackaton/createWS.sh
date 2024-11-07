#!/bin/sh

SG=$1

aws ec2 run-instances \
--image-id "ami-05f283f34603d6aed" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"SubnetId":"subnet-07a60e4be91dcc4eb", "AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["'"$1"'"]}' \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"WS22"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1"
