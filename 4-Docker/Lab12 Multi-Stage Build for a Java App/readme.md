# Multi-Stage Build for a Node.js App

This guide walks you through the process of creating a multi-stage build for a Node.js application using Docker.

## Prerequisites
- Docker installed on your system.
- Git installed to clone the repository.

## Steps

### 1. Clone the Application Code
Clone the repository from the following link:
```
https://github.com/Ibrahim-Adel15/Docker-1.git
```

### 2. Write Dockerfile with Multi-stage
Create a `Dockerfile` with the following content:
- Use Maven base image for the first stage.
- Copy the application code into the container.
- Build the app using `mvn package`.
- Use Java base image for the second stage.
- Copy JAR file from the first stage.
- Expose port 8080.
- Run the application.
```Dockerfile
# ===== Stage 1: Build =====
FROM maven:3.9.10-eclipse-temurin-17-alpine AS build

WORKDIR /app

COPY . .

RUN mvn package

# ===== Stage 2: Run =====
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

```

### 3. Build Docker Image
Build the Docker image using the following command:
```
docker build -t multistage-app .
```

### 4. Run the Container
Run the container with the following command:
```
docker run -p 8080:8080 multistage-app
```

### 5. Test the Application
Open a browser or use a tool like `curl` to test the application at `http://localhost:8080`.

### 6. Stop and Delete the Container
Stop the running container with:
```
docker stop <container_id>
```
Delete the container with:
```
docker rm <container_id>
```

## Notes
- Ensure the application builds successfully before creating the Docker image.
- Adjust the port mapping (`-p 8080:8080`) if port 8080 is already in use.