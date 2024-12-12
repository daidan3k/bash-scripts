# Cluster Odoo
El primer pas es instalar Debian 12 a cada servidor (node)\
Les particions dels servidors son les seguents:
- `/var:` 70GB
- `/home`: 20GB
- `/tmp`: 5GB
- `/root`: 20GB
Es important eliminar la particio de swap ja que kubeadm demana no tenir swap per funcionar correctament
