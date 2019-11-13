FROM openjdk:8-jre-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add bash
WORKDIR /app
ENV VERSION=3.8.1
RUN wget https://github.com/liquibase/liquibase/releases/download/v$VERSION/liquibase-$VERSION.tar.gz
RUN mkdir liquibase
RUN tar zxvf liquibase-$VERSION.tar.gz -C liquibase
RUN ln -snf /app/liquibase/liquibase /usr/local/bin/liquibase