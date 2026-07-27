# Stage 1 - Build React app
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


# Stage 2 - Nginx
FROM nginx:alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /app/build /usr/share/nginx/html

RUN chown -R appuser:appgroup /usr/share/nginx/html

USER appuser

EXPOSE 80

CMD ["nginx","-g","daemon off;"]