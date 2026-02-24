# -----------------------------
# Stage 1 - Build using Maven
# -----------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS builder

# Set working directory
WORKDIR /app

# Copy Maven configuration and source code
COPY pom.xml .
COPY src ./src

# Build WAR file (skip tests for faster build)
RUN mvn clean package -DskipTests

# -----------------------------
# Stage 2 - Run in Tomcat
# -----------------------------
FROM tomcat:9.0

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR from builder stage and deploy as ROOT.war
COPY --from=builder /app/target/addressbook.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
