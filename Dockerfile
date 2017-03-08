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

RUN adduser --system --no-create-home --uid 60000 filebeat
RUN mkdir /filebeat && chown filebeat /filebeat

WORKDIR /filebeat
USER filebeat

COPY filebeat.yml .

CMD [ "filebeat", "-e" ]
