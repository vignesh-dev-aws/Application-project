#!/bin/bash
set -e

echo "Updating system..."
sudo apt update -y

echo "Installing unzip..."
if ! command -v unzip &> /dev/null; then
  sudo apt install -y unzip
else
  echo "unzip already installed"
fi

echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
  sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker $USER
else
  echo "Docker already installed"
fi

echo "Installing AWS CLI..."
if ! command -v aws &> /dev/null; then
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  unzip -q awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
else
  echo "AWS CLI already installed"
fi

echo "Installing kubectl..."
if ! command -v kubectl &> /dev/null; then
  curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
  sudo install kubectl /usr/local/bin/kubectl
  rm kubectl
else
  echo "kubectl already installed"
fi

echo "Installing eksctl..."
if ! command -v eksctl &> /dev/null; then
  curl -sLO https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz
  tar -xzf eksctl_Linux_amd64.tar.gz
  sudo mv eksctl /usr/local/bin/
  rm eksctl_Linux_amd64.tar.gz
else
  echo "eksctl already installed"
fi

echo "Installing git..."
sudo apt install -y git

docker --version
aws --version
kubectl version --client
eksctl version
git --version
unzip -v | head -n 1

echo "Setup completed successfully!"
