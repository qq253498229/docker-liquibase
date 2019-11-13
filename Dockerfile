FROM openjdk:8-jre-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk update && apk add bash
# 安装liquibase
WORKDIR /app
ENV VERSION=3.8.1
RUN wget https://github.com/liquibase/liquibase/releases/download/v$VERSION/liquibase-$VERSION.tar.gz
RUN mkdir liquibase
RUN tar zxvf liquibase-$VERSION.tar.gz -C liquibase
RUN ln -snf /app/liquibase/liquibase /usr/local/bin/liquibase
# 调整时区
RUN apk add tzdata
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# 开ssh
RUN apk add openssh
VOLUME ["/sys/fs/cgroup"]
RUN echo 'PermitRootLogin yes' >>/etc/ssh/sshd_config
RUN ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
    echo "root:admin" | chpasswd
# 清除apk缓存
RUN rm -rf /var/cache/apk/*
CMD ["/usr/sbin/sshd","-D"]