# Desc: Install ArgoCD
wget https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml
# Desc: Create namespace for ArgoCD
sudo kubectl create namespace argocd
sudo kubectl create -n argocd -f install.yaml

# Desc: Create an Ingress for ArgoCD
sudo kubectl apply -f configuration/ingress.yaml -n argocd