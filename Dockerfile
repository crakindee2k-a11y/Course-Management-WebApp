FROM maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY students_to_import.csv ./students_to_import.csv

RUN mvn -B -DskipTests clean package

FROM tomcat:9.0-jdk11-temurin

ENV CATALINA_OPTS="-Djava.awt.headless=true"

COPY --from=build /app/target/course-management-system-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
