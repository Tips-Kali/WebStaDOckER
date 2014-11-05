FROM dockerfile/nodejs

MAINTAINER WilliamWolface <william@wolface.com>

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q ruby gem
RUN DEBIAN_FRONTEND=noninteractive gem install sass

# Install Bower & Grunt
RUN mkdir -p /app
ADD JOIN/runNode.sh /app/runNode.sh

# Define working directory.
WORKDIR /project

# Define default command.
CMD /bin/bash /app/runNode.sh $environment $action

# Expose ports.
EXPOSE 8080