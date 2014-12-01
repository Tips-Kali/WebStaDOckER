FROM debian:jessie

MAINTAINER WilliamWolface <william@wolface.com>

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
    wget openssh-server postfix

# Gitlab
RUN wget https://downloads-packages.s3.amazonaws.com/debian-7.6/gitlab_7.5.1-omnibus.5.2.0.ci-1_amd64.deb -O gitlab.deb
RUN dpkg -i gitlab.deb

EXPOSE 80