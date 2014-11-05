FROM debian:jessie

MAINTAINER WilliamWolface <william@wolface.com>

# Install
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get autoremove -y -q
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q php5 php5-dev php5-cli php5-json php5-curl curl git wget

# PHP Extension: Zip
RUN pecl install zip
RUN echo "extension=zip.so" >> /usr/local/lib/php.ini

# Set environmental variables
ENV COMPOSER_HOME /root/composer

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Display Composer version information
RUN composer --version

# Set up the application directory.
VOLUME ["/app"]
WORKDIR /app

# Set up the command arguments
CMD ["-"]
ENTRYPOINT ["composer", "--ansi"]
