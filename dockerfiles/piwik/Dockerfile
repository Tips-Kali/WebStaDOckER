FROM debian:wheezy

MAINTAINER WebStaDOckER <webstadocker@webstadocker.org>

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    apt-utils debconf-utils dialog locales \
    php-apc libssh2-php php5-imap php5-mcrypt php5-gd php5-imagick \
    php5-fpm php5-mysql php5-cli php5-curl php5-memcached php5-geoip \
    mysql-server wget unzip nginx curl git

# Build & Run
RUN mkdir -p /wsd
ADD *.sh /wsd/
RUN chmod +x /wsd/*.sh

# Port
EXPOSE 80