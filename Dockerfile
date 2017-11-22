FROM openjdk:8u131-jre-alpine

LABEL maintainer "renevo"

ARG CURSE_PROJECT="vanilla-forge"
ARG CURSE_PROJECT_VERSION="latest"

RUN apk add -U \
    openssl \
    bash \
    lsof \
    curl \
    wget \
    jq \
    python python-dev py2-pip \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /home/minecraft/pack/${CURSE_PROJECT}

RUN pip install mcstatus
HEALTHCHECK CMD mcstatus localhost ping

COPY ./download.sh /home/minecraft/download.sh
COPY ./run.sh /home/minecraft/run.sh
COPY ./log4j2.xml /home/minecraft/log4j2.xml

ENV MOTD="Curse Forge Mod Pack" \
    JVM_XX_OPTS="-XX:+UseG1GC" MEMORY="1G"

WORKDIR /home/minecraft

# Download Mod Pack Manifest
RUN /home/minecraft/download.sh

VOLUME ["/home/minecraft/backups", "/home/minecraft/world"]

EXPOSE 25565

ENTRYPOINT ["/home/minecraft/run.sh"]