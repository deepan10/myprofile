FROM java:8
LABEL maintainer="deepan0433@gmail.com"
LABEL version="1.0"

ARG APP_BINARY="profile*.jar"

RUN mkdir "/apps"

ADD ./target/${APP_BINARY} /apps/app_profile.jar

EXPOSE 9090

ENTRYPOINT ["java","-jar","/apps/app_profile.jar"]