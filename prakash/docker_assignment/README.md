# Docker Assignment

Containerized the FastAPI python-backend app using Docker.

- Built image: docker build -t python-backend .
- Ran container: docker run -d -p 8000:8000 --name pybackend python-backend
- Verified endpoints: / and /products/
- Inspected/debugged: docker logs, docker exec -it pybackend sh, docker inspect

App URL: https://fantastic-space-goggles-p77rqpvj7jrpc74v7-8000.app.github.dev
