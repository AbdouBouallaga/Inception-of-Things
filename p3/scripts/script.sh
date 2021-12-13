apt-get update
apt-get install -y curl sudo
echo "installing docker"
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
echo "installing k3d"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash -
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
echo "installing kubectl"
apt-get install -y kubectl
echo "creating babdelka cluster using k3d and exposing the post 80"
k3d cluster create babdelka --api-port 6443 -p "80:80@loadbalancer"
sleep 10
echo "deploying argocd"
kubectl create namespace argocd
kubectl apply -f install.yaml -n argocd
sleep 10
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