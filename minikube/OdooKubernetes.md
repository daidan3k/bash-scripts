Primerament instalarem docker i ens posarem dins del grup "docker"
```bash
sudo apt install software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release
sudo apt install docker -y

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $USER
```

A continuació instalarem minikube i kubernetes
```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
minikube kubectl -- get po -A
```

Iniciarem minikube i el dashboard, tot i que nomes l'utilitzarem per veure informació
```bash
minikube start
minikube dashboard
```

Crearem un espai per organizaros
```bash
kubectl create namespace odoo
```

Crearem una carpeta on guardarem la configuració
```bash
mkdir ~/odoo
cd ~/odoo
```

Despres, crearem els arxius de configuració, primerament la base de dades, utilitzarem postgres
```bash
nano postgres-deployment.yaml
```
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: odoo-db
  namespace: odoo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: odoo-db
  template:
    metadata:
      labels:
        app: odoo-db
    spec:
      containers:
      - name: postgres
        image: postgres:13
        env:
        - name: POSTGRES_USER
          value: asix
        - name: POSTGRES_PASSWORD
          value: patata
        - name: POSTGRES_DB
          value: odoo
        ports:
        - containerPort: 5432
```
