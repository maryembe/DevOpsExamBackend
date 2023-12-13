FROM maven:3.8.3-openjdk-17-slim AS builder
# Définition du répertoire de travail dans le conteneur 
WORKDIR /app
COPY pom.xml /app/
COPY src /app/src
RUN --mount=type=cache,target=/root/.m2 mvn -f /app/pom.xml clean package -DskipTests

#Run Stage 
FROM openjdk:17-alpine
# Copie des fichiers résultant dans le conteneur
COPY --from=builder /app/target/spring-boot-data-jpa-0.0.1-SNAPSHOT.jar app.jar
# Exposition du port utilisé par l'application
EXPOSE 8080
# Commande pour exécuter l'application Spring Boot lorsque le conteneur démarre
ENTRYPOINT ["java", "-jar", "app.jar"]