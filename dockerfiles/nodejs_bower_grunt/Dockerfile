FROM dockerfile/nodejs

MAINTAINER WebStaDOckER <webstadocker@webstadocker.org>

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q ruby gem
RUN DEBIAN_FRONTEND=noninteractive gem install sass

# Install Bower & Grunt
RUN mkdir -p /app
RUN mkdir -p /wsd
ADD run.sh /wsd/run.sh

# Define working directory.
WORKDIR /project

# Define default command.
CMD /bin/bash /wsd/run.sh $environment $action

# Expose ports.
EXPOSE 8080