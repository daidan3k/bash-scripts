# Instalació i funcionament de minikube

Primerament instalarem docker, tot i que tambe podem utilitzar kvm2, podman, virtualbox, etc...

```bash
sudo apt install software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release
sudo apt install docker -y

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo groupadd -aG docker $USER
```

A continuació descarregarem minikube i l'instalarem

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```

