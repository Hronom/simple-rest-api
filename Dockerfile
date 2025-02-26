FROM public.ecr.aws/docker/library/maven:3.9.9-amazoncorretto-23-al2023 AS build
WORKDIR /code

COPY pom.xml pom.xml
RUN mvn dependency:resolve --batch-mode

COPY src src
RUN mvn clean package -DskipTests --batch-mode

FROM build AS tests

RUN mvn test --batch-mode

FROM public.ecr.aws/docker/library/maven:3.9.9-amazoncorretto-23-al2023 AS development

WORKDIR /simple-rest-api

# Install development dependencies
RUN yum install -y git

ENTRYPOINT []
CMD []

FROM public.ecr.aws/amazoncorretto/amazoncorretto:23.0.1-al2023 AS application

COPY --from=build /code/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]
