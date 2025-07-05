# Build stage
FROM --platform=linux/amd64 maven:latest AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM --platform=linux/amd64 public.ecr.aws/amazoncorretto/amazoncorretto:21
WORKDIR /app
COPY --from=builder /app/target/demo-spring-llm-*.jar /app/app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]