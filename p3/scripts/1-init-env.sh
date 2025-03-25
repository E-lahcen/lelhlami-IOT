#Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

# Install docker
if ! [ -x "$(command -v docker)" ]; then
    echo "${BLUE}Installing docker${NC}"
    apt update
    apt install docker.io
else
    echo "${GREEN}docker is already installed${NC}"
fi
# Install k3d
if ! [ -x "$(command -v k3d)" ]; then
    echo "${BLUE}Installing k3d${NC}"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "${GREEN}k3d is already installed${NC}"
fi

# Download and install kubectl from the official Kubernetes release
if ! [ -x "$(command -v kubectl)" ]; then
    echo "${BLUE}Downloading and installing kubectl${NC}"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check
    chmod +x kubectl
    mv ./kubectl /usr/local/bin
else
    echo "${GREEN}kubectl is already installed${NC}"
fi

# Create a k3d cluster
echo "${BLUE}Creating a k3d cluster${NC}"
#only create a new cluster if it does not exist
if [ -z "$(k3d cluster list | grep lelhlami)" ]; then
    k3d cluster create lelhlami --agents 2
    #  k3d cluster create lelhlami --port 8081:80@loadbalancer --port 8443:443@loadbalancer
else
    echo "${GREEN}The cluster already exists${NC}"
fi

# List k3d clusters
echo "${BLUE}Listing k3d clusters${NC}"
k3d cluster list

# Check the version of kubectl
echo "${BLUE}Checking the version of kubectl${NC}"
kubectl version --client
