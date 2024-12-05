# Possibles problemes
## Docker permission denied
Minikube recomana que utilitzem docker sense root, per poder executar docker sense root nescesitem estar dins del grup de docker
```bash
sudo groupadd -aG docker $USER
```

## Espai insuficient
A la documentació de minikube diu que nescesitem 20GB d'espai lliure al disc, pero no especifica que han de ser a la partició /var.\
S'ha de tenir en compte aixo ja que sino no podrem iniciar minikube
