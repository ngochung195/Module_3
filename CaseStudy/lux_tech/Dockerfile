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

# Copy WAR file from builder as ROOT application
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Set default port
ENV PORT=8080
EXPOSE 8080

# Configure dynamic port binding for Render ($PORT) with fallback to 8080, then start Tomcat
CMD ["sh", "-c", "sed -i \"s/8080/${PORT:-8080}/g\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
