#Colors

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Desc: Install ArgoCD
# echo "${BLUE}Installing ArgoCD${NC}"
# wget https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml

# export KUBEVIRT_CONTEXT="lelhlami"
# sudo kubectl config use-context ${KUBEVIRT_CONTEXT}

# Crete namespace DEV
alias k=kubectl
if [ -z "$(sudo kubectl get namespace dev)" ]; then
    echo "${BLUE}Creating namespace DEV${NC}"
    sudo kubectl create namespace dev
    sudo kubectl apply -f app/deployment.yaml -n dev
else
    echo "${GREEN}The namespace dev already exists${NC}"
fi
# Create namespace for ArgoCD
if [ -z "$(sudo kubectl get namespace argocd)" ]; then
    echo "${BLUE}Creating namespace for ArgoCD${NC}"
    sudo kubectl create namespace argocd
    sudo kubectl create -n argocd -f configuration/install.yaml
    sudo kubectl apply -f configuration/app.yaml -n argocd
else
    echo "${GREEN}The namespace argocd already exists${NC}"
fi

# Desc: Create an Ingress for ArgoCD
# echo "${BLUE}Creating an Ingress for ArgoCD${NC}"
# sudo kubectl apply -f configuration/ingress.yaml -n argocd

# Port forward ArgoCD
echo "${BLUE}Creating an Ingress for ArgoCD${NC}"

# sudo watch kubectl get pods -n dev

# Wait for argocd pods to start
echo "waiting for argocd pods to start.."
echo "${GREEN}This may take a while${NC}"
sudo kubectl wait --for=condition=Ready pods --all --timeout=69420s -n argocd
sudo kubectl wait --for=condition=Ready pods --all --timeout=69420s -n dev

# retrieving password
password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# print informations
printf "${GREEN}[ARGOCD]${NC} - Retrieving credentials...\n"

echo "login: admin, password: ${GREEN}$password"

# sudo kubectl port-forward svc/argocd-server -n argocd 8080:80
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 --address="0.0.0.0" 2>&1 > /var/log/argocd-log &
