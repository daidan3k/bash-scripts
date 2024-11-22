# Com utilitzar l'script
## Requisits
- Tenir la clau d'AWS principal (vockey) a ```~/.ssh/AWS.pem``` (Ha de tenir aquest nom exacte)
- Tenir la informació de ```~/.aws/credentials``` correctement actualitzada

## Execució
Executar ```./deployInfrastructure.sh <ARGUMENTS>```\
Utilizar ```./deployInfrastructure.sh -h``` per veure mes informació.

Un cop executat l'script es creara el grup de seguretat, el WS22, els clients i es configuraran els usuaris dels clients.

A continuació et demanara que et conectis via RDP i configuris SSH al WS22.\
Es mostrara un script per pantalla que hauras de copiar i enganxar al WS22, al acabar l'script es reiniciara el servidor, un cop reiniciat prem cualsevol tecla al teu equip.\
Important: La nova password de Administrator es "Patata123."

A continuació es configurara el Directori Actiu al WS22
