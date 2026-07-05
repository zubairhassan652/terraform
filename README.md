# Argocd Password
`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }; echo ""`

# Minikube docker shell
`minikube docker-env | Invoke-Expression`

# Enable ingress addons
`minikube addons enable ingress`

# Buid the image djagno app
` docker build -t fastapi-app:latest .`

# Remove minikube
`minikube delete --all --purge`

# Set envs

```
kubectl create secret generic redis-secret `
  --from-literal=REDIS_URL="redis://redis-redis-service.argocd.svc.cluster.local:6379/0" `
  --namespace argocd`
```

# Enable Metrics For Autoscaling
`minikube addons enable metrics-server`