# Three-Tier Employee Application

A full-stack, cloud-native employee management system built with modern DevOps practices and deployed on AWS using Kubernetes orchestration.

## Project Overview

This project demonstrates a comprehensive enterprise-grade application architecture implementing the three-tier design pattern with modern cloud-native technologies. The application provides employee record management capabilities while showcasing best practices in infrastructure automation, containerization, security scanning, and observability.

## Architecture

### Three-Tier Design
- **Presentation Tier**: React.js frontend with Vite build system
- **Application Tier**: Node.js/Express.js REST API backend
- **Data Tier**: MongoDB database with persistent storage

### Technology Stack

#### Frontend
- **Framework**: React.js with Vite
- **Build Configuration**: Environment-specific builds with `VITE_API_URL`
- **Container**: Nginx-based serving with security hardening

#### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **API**: RESTful endpoints for employee record operations
- **Routes**: `/record` endpoint for CRUD operations

#### Database
- **Database**: MongoDB
- **Storage**: AWS EBS volumes via StatefulSets
- **Persistence**: Kubernetes Persistent Volume Claims

## Infrastructure & DevOps

### Cloud Infrastructure (AWS)
- **Compute**: Amazon EKS (Elastic Kubernetes Service)
- **Storage**: EBS CSI Driver for persistent volumes
- **Networking**: Application Load Balancer via Nginx Ingress Controller

### Infrastructure as Code
- **Terraform**: Automated AWS resource provisioning
  - EKS cluster configuration
  - EC2 worker nodes
  - S3 backend for state management
  - DynamoDB for state locking
- **Ansible**: Configuration management and dependency installation

### Container Orchestration
- **Platform**: Kubernetes on Amazon EKS
- **Ingress**: Nginx Ingress Controller v1.12.2
- **Storage**: EBS CSI Driver with custom storage classes
- **Security**: Non-root containers with capability management

### CI/CD Pipeline
- **Jenkins**: Pipeline orchestration
- **Git**: Source code management
- **Docker**: Container image building
- **SonarQube**: Static code analysis and quality gates
- **Trivy**: Container vulnerability scanning
- **ArgoCD**: GitOps-based continuous deployment

### Monitoring & Observability
- **Metrics**: Prometheus for data collection and alerting
- **Visualization**: Grafana dashboards for performance insights
- **Scope**: Application and infrastructure monitoring

## Deployment Architecture

### Kubernetes Resources
- **Deployments**: Application workload management
- **Services**: Internal service discovery and load balancing
- **ConfigMaps**: Environment-specific configuration
- **Secrets**: Sensitive data management
- **StatefulSets**: Database persistence with ordered deployment
- **Ingress**: External traffic routing with domain-based access

### Security Implementation
- **Container Security**: Non-privileged containers with dropped capabilities
- **Network Security**: Service mesh communication
- **Image Security**: Vulnerability scanning in CI pipeline
- **Access Control**: Kubernetes RBAC implementation

## Setup and Deployment Guide

### Prerequisites
- AWS Account with appropriate IAM permissions
- kubectl and eksctl installed
- Docker for local development

### Infrastructure Setup

1. **AWS Configuration**
   ```bash
   aws configure
   ```

2. **Install Required Tools**
   ```bash
   # Install eksctl
   curl -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" -o eksctl.tar.gz
   tar -xzf eksctl.tar.gz
   sudo mv eksctl /usr/local/bin
   
   # Install kubectl
   curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
   chmod +x ./kubectl
   sudo mv ./kubectl /usr/local/bin/kubectl
   ```

3. **EKS Cluster Access**
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name three-tier-project
   ```

4. **Install Nginx Ingress Controller**
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/cloud/deploy.yaml
   ```

5. **Setup EBS CSI Driver**
   - Create IAM policy for EBS access
   - Attach policy to worker node IAM role
   - Deploy EBS CSI Driver:
   ```bash
   kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.38"
   ```

6. **Apply Storage Configuration**
   ```bash
   kubectl apply -f ebs-storage-class.yaml
   ```

### Application Deployment

1. **Build Frontend Image**
   ```bash
   docker build \
     --build-arg VITE_API_URL=http://backend.santosh.website \
     -t santoshpalla27/3-tier:frontend-2 .
   ```

2. **Deploy Application Manifests**
   ```bash
   kubectl apply -f manifests/
   ```

## Key Features

### DevOps Excellence
- **Automated Infrastructure**: Complete infrastructure provisioning via Terraform
- **GitOps Deployment**: ArgoCD for declarative deployments
- **Quality Assurance**: Integrated code quality and security scanning
- **Monitoring**: Comprehensive observability stack

### Security Features
- **Container Hardening**: Non-root execution with minimal capabilities
- **Vulnerability Scanning**: Pre-deployment image security checks
- **Network Policies**: Controlled inter-service communication
- **Secrets Management**: Kubernetes-native secret handling

### Scalability & Reliability
- **Horizontal Scaling**: Kubernetes-native auto-scaling capabilities
- **High Availability**: Multi-node EKS cluster deployment
- **Persistent Storage**: Reliable data persistence with EBS volumes
- **Load Balancing**: Automatic traffic distribution

## Configuration Notes

### Environment Variables
- Frontend uses build-time environment variables via Vite
- Backend URL configuration: `VITE_API_URL=http://domain` (without `/record` suffix)
- API endpoints are hardcoded in frontend as `/record`

### Storage Configuration
- EBS CSI driver enables dynamic volume provisioning
- StatefulSets ensure ordered deployment and stable network identities
- Custom storage classes optimize performance for database workloads

## Monitoring Endpoints

- **Application**: Available via ingress at configured domain
- **Grafana**: Monitoring dashboards for application metrics
- **Prometheus**: Metrics collection and alerting interface

## Future Enhancements

- **Multi-environment support**: Dev/staging/production pipeline segregation
- **Advanced security**: Pod security policies and network policies
- **Backup strategies**: Automated database backup and disaster recovery
- **Performance optimization**: Caching layers and CDN integration

This project serves as a comprehensive reference implementation for modern cloud-native application development, showcasing industry best practices in DevOps, security, and scalability.
