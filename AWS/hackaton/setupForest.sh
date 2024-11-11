#!/bin/sh

IP=$1
DOMAIN=$2

ssh -i ~/.ssh/id_rsa Administrator@$IP "powershell -Command 'Install-WindowsFeature AD-Domain-Services -IncludeManagementTools'" &
ssh -i ~/.ssh/id_rsa Administrator@$IP "powershell -Command 'Import-Module ADDSDeployment'" &
ssh -i ~/.ssh/id_rsa Administrator@$IP "powershell -Command 'Install-ADDSForest -DomainName '$DOMAIN' -DomainNetbiosName 'WindowsServer22' -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText 'Patata123.' -Force) -InstallDns -Force'" &
