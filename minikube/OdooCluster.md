# Cluster Odoo
El primer pas es instalar Debian 12 a cada servidor (node)\
Les particions dels servidors son les seguents:
- `/var:` 70GB
- `/home`: 20GB
- `/tmp`: 5GB
- `/root`: 20GB

Es important eliminar la particio de swap ja que kubeadm demana no tenir swap per funcionar correctament

A continuació hem configurat les IPs estatiques als servidors (Utilitzant les proporcionades a SXI)
- master: `enp3s0 - 172.23.8.10 `
- worker1: `ens1f0 - 172.23.8.20`
- worker2: `ens1f0 172.23.8.30`

Tambe s'haura d'afegir el DNS a `/etc/resolv.conf`
```bash
nameserver 172.23.0.13
```

Per ultim hem configurat SSH, creant claus SSH amb l'algoritme `ed25519` per tenir millor seguretat\
Tambe hem modificat les seguents linies al arxiu `/etc/ssh/sshd_conf`
```bash
PasswordAuthentication no
PubkeyAuthentication yes
```

## Configuració de xarxa
Mapa logic de la xarxa\
![image](https://github.com/user-attachments/assets/b023f1ad-d816-4489-81e8-406b44a11bd7)

Primerament hem formatejat el switch.\
L'engeguem en mode ROMMON, aguantant el boto "mode" fins que la llum de system es posa taronja. A continuació ens conectem al switch mitjançant un cable de consola i executem les seguents comandes.
```
flash_init
del flash:config.text
boot
```
Ports del switch.
| Port | Equip |
|----------|--------------|
| Fa0/1    | Master 01    |
| Fa0/2    | Worker 01    | 
| Fa0/3    | Worker 02    |
| Fa0/4    | Master 01    |
| Fa0/5    | Worker 01    |
| Fa0/6    | Worker 02    |
| Fa0/21   | Access Point |
| Fa0/23   | Router       |

A continuació configurarem el switch perque desde internet nomes es pugui accedir al Master. De moment desde dintre tots els dispositius tenen acces a internet per poder configurar el cluster amb facilitat, pero en el futur bloquejarem l'accès a internet per els workers.\
Per conectar-se al cluster localment els clients es conectaran al AP i per conectar-se desde fora es conectaran via el router.

## Configuració del cluster
Primerament instalarem kubernetes i les tools. Afegint la clau de signatura i el repositori de kubernetes i despres instalem amb apt.
```bash
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
```
