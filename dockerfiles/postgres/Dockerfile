FROM postgres:9.4

MAINTAINER Mike Dillon <mike@embody.org>

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive

ENV POSTGIS_MAJOR 2.1
ENV POSTGIS_VERSION 2.1.4+dfsg-1.pgdg70+3

RUN echo deb http://http.debian.net/debian wheezy-backports main >> /etc/apt/sources.list

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION postgis=$POSTGIS_VERSION openssl
RUN rm -rf /var/lib/apt/lists/*

# Scripts qui s'éxécutent au démarrage
RUN mkdir -p /docker-entrypoint-initdb.d
ADD require/prepare.sh /docker-entrypoint-initdb.d/

# Build & Run
RUN mkdir -p /wsd
ADD *.sh /wsd/
ADD require/* /wsd/
RUN chmod +x /wsd/*.sh

# Certs
RUN mkdir -p /wsd/certs