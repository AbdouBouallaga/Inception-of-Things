kubectl create namespace gitlab
kubectl apply -f service.yaml
kubectl apply -f glconfig.yaml
kubectl apply -f deployment.yaml
kubectl apply -f ingress.yaml
