# ==========================================
# Stage 1: Build WAR with Maven & Java 17
# ==========================================
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build production WAR
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# Stage 2: Tomcat 10.1 Runtime with Java 17
# ==========================================
FROM tomcat:10.1-jdk17-temurin

# Clean up default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Disable Tomcat shutdown port (container termination is handled by OS signals)
# This prevents Render's port detection scanner from querying port 8005 instead of the HTTP port.
RUN sed -i 's/port="8005"/port="-1"/g' /usr/local/tomcat/conf/server.xml

# Copy WAR file from builder as ROOT application
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# JVM optimizations for container environment
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

# Set default port
ENV PORT=8080
EXPOSE 8080

# Configure dynamic port binding for Render ($PORT) with fallback to 8080, then start Tomcat
CMD ["sh", "-c", "sed -i \"s/8080/${PORT:-8080}/g\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
