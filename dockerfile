# Stage 1: Build stage
FROM maven:3.8.4-openjdk-11-slim AS build-stage

# Work directory
WORKDIR /app

# Copy pom file to working directory
COPY pom.xml ./

# Download the dependencies needed for the build (cache them in a separate layer)
RUN mvn dependency:go-offline

# Copy source files
COPY src ./src

# Run mvn package
RUN mvn package

# Stage 2: Production stage
FROM tomcat:8.5.78-jdk11-openjdk-slim

# Copy build to webapps folder
COPY --from=build-stage /app/target/*.war /usr/local/tomcat/webapps/

# Expose port
EXPOSE 8080

# Start tomcat
CMD ["catalina.sh", "run"]
