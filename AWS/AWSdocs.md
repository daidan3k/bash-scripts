# Crear domini i clients AWS via scripts
## Instalar i configurar WS22
```powershell
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
```powershell
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

# Crear la carpeta per guardar les claus SSH
New-Item -ItemType Directory -Path $env:USERPROFILE\.ssh -Force
```
A continuació desde un Linux, generar un parell de claus SSH i enviarles al servidor
```bash
ssh-keygen -t rsa -b 2048
cd ~/.ssh
ssh-add id_rsa
```
Modificar els permisos de ".ssh" i "authorized_keys"
```powershell
Set-Content -Path $env:USERPROFILE\.ssh\authorized_keys -Value "<clau_publica>"
Set-Content -Path C:/ProgramData/ssh/administrators_authorized_keys -Value "<clau_publica>"
# "`" Es posa ja que sino dona parse error
icacls $env:USERPROFILE\.ssh /inheritance:r
icacls $env:USERPROFILE\.ssh /grant "$($env:USERNAME):(OI)(CI)F"
icacls $env:USERPROFILE\.ssh\authorized_keys /grant "$($env:USERNAME):F"
```
Modificar/descomentar les seguents linies de "C:\ProgramData\ssh\sshd_config"
```
PubkeyAuthentication yes
PasswordAuthentication no
```
