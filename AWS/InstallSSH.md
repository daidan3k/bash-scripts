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

# Crear arxius authorized keys
Set-Content -Path $env:USERPROFILE\.ssh\authorized_keys -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaRgXjwDrJMdzu3h7ree3zYBJw3WBbLo+dUYpoQRmRFSLNb/RAO/SyAsI9besXtXqmh/cHnELOAkmLAENbLcUgGENOLqOORQDTaTQXsAsGVdRrdScc6fZZ6PZa1lgDL8mXNUocLIUmYYHO/xIrndow3vUKhumoL8cwsZqNHMGSG75v6E70TZXsWIHDPaGTo/me7bYxLfgOZiMWfybvyfb9M+3M4WGlLgXop9CJp1oZgW9LyCaYXGvJLGPrsVHMyqTzRKGb67tskUdvrhJ5fWQFKHWgPg1KSGzTpT9zmWOzdU42SY+5pJ6dM77MYB241i/OBa1L5B4fz6cYvKprBv6T daidan@debian"
Set-Content -Path C:/ProgramData/ssh/administrators_authorized_keys -Value "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaRgXjwDrJMdzu3h7ree3zYBJw3WBbLo+dUYpoQRmRFSLNb/RAO/SyAsI9besXtXqmh/cHnELOAkmLAENbLcUgGENOLqOORQDTaTQXsAsGVdRrdScc6fZZ6PZa1lgDL8mXNUocLIUmYYHO/xIrndow3vUKhumoL8cwsZqNHMGSG75v6E70TZXsWIHDPaGTo/me7bYxLfgOZiMWfybvyfb9M+3M4WGlLgXop9CJp1oZgW9LyCaYXGvJLGPrsVHMyqTzRKGb67tskUdvrhJ5fWQFKHWgPg1KSGzTpT9zmWOzdU42SY+5pJ6dM77MYB241i/OBa1L5B4fz6cYvKprBv6T daidan@debian>"

# Modificar permisos d'arxius i carpetes
# "`" Es posa ja que sino dona parse error
icacls $env:USERPROFILE\.ssh /inheritance:r
icacls $env:USERPROFILE\.ssh /grant "$($env:USERNAME):(OI)(CI)F"
icacls $env:USERPROFILE\.ssh\authorized_keys /grant "$($env:USERNAME):F"


Add-Content -Path "C:\ProgramData\ssh\sshd_config" -Value "PubkeyAuthentication yes"
Add-Content -Path "C:\ProgramData\ssh\sshd_config" -Value "PasswordAuthentication no"

# Reiniciar SSH
Restart-Service sshd
```
