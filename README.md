# 🎬 Movie Rater — Kubernetes & DevOps Project

## Project Overview

Movie Rater is a web application for managing and rating movies, built as a **containerized multi-service application deployed on Kubernetes**.

The main goal of this project was  to demonstrate **practical DevOps and Kubernetes skills**  including container orchestration, service networking, persistent storage, secrets management, TLS termination, ingress configuration, network policies, and horizontal autoscaling.

The entire environment can be deployed locally using **Kind (Kubernetes in Docker)**.

## Project structure

```
Movie-rater/
│
├── app/
│   ├── backend/
│   └── frontend/
│
├── k8s/
│   ├── backend/
│   ├── frontend/
│   ├── keycloak/
│   ├── postgres/
│   ├── redis/
│   ├── ingress.yaml
│   ├── namespace.yaml
│   └── network.yaml
│
├── docker-compose.yaml
└── run.sh
```

## Architecture

The application is composed of several independent Kubernetes workloads:

- **Frontend** — web interface for interacting with the application
- **Backend** — application API and business logic
- **PostgreSQL** — persistent relational database
- **Redis** — in-memory data store
- **Keycloak** — identity and access management
- **NGINX Ingress** — external traffic routing and HTTPS entry point

All components are deployed inside a dedicated `movie-rater` Kubernetes namespace.

```mermaid
graph TD
    User[User]

    User -->|HTTPS| Ingress[NGINX Ingress]

    Ingress -->|movie-rater.local| Frontend[Frontend]
    Ingress -->|API traffic| Backend[Backend]
    Ingress -->|auth.movie-rater.local| Keycloak[Keycloak]

    Frontend -->|API Requests| Backend

    Backend --> Backend_DB[(Backend DB)]
    Backend --> Redis[(Redis)]

    Keycloak --> Keycloak_DB[(Keycloak DB)]
```

## Technologies

[![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)](https://react.dev/)
[![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![Kind](https://img.shields.io/badge/Kind-000000?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kind.sigs.k8s.io/)
[![NGINX](https://img.shields.io/badge/NGINX-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![Keycloak](https://img.shields.io/badge/Keycloak-4D4D4D?style=for-the-badge&logo=keycloak&logoColor=white)](https://www.keycloak.org/)
[![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)](https://jwt.io/)

## Quick start

To start the application please refer to the [instructions](./INSTRUCTIONS.md).