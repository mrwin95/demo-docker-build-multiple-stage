FROM maven:3.8.6-openjdk-18 AS build

ARG ARG_JAR_FILE=target/*.jar
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:18-jre-jammy
WORKDIR /app

COPY --from=build /app/${ARG_JAR_FILE} app.jar
EXPOSE 9092
ENTRYPOINT ["java", "-XX:UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]