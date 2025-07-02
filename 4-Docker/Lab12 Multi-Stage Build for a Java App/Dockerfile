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
