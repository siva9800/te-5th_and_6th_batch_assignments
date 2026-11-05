<img width="2396" height="1644" alt="image" src="https://github.com/user-attachments/assets/d0ced3ea-6025-447e-a8e0-2603b7ac4cdb" /># Docker Module – Foundational Capstone Project 1

## Deploy the App to the Cloud

## Project Overview

This project demonstrates the deployment of a 3-tier application consisting of a React frontend, FastAPI backend, and PostgreSQL database on an AWS EC2 instance using Docker and Docker Compose.

The application (Relentless Tracker, a product inventory manager) is containerized using Docker and deployed on an AWS EC2 Linux instance. Docker Compose is used to manage and run all the application services together.

## Objective

* Containerize the React frontend.
* Containerize the FastAPI backend.
* Deploy a PostgreSQL database.
* Deploy the complete application on AWS EC2.
* Manage all services using Docker Compose.
* Persist database data using a named Docker volume.

## Technologies Used

* AWS EC2 (Amazon Linux 2023, t3.micro)
* Docker
* Docker Compose
* React
* Nginx
* FastAPI
* PostgreSQL
* Git

## Application Architecture

```
              User
                │
                ▼
   React Frontend (Nginx, port 80)
                │  /api
                ▼
      FastAPI Backend
                │
                ▼
     PostgreSQL Database
```

Only the frontend is exposed on the EC2 host (port 80). The backend and the database run on the internal Docker network.

## Project Structure

```
Docker-Project-1/
│
├── backend/
│
├── frontend/
│
├── docker-compose.yaml
│
├── db.env
│
├── Project-Document.pdf
│
└── README.md
```

## AWS EC2 Configuration

| Setting          | Value                               |
|------------------|-------------------------------------|
| Instance Name    | Docker-Project-1                    |
| Instance Type    | t3.micro (Free Tier eligible)       |
| Operating System | Amazon Linux 2023                   |
| Region           | Asia Pacific (Mumbai) – ap-south-1  |

Security group inbound rules:

| Type | Port | Source                    |
|------|------|---------------------------|
| SSH  | 22   | My IP only (`x.x.x.x/32`) |
| HTTP | 80   | 0.0.0.0/0                 |

## Implementation Steps and Commands

### Step 1: Connect to AWS EC2 Instance

```
ssh -i Docker.pem ec2-user@<EC2-PUBLIC-IP>
```

### Step 2: Update EC2 Packages

```
sudo dnf update -y
```

### Step 3: Install Docker

```
sudo dnf install docker -y
```

### Step 4: Enable Docker

```
sudo systemctl enable docker
```

### Step 5: Start Docker

```
sudo systemctl start docker
```

Allow `ec2-user` to run Docker without `sudo` (log out and log in again afterwards):

```
sudo usermod -aG docker ec2-user
```

### Step 6: Install Docker Compose Plugin

```
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```

### Step 7: Verify Docker Installation

```
docker --version
docker compose version
sudo systemctl status docker --no-pager
```

### Step 8: Clone the Project Repository

```
sudo dnf install git -y
git clone https://github.com/pavankalyan77377-afk/te-5th_and_6th_batch_assignments.git
```

Move to the project directory:

```
cd te-5th_and_6th_batch_assignments/Pavankalyan/Docker_Project-1
```

### Step 9: Create the Environment Files

`db.env` and `backend/.env` contain credentials and are not committed to Git. Create them on the server with your own values (variable names must match what the backend reads):

```
# db.env
POSTGRES_USER=<db-user>
POSTGRES_PASSWORD=<db-password>
POSTGRES_DB=<db-name>
```

### Step 10: Build and Start the Application

```
docker compose up --build -d
```

### Step 11: Verify Running Containers

```
docker compose ps
```

### Step 12: Access the Application

* Frontend: `http://<EC2-PUBLIC-IP>`
* Backend API docs: `http://<EC2-PUBLIC-IP>/api/docs`

### Step 13: Verify Database Persistence

```
docker compose down
docker volume ls
docker compose up -d
```

The previously stored products are still available after the restart, because PostgreSQL data is stored in the named volume `pgdata`.

### Step 14: Stop the Application

```
docker compose down
```

> Do not use `docker compose down -v` unless you want to delete the database data.

## Verification Commands

Check Docker version:

```
docker --version
```

Check Docker Compose version:

```
docker compose version
```

Check running containers:

```
docker compose ps
```

Check Docker images:

```
docker images
```

Check Docker volumes:

```
docker volume ls
```

View service logs:

```
docker compose logs -f backend
```

## Deployment Result

The 3-tier application was successfully deployed on an AWS EC2 instance using Docker and Docker Compose.

The following services are running successfully:

* React Frontend
* FastAPI Backend
* PostgreSQL Database

The application can be accessed using the EC2 Public IP address after successful deployment. Screenshots of each step are available in `Project-Document.pdf`.

## Conclusion

This project successfully demonstrates the deployment of a containerized 3-tier application on an AWS EC2 instance using Docker and Docker Compose. The frontend, backend, and PostgreSQL database were deployed as separate containers, making the application portable, scalable, and easy to manage.
