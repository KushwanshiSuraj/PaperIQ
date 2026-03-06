# Use Tomcat with Java 11 as base image
FROM tomcat:9.0-jdk11-openjdk

# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Create ROOT directory
RUN mkdir -p /usr/local/tomcat/webapps/ROOT

# Copy your entire webapp folder to Tomcat's ROOT
COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# Copy JAR files to Tomcat's lib folder
COPY src/main/webapp/WEB-INF/lib/mysql-connector-j-8.0.33.jar /usr/local/tomcat/lib/
COPY src/main/webapp/WEB-INF/lib/itextpdf-5.5.13.3.jar /usr/local/tomcat/lib/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]