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

# Fichier de configuration de Postgres
RUN rm -f /var/lib/postgresql/data/postgresql.conf && \
    cp /wsd_postgres/postgresql.conf /var/lib/postgresql/data/postgresql.conf # Todo : /var/lib/postgresql/data/postgresql.conf ne se copie pas !!!

# Creation des utilisateurs et de la base de donnée
RUN /bin/bash /wsd_postgres/create_database_modified.sh

# Certificat
#RUN touch /wsd_postgres/passphrase.txt && \
#    echo "ree8aeliijadeth5theiBahPh1uakaet" >> /wsd_postgres/passphrase.txt && \
#    openssl req -new -text -out /wsd_postgres/server.req -passout file:/wsd_postgres/passphrase.txt -subj "/C=/ST=/L=/O=/CN=WebStaDOckER" && \
#    openssl rsa -in /wsd_postgres/privkey.pem -out /wsd_postgres/server.key -passout file:/wsd_postgres/passphrase.txt && \
#    rm -f /wsd_postgres/privkey.pem && \
#    openssl req -x509 -in /wsd_postgres/server.req -text -key /wsd_postgres/server.key -out /wsd_postgres/server.crt -passout file:/wsd_postgres/passphrase.txt && \
#    chmod og-rwx /wsd_postgresudos/server.key;