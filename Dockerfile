FROM maven:3-eclipse-temurin-17 AS build
ARG JAR_FILE=target/*.jar
RUN mkdir /usr/src/project
COPY ./ /usr/src/project
#COPY mvnw /usr/src/project
#COPY mvnw.cmd /usr/src/project
#COPY .mvn /usr/src/project

COPY src /usr/src/project
WORKDIR /usr/src/project
RUN mvn package -DskipTests
RUN jar xf ${JAR_FILE}
RUN jdeps --ignore-missing-deps -q  \
    --recursive  \
    --multi-release 17  \
    --print-module-deps  \
    --class-path 'BOOT-INF/lib/*'  \
    ${JAR_FILE} > deps.info
RUN jlink \
    --add-modules $(cat deps.info) \
    --strip-debug \
    --compress 2 \
    --no-header-files \
    --no-man-pages \
    --output /myjre
FROM debian:bookworm-slim

ENV JAVA_HOME=/user/java/jdk17
ENV PATH=$JAVA_HOME/bin:$PATH
ARG JAR_FILE=target/*.jar
COPY --from=build /myjre $JAVA_HOME
RUN mkdir /project && \
    groupadd --system javauser && \
    useradd -g javauser javauser && \
    chown -R javauser:javauser /project
COPY --from=build /usr/src/project/${JAR_FILE} /project/app.jar
WORKDIR /project
USER javauser
ENTRYPOINT ["java" ,"-jar", "app.jar"]