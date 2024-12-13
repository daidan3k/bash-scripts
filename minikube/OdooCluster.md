# Cluster Odoo
El primer pas es instalar Debian 12 a cada servidor (node)\
Les particions dels servidors son les seguents:
- `/var:` 70GB
- `/home`: 20GB
- `/tmp`: 5GB
- `/root`: 20GB
Es important eliminar la particio de swap ja que kubeadm demana no tenir swap per funcionar correctament

A continuació hem configurat les IPs estatiques als servidors (Utilitzant les proporcionades a SXI)
- master: `172.23.8.10`
- worker1: `172.23.8.20`
- worker2: `172.23.8.30`

Per ultim hem configurat SSH, creant claus SSH amb l'algoritme `ed25519` per tenir millor seguretat\
Tambe hem modificat les seguents linies al arxiu `/etc/ssh/sshd_conf`
```bash
PasswordAuthentication no
PubkeyAuthentication yes
```
