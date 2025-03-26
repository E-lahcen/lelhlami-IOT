# Define color codes for output messages
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Create an alias for the kubectl command to simplify usage
alias k=kubectl

# Check if the "dev" namespace exists; if not, create it and apply the deployment configuration
if [ -z "$(sudo kubectl get namespace dev)" ]; then
    echo "${BLUE}Creating namespace DEV${NC}"
    sudo kubectl create namespace dev # Create the "dev" namespace
    sudo kubectl apply -f ../confs/deployment.yaml -n dev # Apply the deployment configuration to the "dev" namespace
else
    echo "${GREEN}The namespace dev already exists${NC}" # Notify that the namespace already exists
fi

# Check if the "argocd" namespace exists; if not, create it and apply the ArgoCD installation and app configuration
if [ -z "$(sudo kubectl get namespace argocd)" ]; then
    echo "${BLUE}Creating namespace for ArgoCD${NC}"
    sudo kubectl create namespace argocd # Create the "argocd" namespace
    sudo kubectl create -n argocd -f ../confs/install.yaml # Install ArgoCD in the "argocd" namespace
    sudo kubectl apply -f ../confs/app.yaml -n argocd # Apply the ArgoCD application configuration
else
    echo "${GREEN}The namespace argocd already exists${NC}" # Notify that the namespace already exists
fi

# Notify that an Ingress is being created for ArgoCD (though no actual Ingress creation command is present here)
echo "${BLUE}Creating an Ingress for ArgoCD${NC}"

# Set the Kubernetes context to "lelhlami" to ensure commands are executed in the correct cluster
sudo kubectl config use-context lelhlami

# Wait for all pods in the "argocd" and "dev" namespaces to be ready
echo "waiting for argocd pods to start.."
echo "${GREEN}This may take a while${NC}"
sudo kubectl wait --for=condition=Ready pods --all --timeout=69420s -n argocd # Wait for all pods in "argocd" to be ready
sudo kubectl wait --for=condition=Ready pods --all --timeout=69420s -n dev # Wait for all pods in "dev" to be ready

# Retrieve the initial admin password for ArgoCD from the Kubernetes secret
password=$(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

# Print the ArgoCD admin credentials
printf "${GREEN}[ARGOCD]${NC} - Retrieving credentials...\n"
echo "Login: admin, password: ${GREEN}$password"

# Forward port 8080 on localhost to the ArgoCD server service in the "argocd" namespace
sudo kubectl port-forward svc/argocd-server -n argocd 8080:80 --address="0.0.0.0" > /dev/null 2>&1 &
printf "${GREEN}[ARGOCD]${NC} - ArgoCD is running on http://localhost:8080\n"

# Forward port 8888 on localhost to the IoT service in the "dev" namespace
sudo kubectl port-forward services/iot-svc 8888 -n dev --address="0.0.0.0" > /dev/null 2>&1 &
printf "${GREEN}[DEV]${NC} - IoT service is running on http://localhost:8888\n"
