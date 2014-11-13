FROM postgres:9.4
MAINTAINER Mike Dillon <mike@embody.org>

ENV POSTGIS_MAJOR 2.1
ENV POSTGIS_VERSION 2.1.4+dfsg-1.pgdg70+3

RUN echo deb http://http.debian.net/debian wheezy-backports main >> /etc/apt/sources.list

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION postgis=$POSTGIS_VERSION openssl
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /wsd_postgres
COPY JOIN/data/* /wsd_postgres/

# Scripts qui s'éxécutent au démarrage
RUN mkdir -p /docker-entrypoint-initdb.d
COPY JOIN/docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/

RUN chown -R postgres:postgres /var/lib/postgresql/data
RUN chmod -R 0777 /var/lib/postgresql/data

RUN touch /var/lib/postgresql/data/postgresql.auto.conf

# Creation des utilisateurs et de la base de donnée
RUN /bin/bash /wsd_postgres/create_database_modified.sh