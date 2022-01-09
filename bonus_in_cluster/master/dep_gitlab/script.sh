    echo "deploying gitlab"
    /usr/local/bin/kubectl create namespace gitlab
    /usr/local/bin/kubectl apply -f /vagrant/dep_gitlab/service.yaml
    /usr/local/bin/kubectl apply -f /vagrant/dep_gitlab/glconfig.yaml
    /usr/local/bin/kubectl apply -f /vagrant/dep_gitlab/deployment.yaml
    /usr/local/bin/kubectl apply -f /vagrant/dep_gitlab/ingress.yaml