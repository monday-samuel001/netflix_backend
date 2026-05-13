FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# 1. Copy ONLY the configuration file first
COPY pom.xml ./

# 2. Download the libraries (Docker will freeze and cache this step)
RUN mvn dependency:go-offline

# 3. Copy source files ONLY after libraries are downloaded
COPY ./src /app/src

# 4. Build the application package
RUN mvn clean package -DskipTests

RUN ls -la /app/target
RUN cp /app/target/*.jar /app/app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
