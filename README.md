# InnovateMart's EKS Dployment Project

**Retail Store Application Deployment on Amazon EKS**  

## 1. Introduction  
This repository contains the Infrastructure as Code (IaC), Kubernetes manifests, and CI/CD pipeline configuration for deploying InnovateMart’s new **retail-store-sample-app** to Amazon Elastic Kubernetes Service (EKS).  

The project demonstrates how to build a production-ready cloud foundation using **Terraform**, **EKS**, and **GitHub Actions CI/CD**, following DevOps best practices of **automation, scalability, and security**.  

---

## 2. Architecture Overview  
The deployment provisions and configures the following resources:  

- **Networking**  
  - A new **VPC** with both **public** and **private subnets**.  
  - Internet Gateway, NAT Gateway, and route tables for external access.  

- **EKS Cluster**  
  - Amazon **EKS cluster** provisioned using Terraform.  
  - Managed node groups for hosting the workloads.  
  - IAM roles and policies created following **least-privilege principles**.  

- **Application Deployment**  
  - The **retail-store-sample-app** deployed to the EKS cluster.  
  - Includes all microservices (UI, Catalog, Orders, Carts, etc.).  
  - Default in-cluster dependencies (MySQL, PostgreSQL, Redis, RabbitMQ, DynamoDB Local) deployed as pods.  

- **Networking & Load Balancing**  
  - The **UI service** exposed via an **internet-facing LoadBalancer**.  
  - Custom annotations added for health checks (`/actuator/health`) and subnet mapping.  

- **CI/CD Pipeline**  
  - GitHub Actions pipeline for Terraform automation.  
  - Workflow configured to:  
    - Run `terraform plan` on feature branches.  
    - Run `terraform apply` on merges to `main`.  
  - AWS credentials managed securely with GitHub Secrets.  

- **IAM Developer Access**  
  - A dedicated **read-only IAM user** created.  
  - User can view logs, describe pods, and check services without modifying infrastructure.  
  - `kubeconfig` instructions provided for developer access.  

---

## 3. Steps Implemented  

### 3.1 Infrastructure Setup (Terraform)  
1. Wrote Terraform configurations to provision:  
   - VPC with public and private subnets.  
   - Internet Gateway, NAT Gateway, route tables.  
   - Amazon EKS cluster and managed node groups.  
   - IAM roles and policies for cluster and worker nodes.  

2. Initialized and applied Terraform:  
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```  

3. Verified the cluster using:  
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   kubectl get nodes
   ```

---

### 3.2 Application Deployment (Kubernetes Manifests)  
1. Deployed all microservices from the `k8s/` directory using:  
   ```bash
   kubectl apply -f k8s/
   ```  

2. Configured the **UI Service** with LoadBalancer type and subnet annotations:  
   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: ui
     annotations:
       service.beta.kubernetes.io/aws-load-balancer-subnets: "subnet-00141b8b01a7585f0,subnet-06273c1ff77d2c9a4"
       service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: /actuator/health
   spec:
     type: LoadBalancer
     selector:
       app: ui
     ports:
       - port: 80
         targetPort: 8080
   ```  

3. Verified that the service received an external DNS via ELB:  
   ```bash
   kubectl get svc ui
   ```

---

### 3.3 IAM Developer Access  
1. Created a **read-only IAM user** in AWS Console.  
2. Attached **AmazonEKSReadOnlyAccess** and relevant IAM policies.  
3. Generated AWS credentials and provided instructions for developers:  
   ```bash
   aws configure
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   kubectl get pods --all-namespaces
   kubectl logs <pod_name>
   ```

---

### 3.4 CI/CD Pipeline (GitHub Actions)  
1. Created `.github/workflows/terraform.yml`.  
2. Configured workflow to:  
   - Run `terraform plan` on feature branch pushes.  
   - Run `terraform apply` on main branch merges.  
3. Stored AWS credentials securely in **GitHub Secrets**.  
4. Verified pipeline execution with successful runs on branch merges.  

---
![alt text](<Screenshot 2025-09-30 173702.png>)

## 4. Accessing the Application  
- Application UI is available at:  
  ```
  http://<loadbalancer-dns-name>
  ```
- url:  
  ```
  http://aabd4ae2515954471bcd2c904e947803-1371507698.eu-west-1.elb.amazonaws.com
  ```  
