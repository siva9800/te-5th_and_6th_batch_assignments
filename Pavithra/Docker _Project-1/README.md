# Docker Module – Foundational Capstone Project 1

# Deploy the App to the Cloud

## Project Overview

This project demonstrates the deployment of a 3-tier application consisting of a React frontend, FastAPI backend, and PostgreSQL database on an AWS EC2 instance using Docker and Docker Compose.

The application is containerized using Docker and deployed on an AWS EC2 Linux instance. Docker Compose is used to manage and run all the application services together.

---

## Objective

- Containerize the React frontend.
- Containerize the FastAPI backend.
- Deploy a PostgreSQL database.
- Deploy the complete application on AWS EC2.
- Manage all services using Docker Compose.

---

## Technologies Used

- AWS EC2
- Docker
- Docker Compose
- React
- FastAPI
- PostgreSQL
- Git

---

## Application Architecture

```text
              User
                │
                ▼
      React Frontend
                │
                ▼
      FastAPI Backend
                │
                ▼
     PostgreSQL Database
```

---

## Project Structure

```text
Docker_Project-1/
│
├── backend/
│
├── frontend/
│
├── docker-compose.yaml
│
├── db.env
│
└── README.md
```

---

## Implementation Steps and Commands

### Step 1: Connect to AWS EC2 Instance

```bash
ssh -i docker_project-1_key_pair.pem ec2-user@<EC2-PUBLIC-IP>
```

---

### Step 2: Update EC2 Packages

```bash
sudo dnf update -y
```

---

### Step 3: Install Docker

```bash
sudo dnf install docker -y
```

---

### Step 4: Enable Docker

```bash
sudo systemctl enable docker
```

---

### Step 5: Start Docker

```bash
sudo systemctl start docker
```

---

### Step 6: Install Docker Compose Plugin

```bash
sudo dnf install docker-compose-plugin -y
```

---

### Step 7: Verify Docker Installation

```bash
docker --version
docker compose version
```

---

### Step 8: Clone the Project Repository

```bash
git clone https://github.com/machhapavithra-2105/te-5th_and_6th_batch_assignments.git
```

Move to the project directory:

```bash
cd te-5th_and_6th_batch_assignments/Pavithra/"Docker _Project-1"
```

---

### Step 9: Build and Start the Application

```bash
docker compose up --build -d
```

---

### Step 10: Verify Running Containers

```bash
docker ps
```

---

### Step 11: Restart the Application

```bash
docker compose restart
```

---

### Step 12: Stop the Application

```bash
docker compose down
```

---

## Verification Commands

Check Docker version:

```bash
docker --version
```

Check Docker Compose version:

```bash
docker compose version
```

Check running containers:

```bash
docker ps
```

Check Docker images:

```bash
docker images
```

---

## Deployment Result

The 3-tier application was successfully deployed on an AWS EC2 instance using Docker and Docker Compose.

The following services are running successfully:

- React Frontend
- FastAPI Backend
- PostgreSQL Database

The application can be accessed using the EC2 Public IP address after successful deployment.

---


## Conclusion

This project successfully demonstrates the deployment of a containerized 3-tier application on an AWS EC2 instance using Docker and Docker Compose. The frontend, backend, and PostgreSQL database were deployed as separate containers, making the application portable, scalable, and easy to manage.