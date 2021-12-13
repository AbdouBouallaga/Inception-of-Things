kubectl apply -f ingress.yaml -n argocd
echo "used https://bcrypt-generator.com/ to generate password hash"
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$sKPFVu8k2JkGRo2nBVR6kOpeKDsv.SJ35qSmvXNmwkmV.avp3bWwm",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
kubectl create namespace dev
kubectl apply -f project.yaml -n argocd
kubectl apply -f application.yaml -n argocd 