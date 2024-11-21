# Instalar AD
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Import-Module ADDSDeployment

# Elevar servidor a Controlador de Domini (Es reinicia, trobar manera que no es reinicii/evaluar si es problematic)
Install-ADDSForest -DomainName "domain.name" -DomainNetbiosName "WindowsServer22" -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText "Patata123." -Force) -InstallDns -Force
