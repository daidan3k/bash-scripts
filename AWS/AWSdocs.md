# Crear domini i clients AWS via scripts
## Instalar WS22
```
aws ec2 run-instances \
--image-id "ami-05f283f34603d6aed" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-0a42f2a3cda179b53"]}' \
--credit-specification '{"CpuCredits":"standard"}' \
--tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"WS22"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1" 
```
Un cop creat el servidor entrar via RDP i instalar SSH
```
# Instalar SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Iniciar SSH
Start-Service sshd

# Activar SSH automaticament al iniciar el servidor
Set-Service -Name sshd -StartupType 'Automatic'

# Permetre conexions SSH d'entrada al firewall
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Afegir usuari administrador al grup de "Remote Management"
Add-LocalGroupMember -Group "Remote Management Users" -Member "Administrator"
```
