# Possibles problemes
## Docker permission denied
Minikube recomana que utilitzem docker sense root, per poder executar docker sense root nescesitem estar dins del grup de docker
```bash
sudo groupadd -aG docker $USER
```
