FROM davidcaste/alpine-java-unlimited-jce:jdk8
MAINTAINER del xie

ENV ACTIVEMQ_CONFIG_DIR /opt/activemq/conf.tmp
ENV ACTIVEMQ_DATA_DIR /data/activemq

#默认的源地址替换
#RUN echo 'https://mirrors.aliyun.com/alpine/v3.4/main/' >> /etc/apk/repositories
#RUN echo 'https://mirrors.aliyun.com/alpine/v3.4/community/' >> /etc/apk/repositories

# Update distro and install some packages
RUN apk update && \
    apk upgrade --update && \
    apk add --no-cache py-nose py-pip vim curl supervisor logrotate tzdata && \
    mkdir /etc/supervisord.d && \
    mkdir -p /var/log/supervisor

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
        echo $TZ > /etc/timezone

#init config supervisor
COPY supervisord.conf /etc/supervisord.conf

# Install stompy
RUN pip install stomp.py

# Lauch app install
COPY assets/setup/ /app/setup/
RUN chmod +x /app/setup/install
RUN /app/setup/install


# Copy the app setting
COPY assets/entrypoint /app/
COPY assets/run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Expose all port
EXPOSE 8161
EXPOSE 61616
EXPOSE 5672
EXPOSE 61613
EXPOSE 1883
EXPOSE 61614

# Expose some folders
VOLUME ["/data/activemq"]
VOLUME ["/var/log/activemq"]
VOLUME ["/opt/activemq/conf"]

WORKDIR /opt/activemq

CMD ["/app/run.sh"]
