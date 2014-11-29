FROM maxexcloo/nginx-php:latest

MAINTAINER Max Schaefer <max@excloo.com>

ENV VERSION 5.1

RUN mkdir -p /data/http
RUN mkdir -p /data/http/conf/config.inc.php

WORKDIR /data/http

RUN wget -O - "http://www.sourceforge.net/projects/phppgadmin/files/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-${VERSION}/phpPgAdmin-${VERSION}.tar.gz/download" | tar --strip-components=1 -x -z
RUN rm -rf conf/config.inc.php-dist CREDITS DEVELOPERS FAQ HISTORY INSTALL TODO TRANSLATORS

ADD require/http/conf/config.inc.php /data/http/conf/config.inc.php