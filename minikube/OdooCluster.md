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
![image](https://github.com/user-attachments/assets/1718e2aa-2cf2-42c4-b451-2d0f54e9d919)

A continuació configurarem el switch perque desde internet nomes es pugui accedir al Master. De moment desde dintre tots els dispositius tenen acces a internet per poder configurar el cluster amb facilitat, pero en el futur bloquejarem l'accès a internet per els workers.\
Per conectar-se al cluster localment els clients es conectaran al AP i per conectar-se desde fora es conectaran via el router.
