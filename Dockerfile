FROM debian:jessie

MAINTAINER nine.ch Engineering <engineering@nine.ch>

ARG FILEBEAT_VERSION
ENV FILEBEAT_VERSION=${FILEBEAT_VERSION:-"5.3.0"}
ARG FILEBEAT_SHA1
ENV FILEBEAT_SHA1=${FILEBEAT_SHA1:-"c6f56d1a938889ec9f5db7caea266597f625fcc1"}

# update and install wget
RUN set -x && \
    apt-get update && \
    apt-get install -y wget && \
#install and configure filebeat
    mkdir /filebeat /filebeat/config /filebeat/data && \
    chmod a+w /filebeat/data && \
    wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /opt/filebeat.tar.gz && \
    cd /opt && \
    echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - && \
    tar xzvf filebeat.tar.gz && \
    cd filebeat-* && \
    cp filebeat /bin && \
    cp filebeat.template.json /filebeat && \
    mv module /filebeat && \
#clean up
    cd /opt && \
    rm -rf filebeat* && \
    apt-get purge -y wget && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /filebeat

# using a sample config file
COPY filebeat.yml ./config/
RUN chmod 0400 ./config/filebeat.yml

CMD [ "filebeat", "-e", "-path.config", "/filebeat/config" ]
