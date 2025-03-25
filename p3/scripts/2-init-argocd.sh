#Colors

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Desc: Install ArgoCD
# echo "${BLUE}Installing ArgoCD${NC}"
# wget https://raw.githubusercontent.com/argoproj/argo-cd/v2.0.1/manifests/install.yaml

# export KUBEVIRT_CONTEXT="lelhlami"
#  kubectl config use-context ${KUBEVIRT_CONTEXT}

alias k=kubectl
# Crete namespace DEV
if [ -z "$(kubectl get namespace dev)" ]; then
    echo "${BLUE}Creating namespace DEV${NC}"
    kubectl create namespace dev
    kubectl apply -f ../confs/deployment.yaml -n dev
else
    echo "${GREEN}The namespace dev already exists${NC}"
fi
# Create namespace for ArgoCD
if [ -z "$(kubectl get namespace argocd)" ]; then
    echo "${BLUE}Creating namespace for ArgoCD${NC}"
    kubectl create namespace argocd
    kubectl create -n argocd -f ../confs/install.yaml
    kubectl apply -f ../confs/app.yaml -n argocd
else
    echo "${GREEN}The namespace argocd already exists${NC}"
fi

# Desc: Create an Ingress for ArgoCD
# echo "${BLUE}Creating an Ingress for ArgoCD${NC}"
#  kubectl apply -f ../confs/ingress.yaml -n argocd

# Port forward ArgoCD
echo "${BLUE}Creating an Ingress for ArgoCD${NC}"

# kubectl config use-context lelhlami

# Wait for argocd pods to start
echo "waiting for argocd pods to start.."
echo "${GREEN}This may take a while${NC}"
kubectl wait --for=condition=Ready pods --all --timeout=69420s -n argocd
kubectl wait --for=condition=Ready pods --all --timeout=69420s -n dev

# retrieving password
password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# print informations
printf "${GREEN}[ARGOCD]${NC} - Retrieving credentials...\n"

echo "Login: admin, password: ${GREEN}$password"

#  kubectl port-forward svc/argocd-server -n argocd 8080:80
#  kubectl port-forward svc/argocd-server -n argocd 8080:443 --address="0.0.0.0" 2>&1 > /var/log/argocd-log &
kubectl port-forward svc/argocd-server -n argocd 8080:80 --address="0.0.0.0" >/dev/null 2>&1 &
printf "${GREEN}[ARGOCD]${NC} - ArgoCD is running on http://localhost:8080\n"

#  lsof -i:8888 -t |  xargs kill -9
kubectl port-forward services/iot-svc 8888 -n dev --address="0.0.0.0" >/dev/null 2>&1 &
printf "${GREEN}[DEV]${NC} - IoT service is running on http://localhost:8888\n"

# while true; do
#     #   echo "waiting for dev pods to start..."
#       echo "${GREEN}waiting for dev pods to start...${NC}"
#        kubectl wait --for=condition=Ready pods --all --timeout=6969s -n dev  2>&1 > /dev/null &
#     # if port 8888 is already in use, remove the process
#     if [ -n "$( lsof -i:8888 -t)" ]; then
#          lsof -i:8888 -t |  xargs kill -9
#          kubectl port-forward services/iot-svc 8888 -n dev --address="0.0.0.0" > /dev/null 2>&1 &
#     fi
#     sleep 10  # Add a small delay to prevent excessive CPU usage
# done &
