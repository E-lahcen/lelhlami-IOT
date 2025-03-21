#Colors

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Desc: Install ArgoCD
# echo "${BLUE}Installing ArgoCD${NC}"
# wget https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml

export KUBEVIRT_CONTEXT="lelhlami"
sudo kubectl config use-context ${KUBEVIRT_CONTEXT}

# Crete namespace DEV
if [ -z "$(sudo kubectl get namespace dev)" ]; then
    echo "${BLUE}Creating namespace DEV${NC}"
    sudo kubectl create namespace dev
    sudo kubectl apply -f configuration/app.yaml -n dev
else
    echo "${GREEN}The namespace dev already exists${NC}"
fi
# Create namespace for ArgoCD
if [ -z "$(sudo kubectl get namespace argocd)" ]; then
    echo "${BLUE}Creating namespace for ArgoCD${NC}"
    sudo kubectl create namespace argocd
    sudo kubectl create -n argocd -f configuration/install.yaml
else
    echo "${GREEN}The namespace argocd already exists${NC}"
fi

# Desc: Create an Ingress for ArgoCD
# echo "${BLUE}Creating an Ingress for ArgoCD${NC}"
# sudo kubectl apply -f configuration/ingress.yaml -n argocd

# Port forward ArgoCD
echo "${BLUE}Creating an Ingress for ArgoCD${NC}"
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443

alias k=kubectl