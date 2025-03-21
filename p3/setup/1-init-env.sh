# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install docker
sudo apt update
sudo apt install docker.io

# Create a k3d cluster
sudo k3d cluster create lelhlami --port 8080:80@loadbalancer --port 8443:443@loadbalancer

# List k3d clusters
sudo k3d cluster list

# Download and install kubectl from the official Kubernetes release
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin

# Check the version of kubectl
kubectl version --client