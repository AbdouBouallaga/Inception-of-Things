cd scripts
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
apt-get install -y /usr/local/bin/kubectl
echo "creating babdelka cluster using k3d and exposing the post 80"
k3d cluster create babdelka --api-port 6443 -p "80:80@loadbalancer"
sleep 10
echo "deploying argocd"
/usr/local/bin/kubectl create namespace argocd
/usr/local/bin/kubectl apply -f install.yaml -n argocd
echo "WAIT FOR ALL PODS TO BE READY THEN RUN THE script2.sh"
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
echo "sleep 2min to wait for argocd to be ready"
sleep 120
cd gitlab_sc
/usr/local/bin/kubectl create namespace gitlab
/usr/local/bin/kubectl apply -f service.yaml
/usr/local/bin/kubectl apply -f glconfig.yaml
/usr/local/bin/kubectl apply -f deployment.yaml
/usr/local/bin/kubectl apply -f ingress.yaml
