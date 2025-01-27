# Cluster Odoo
El primer pas es instalar Debian 12 a cada servidor (node)\
Les particions dels servidors son les seguents:
- `/var:` 70GB
- `/home`: 20GB
- `/tmp`: 5GB
- `/root`: 20GB

Es important eliminar la particio de swap ja que kubeadm demana no tenir swap per funcionar correctament

A continuació hem configurat les IPs estatiques als servidors (Utilitzant les proporcionades a SXI)
- master01A: `enp3s0 - 192.168.0.10`
- worker01A: `enp4s3 - 192.168.0.11`
- worker02A: `enp2s4 - 192.168.0.12`

Tambe s'haura d'afegir el DNS a `/etc/resolv.conf`
```bash
nameserver 172.23.0.13
```

Per ultim hem configurat SSH, creant claus SSH amb l'algoritme `ed25519` per tenir millor seguretat
```bash
ssh-keygen -t ed25519
```
Tambe hem modificat les seguents linies al arxiu `/etc/ssh/sshd_conf`
```bash
PasswordAuthentication no
PubkeyAuthentication yes
```

## Configuració de xarxa
Mapa logic de la xarxa\
![image](https://github.com/user-attachments/assets/89b62609-eace-4fdc-9337-a375e91e6623)


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
| Fa0/1    | Master 01 [GrupA]   |
| Fa0/2    | Worker 01 [GrupA]   | 
| Fa0/3    | Worker 02 [GrupA]   |
| Fa0/4    | Master 01 [GrupB]   |
| Fa0/5    | Worker 01 [GrupB]   |
| Fa0/6    | Worker 02 [GrupB]   |
| Fa0/21   | Access Point |
| Fa0/23   | Router       |

A continuació configurarem el switch perque desde internet nomes es pugui accedir al Master. De moment desde dintre tots els dispositius tenen acces a internet per poder configurar el cluster amb facilitat, pero en el futur bloquejarem l'accès a internet per els workers.\
Per conectar-se al cluster localment els clients es conectaran al AP i per conectar-se desde fora es conectaran via el router.

## Configuració del cluster
# Instalar kubernetes i tools
Primerament instalarem kubernetes i les tools. Afegint la clau de signatura i el repositori de kubernetes i despres l'instalem amb apt.
```bash
# Instalar dependencies
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Descarregar la clau de firma
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Afegir repositori de kubernetes
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Instalar kubernetes i les tools
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
```

# Configuració hostnames
Seguirem establint hostnames per els equips.
```bash
# master01A
sudo hostnamectl set-hostname "master01A.asix.local"
# worker01A
sudo hostnamectl set-hostname "worker01A.asix.local"
# worker02A
sudo hostnamectl set-hostname "worker02A.asix.local"
```
I afegirem les seguents linies a `/etc/hosts` a tots els nodes.
```bash
192.168.0.10    master01A.asix.local    master01A
192.168.0.11    worker01A.asix.local    worker01A
192.168.0.12    worker02A.asix.local    worker02A
```

# Instalar containerd
A continuació instalarem `containerd`. Primerament executarem les seguents comandes, que carregen moduls del kernel i configuren uns parametres perque `containerd` funcioni correctament.
```bash
# Configurar kernel per funcionar amb containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF
sudo modprobe overlay 
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF
sudo sysctl --system

# Instalar containerd
sudo apt -y install containerd

# Configurar containerd perque funcioni amb kubernetes
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
```
Seguirem modificant l'arxiu `/etc/containerd/config.toml` per modificar SystemdCgroup de false a true. Aixo fara que containerd utilitzi systemd con a manager de cgroup. Aquesta modificació la farem als 3 nodes.
![image](https://github.com/user-attachments/assets/bfb6e4c2-f06d-4f86-b98a-7b38ce6c5cf2)

Per ultim reiniciem i activem containerd.
```bash
sudo systemctl restart containerd
sudo systemctl enable containerd
```

# Inicialització del cluster
Crearem un arxiu `kubelet.yaml` amb la configuració del cluster.
```yaml
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: "1.32.0"
controlPlaneEndpoint: "master01A"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
```


