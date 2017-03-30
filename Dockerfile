FROM debian:jessie

MAINTAINER nine.ch Engineering <engineering@nine.ch>

ENV FILEBEAT_VERSION=5.2.1 \
    FILEBEAT_SHA1=694fe12e56ebf8e4c4b11b590cfb46c662e7a3c1

RUN set -x && \
  apt-get update && \
  apt-get install -y wget && \
  wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /opt/filebeat.tar.gz && \
  cd /opt && \
  echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - && \
  tar xzvf filebeat.tar.gz && \
  cd filebeat-* && \
  cp filebeat /bin && \
  cd /opt && \
  rm -rf filebeat* && \
  apt-get purge -y wget && \
  apt-get autoremove -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /filebeat /filebeat/config /filebeat/data && \
    chmod a+w /filebeat/data

WORKDIR /filebeat

# using a sample config file
COPY filebeat.yml ./config/
RUN chmod 0400 config/filebeat.yml

CMD [ "filebeat", "-e", "-path.config", "/filebeat/config" ]
