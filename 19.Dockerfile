# build multiple stage
FROM maven:3.9.0-eclipse-temurin-19 AS build

#set workdir

WORKDIR /app
# Copy pom file and down dependencies

COPY pom.xml ./
RUN mvn dependency:go-offline
#Copy source code and build the app
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2 Runtime stage
FROM openjdk:19-jdk-slim

# Set Workdir
WORKDIR /app

# Copy the jar fime from build stage
COPY --from=build /app/target/demo-docker-build-multiple-stage-0.0.1-SNAPSHOT.jar myapp.jar

# create a non-root user
RUN useradd -m springuser
USER springuser

EXPOSE 9092
# RUN APP
ENTRYPOINT ["java", "-jar", "myapp.jar"]

