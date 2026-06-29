# GameTrackerProject-Infra

## Présentation

Ce dépôt contient toute l'**Infrastructure as Code (IaC)** nécessaire au déploiement de la plateforme **GameTracker** sur **Amazon Web Services (AWS)** à l'aide de **Terraform**.

L'objectif est de provisionner automatiquement une infrastructure cloud complète, sécurisée et proche d'un environnement de production.

---

## Infrastructure déployée

L'infrastructure comprend notamment :

* Un VPC réparti sur plusieurs Availability Zones
* Des subnets publics et privés
* Une Internet Gateway et une NAT Gateway
* Un Application Load Balancer (ALB)
* Des Auto Scaling Groups
* Des instances Amazon EC2
* Des conteneurs Docker
* Amazon ECR
* Amazon S3
* AWS Systems Manager Parameter Store
* AWS Secrets Manager
* Des rôles IAM et une authentification GitHub Actions via OIDC
* Une base de données MySQL conteneurisée avec stockage persistant sur EBS

---

## Structure du projet

```text
terraform/
├── network/
├── security/
├── registry/
├── storage/
├── secrets/
├── iam/
├── load_balancing/
└── compute/
```

Chaque module est responsable d'une partie spécifique de l'infrastructure afin de conserver un projet modulaire, maintenable et facilement extensible.

---

## Dépôts associés

### Backend

https://github.com/yoanlouvois/GameTrackerProject-Backend

API REST développée avec Spring Boot utilisant MySQL et Docker.

### Frontend

https://github.com/yoanlouvois/GameTrackerProject-Frontend

Application web Angular consommant les API REST du backend.

---


## Schéma de l'infrastructure

> Schéma de l'architecture à venir.
