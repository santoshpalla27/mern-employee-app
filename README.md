
# Three-Tier Employee Application

## Overview
The Three-Tier Employee Application is built using the MERN (MongoDB, Express.js, React.js, Node.js) stack. It is designed as a scalable and reliable solution, leveraging modern DevOps practices and cloud-native tools for infrastructure provisioning, deployment, and monitoring.

---

## Architecture
The application architecture is based on a three-tier model:

1. **Presentation Layer:** React.js front-end for user interaction.
2. **Logic Layer:** Express.js and Node.js back-end for handling business logic and API endpoints.
3. **Data Layer:** MongoDB database for storing employee records and related data.

---

## Infrastructure Provisioning

### Terraform

Infrastructure provisioning is automated using **Terraform**, with the following components:

- **State Management:**
  - Backend: Amazon S3 (Simple Storage Service)
  - State Locking: DynamoDB for concurrency control

- **AWS Resources Provisioned:**
  - Amazon EKS (Elastic Kubernetes Service) cluster
  - EC2 instances for worker nodes and additional services

### Configuration Management

**Ansible** is used to automate the installation of dependencies and configuration of provisioned resources.

---

## Application Deployment

### Kubernetes
Application manifests are created using Kubernetes YAML definitions for:

- Deployments
- Services
- ConfigMaps
- Secrets
- Persistent Volumes and Claims

The application is deployed to the EKS cluster using these manifests.

---

## CI/CD Pipeline

**Jenkins** is used to implement the CI/CD pipeline, integrating the following tools:

1. **SonarQube** for code quality and static analysis.
2. **Trivy** for container image vulnerability scanning.
3. **Git** for version control and repository management.
4. **Docker** for building containerized applications.
5. **ArgoCD** for continuous deployment to Kubernetes.

---

## Monitoring and Observability

**Prometheus** and **Grafana** are utilized for application and infrastructure monitoring:

- **Prometheus:** Metrics collection and alerting.
- **Grafana:** Visualization of metrics with custom dashboards for performance insights.

---

## Key Features

- Fully automated infrastructure provisioning and configuration.
- Secure and scalable Kubernetes-based deployment.
- End-to-end CI/CD pipeline ensuring quality and security.
- Comprehensive monitoring and observability.
- Cloud-native architecture leveraging AWS services.

---

## Tools and Technologies

### Frontend
- React.js

### Backend
- Node.js
- Express.js

### Database
- MongoDB

### Infrastructure & Automation
- Terraform
- Ansible

### Deployment & Orchestration
- Kubernetes
- Amazon EKS
- Docker

### CI/CD
- Jenkins
- SonarQube
- Trivy
- ArgoCD
- Git

### Monitoring
- Prometheus
- Grafana
---

This documentation serves as a detailed reference for the architecture, infrastructure, deployment, and tools used in the development and maintenance of the Three-Tier Employee Application.


docker build \
  --build-arg VITE_API_URL=http://backend.santosh.website \
  -t santoshpalla27/3-tier:frontend-2 .

since the env varible is available at built time not run time we should build the env in the dockerfile



in this app the backend is available on http://domain/record .this will be vite app url but 

but scince frontend has /record hardcoded then the backend url for frontend will be http://domain

 if(!id) return;
      setIsNew(false);
      const response = await fetch(
        `${import.meta.env.VITE_API_URL}/record/${params.id.toString()}`
      );



open a instance 

1:- aws configure in the instance 

2:-and install kubectl and eksctl 

curl -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" -o eksctl.tar.gz
tar -xzf eksctl.tar.gz
sudo mv eksctl /usr/local/bin
eksctl version

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

3:- update the kubeconfig 

aws eks update-kubeconfig --region us-east-1 --name three-tier-project

4:- install nginx ingress controller

 kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/cloud/deploy.yaml

🔸 You can replace v1.10.1 with the latest version available: https://github.com/kubernetes/ingress-nginx/releases

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx
kubectl get ingress --all-namespaces  -- to verify 


5:- install ebs csi driver

ebs with statefulset

 Create IAM policyy
Go to Services -> IAM
Create a Policy
Select JSON tab and copy paste the below JSON

{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume"
      ],
      "Resource": "*"
    }
  ]
}
Review the same in Visual Editor

Click on next
Name: Amazon_EBS_CSI_Driver
Description: Policy for EC2 Instances to access Elastic Block Store
Click on Create Policy

Step-03: Get the IAM role Worker Nodes using and Associate this policy to that role

# Get Worker node IAM Role ARN

kubectl -n kube-system describe configmap aws-auth

# from output check relearn

rolearn: arn:aws:iam::180789647333:role/eksctl-eksdemo1-nodegroup-eksdemo-NodeInstanceRole-IJN07ZKXAWNN


- Go to Services -> IAM -> Roles - Search for role with name eksctl-eksdemo1-nodegroup and open it - Click on Permissions tab - Click on Attach Policies - Search for Amazon_EBS_CSI_Driver and click on Attach Policy

or you can also include pre existing policy ebs csi driver


Step-04: Deploy Amazon EBS CSI Driver
Verify kubectl version, it should be 1.14 or later

kubectl version --client --short


Deploy Amazon EBS CSI Driver

# Deploy EBS CSI Driver
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

use this if up dont work
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.38" 

# Verify ebs-csi pods running
kubectl get pods -n kube-system


5:- kubectl apply -f ebs-storage-class.yaml 


6:- apply all the manifests


use ports above 1024 in alphine images as it doesnt have - NET_BIND_SERVICE capability

use nginx:1.25 or non-alphine images to map port 80 

securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
    add:
      - NET_BIND_SERVICE
  privileged: false
  readOnlyRootFilesystem: true

used in frontend manifest to bind port 80 

In Kubernetes (and Linux containers in general), non-root processes cannot bind to ports below 1024 unless they have the CAP_NET_BIND_SERVICE capability.