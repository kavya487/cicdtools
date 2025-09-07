#!/bin/bash
set -eux

# Resize partition
growpart /dev/xvda 4

# Resize physical volume
pvresize /dev/xvda4

# Extend logical volumes
lvextend -L +10G /dev/mapper/RootVG-homeVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

# Resize filesystems
xfs_growfs /home
xfs_growfs /var/tmp
xfs_growfs /var

# Install Java
yum install java-17-openjdk -y

# Install Terraform
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install terraform

# Manage Node.js modules
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

yum install zip -y

# Install Docker
yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl

# Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install Maven
dnf install maven -y
