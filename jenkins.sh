#!/bin/bash
set -eux

# Resize disk partition
growpart /dev/xvda 4

# Resize the physical volume for LVM
pvresize /dev/xvda4

# Extend logical volumes
lvextend -L +10G /dev/RootVG/rootVol
lvextend -L +10G /dev/mapper/RootVG-varVol
lvextend -l +100%FREE /dev/mapper/RootVG-varTmpVol

# Resize filesystems
xfs_growfs /
xfs_growfs /var/tmp
xfs_growfs /var

# Setup Jenkins repo and install Jenkins
curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum install fontconfig java-17-openjdk jenkins -y

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
