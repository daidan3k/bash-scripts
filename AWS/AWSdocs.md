# Crear domini i clients AWS via scripts
## Instalar WS22 i configurar SSH
```bash
aws ec2 run-instances \
--image-id "ami-05f283f34603d6aed" \
--instance-type "t2.micro" \
--key-name "AWS" \
--network-interfaces '{"SubnetId":"subnet-07a60e4be91dcc4eb", "AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-0a42f2a3cda179b53"]}' \
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
Set-Content -Path $env:USERPROFILE\.ssh\authorized_keys -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaRgXjwDrJMdzu3h7ree3zYBJw3WBbLo+dUYpoQRmRFSLNb/RAO/SyAsI9besXtXqmh/cHnELOAkmLAENbLcUgGENOLqOORQDTaTQXsAsGVdRrdScc6fZZ6PZa1lgDL8mXNUocLIUmYYHO/xIrndow3vUKhumoL8cwsZqNHMGSG75v6E70TZXsWIHDPaGTo/me7bYxLfgOZiMWfybvyfb9M+3M4WGlLgXop9CJp1oZgW9LyCaYXGvJLGPrsVHMyqTzRKGb67tskUdvrhJ5fWQFKHWgPg1KSGzTpT9zmWOzdU42SY+5pJ6dM77MYB241i/OBa1L5B4fz6cYvKprBv6T daidan@debian"
Set-Content -Path C:/ProgramData/ssh/administrators_authorized_keys -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaRgXjwDrJMdzu3h7ree3zYBJw3WBbLo+dUYpoQRmRFSLNb/RAO/SyAsI9besXtXqmh/cHnELOAkmLAENbLcUgGENOLqOORQDTaTQXsAsGVdRrdScc6fZZ6PZa1lgDL8mXNUocLIUmYYHO/xIrndow3vUKhumoL8cwsZqNHMGSG75v6E70TZXsWIHDPaGTo/me7bYxLfgOZiMWfybvyfb9M+3M4WGlLgXop9CJp1oZgW9LyCaYXGvJLGPrsVHMyqTzRKGb67tskUdvrhJ5fWQFKHWgPg1KSGzTpT9zmWOzdU42SY+5pJ6dM77MYB241i/OBa1L5B4fz6cYvKprBv6T daidan@debian>"
# "`" Es posa ja que sino dona parse error
icacls $env:USERPROFILE\.ssh /inheritance:r
icacls $env:USERPROFILE\.ssh /grant "$($env:USERNAME):(OI)(CI)F"
icacls $env:USERPROFILE\.ssh\authorized_keys /grant "$($env:USERNAME):F"
```
Modificar/descomentar les seguents linies de "C:\ProgramData\ssh\sshd_config"
```
PubkeyAuthentication yes
PasswordAuthentication no

# Reiniciar SSH
Restart-Service sshd

# Canviar hostname i reiniciar servidor
Rename-Computer -NewName "WS22" -Restart
```
# Configurar domini/forest
```powershell
# Instalar AD
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

# Elevar servidor a Controlador de Domini (Es reinicia, trobar manera que no es reinicii/evaluar si es problematic)
Install-ADDSForest -DomainName "daidan.local" -DomainNetbiosName "WindowsServer22" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Patata123." -Force) -InstallDns -Force
```
# Crear clients Debian i afegir-los al domini
```bash
aws ec2 run-instances \
--image-id "ami-064519b8c76274859" \
--instance-type "t2.micro" \
--key-name "AWS" \
--block-device-mappings '{"DeviceName":"/dev/xvda","Ebs":{"Encrypted":false,"DeleteOnTermination":true,"Iops":3000,"SnapshotId":"snap-0e3a4e2ca23a73496","VolumeSize":50,"VolumeType":"gp3","Throughput":125}}' \
--network-interfaces '{"SubnetId":"subnet-07a60e4be91dcc4eb", "AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-0a42f2a3cda179b53"]}' \
--credit-specification '{"CpuCredits":"standard"}' --tag-specifications '{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"Debian12"}]}' \
--private-dns-name-options '{"HostnameType":"ip-name","EnableResourceNameDnsARecord":true,"EnableResourceNameDnsAAAARecord":false}' \
--count "1"
```
Executar les seguents comandes per entrar-lo al domini
```bash
# Actualitzar i instalar repositoris nescesaris
sudo apt update
sudo apt install realmd sssd samba-common-bin adcli -y

# Afegir ruta del DNS/WindowsServer
echo "nameserver <IPServer>" | sudo tee /etc/resolv.conf

# Entrar al domini
echo "Patata123." | sudo realm join --user="Administrator" "daidan.local" --install=/ -v

#####
No entra:

admin@ip-172-31-28-95:~$ echo "Patata123." | sudo realm join --user="Administrator" "daidan.local" --install=/ -v
 * Resolving: _ldap._tcp.daidan.local
 * Performing LDAP DSE lookup on: 172.31.24.165
 * Successfully discovered: daidan.local
Password for Administrator: 
 * Assuming packages are installed
 * LANG=C /usr/sbin/adcli join --verbose --domain daidan.local --domain-realm DAIDAN.LOCAL --domain-controller 172.31.24.165 --login-type user --login-user Administrator --stdin-password
 * Using domain name: daidan.local
 * Calculated computer account name from fqdn: IP-172-31-28-95
 * Using domain realm: daidan.local
 * Sending NetLogon ping to domain controller: 172.31.24.165
 * Received NetLogon info from: WS22.daidan.local
 * Wrote out krb5.conf snippet to /var/cache/realmd/adcli-krb5-NV4LL8/krb5.d/adcli-krb5-conf-HtLfi7
 * Authenticated as user: Administrator@DAIDAN.LOCAL
 * Using GSS-SPNEGO for SASL bind
 ! Couldn't authenticate to active directory: SASL(-1): generic failure: GSSAPI Error: Unspecified GSS failure.  Minor code may provide more information (Server not found in Kerberos database)
adcli: couldn't connect to daidan.local domain: Couldn't authenticate to active directory: SASL(-1): generic failure: GSSAPI Error: Unspecified GSS failure.  Minor code may provide more information (Server not found in Kerberos database)
 ! Insufficient permissions to join the domain
realm: Couldn't join realm: Insufficient permissions to join the domain

#####
```
