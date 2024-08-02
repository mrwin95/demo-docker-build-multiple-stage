FROM maven:3.8.6-openjdk-18 AS build
#FROM maven:3.8.6-openjdk-17 AS build

ARG ARG_JAR_FILE=target/*.jar
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

#FROM eclipse-temurin:18-jre-jammy AS jlink
#FROM eclipse-temurin:18-jdk-jammy AS jlink
#FROM eclipse-temurin:17-jdk-jammy AS jlink
ARG ARG_JAR_FILE=target/*.jar
#WORKDIR /jlink

#COPY --from=build /app/${ARG_JAR_FILE} app.jar

# use jdeps to find all the modules required by the app
#RUN jdeps --print-module-deps --ignore-missing-deps app.jar > modules.txt

# create a custom JRE
RUN jar xf ${ARG_JAR_FILE}
RUN jdeps --ignore-missing-deps -q  \
    --recursive  \
    --multi-release 18  \
    --print-module-deps  \
    --class-path 'BOOT-INF/lib/*'  \
    ${ARG_JAR_FILE} > deps.info
RUN jlink \
    --add-modules $(cat deps.info) \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /custom-jre \

#RUN jlink \
#    --add-modules $(cat modules.txt) \
#    --strip-debug \
#    --no-header-files \
#    --no-man-pages \
#    --compress=2 \
#    --output /custom-jre
#FROM alpine:3.18.3
# Third stage: Create the final image using distroless
#FROM gcr.io/distroless/java18-debian11
FROM debian:bookworm-slim
# Install necessary packages
#RUN apk add --no-cache bash libc6-compat
#FROM eclipse-temurin:18-jre-jammy
ARG ARG_JAR_FILE=target/*.jar
WORKDIR /app
COPY --from=jlink /custom-jre /opt/custom-jre

COPY --from=build /app/${ARG_JAR_FILE} app.jar

#set java home
ENV JAVA_HOME=/opt/custom-jre
ENV PATH="${JAVA_HOME}/bin:${PATH}"

EXPOSE 9092
#ENTRYPOINT ["java", "-XX:UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]