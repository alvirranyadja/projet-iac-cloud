# Plateforme Cloud IaC — Terraform · Ansible · Kubernetes

Projet DevOps bout-en-bout : **provisionner** l’infrastructure AWS (Terraform), **configurer** les serveurs (Ansible), **orchestrer** l’application PayMyBuddy (Kubernetes).

Objectif : démontrer une chaîne proche de la production — Infrastructure as Code + configuration as code + orchestration.

## Architecture

```text
Terraform (AWS)
  └── EC2 Ubuntu + EBS + EIP + Security Group + Key Pair
        └── Jenkins (Docker Compose)  [option bootstrap]
Ansible
  └── Rôles : webapp Docker + Nginx reverse proxy
Kubernetes
  └── Deployments MySQL + PayMyBuddy
  └── Services ClusterIP (DB) + NodePort (app)
  └── Volume pour données persistantes
```

## Structure

```text
projet-iac-cloud/
├── terraform/          # Modules AWS + app Jenkins
│   ├── modules/
│   │   ├── ec2/
│   │   ├── ebs/
│   │   ├── eip/
│   │   ├── security_group/
│   │   └── keypair/
│   └── app/
├── ansible/            # Playbooks & rôles Nginx / webapp
│   ├── inventories/
│   ├── playbooks/
│   └── roles/
├── kubernetes/           # Manifests PayMyBuddy + MySQL
│   ├── namespace.yaml
│   ├── mysql-deployment.yaml
│   ├── mysql-service.yaml
│   ├── paymybuddy-deployment.yaml
│   └── paymybuddy-service.yaml
└── README.md
```

## Prérequis

- Terraform >= 1.5
- Ansible >= 2.14
- kubectl + cluster (minikube / kind / EKS)
- Compte AWS + AWS CLI configuré
- Docker

## 1. Terraform — provisionner Jenkins sur AWS

```bash
cd terraform/app
terraform init
terraform plan
terraform apply
# outputs → jenkins_ec2.txt (IP publique)
```

Modules :
- EC2 Ubuntu Jammy (taille / tags variables)
- Volume EBS attaché
- Elastic IP
- Security Group (ports 22, 80, 443, 8080)
- Key pair dynamique

## 2. Ansible — configurer Nginx + webapp Docker

```bash
cd ansible
ansible-playbook -i inventories/hosts.ini playbooks/nginx_webapp.yml
```

## 3. Kubernetes — déployer PayMyBuddy

```bash
kubectl apply -f kubernetes/
kubectl get pods,svc -n paymybuddy
```

## Bonnes pratiques couvertes

- Modules Terraform réutilisables et variables
- Séparation inventaire / rôles Ansible
- Manifests K8s explicites (sans Helm) pour maîtriser Deployments / Services / Volumes
- Séparation des environnements et documentation d’exploitation

## Auteur

Michelle Alvirra Nyadja Kamwa — [GitHub](https://github.com/alvirranyadja)
