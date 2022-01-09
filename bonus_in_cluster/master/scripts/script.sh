cd /vagrant/scripts
/usr/local/bin/kubectl create namespace argocd
/usr/local/bin/kubectl apply -f install.yaml -n argocd
sleep 10
/usr/local/bin/kubectl apply -f ingress.yaml -n argocd
echo "used https://bcrypt-generator.com/ to generate password hash"
/usr/local/bin/kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$sKPFVu8k2JkGRo2nBVR6kOpeKDsv.SJ35qSmvXNmwkmV.avp3bWwm",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
/usr/local/bin/kubectl create namespace dev
/usr/local/bin/kubectl apply -f project.yaml -n argocd
/usr/local/bin/kubectl apply -f application.yaml -n argocd
echo "argocd will be ready soon"