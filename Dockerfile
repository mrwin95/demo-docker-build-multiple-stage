# Stage 1: Development

#FROM maven:3-amazoncorretto-19 as development
FROM maven:3.8.3-openjdk-17-slim AS development
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean test

# Stage 2: Build
#FROM maven:3-amazoncorretto-19 as build
FROM maven:3.8.3-openjdk-17-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DSkipTests

# Stage 3: Production
#FROM openjdk:19-alpine as prod
FROM openjdk:17-jdk-slim AS prod
WORKDIR /app
COPY --from=build /app/target/demo-docker-build-multiple-stage-0.0.1-SNAPSHOT.jar /app/app.jar
EXPOSE 9092
CMD ["java", "-jar", "app.jar"]


