FROM jprjr/arch

MAINTAINER John Regan <john@jrjrtech.com>

# Variables d'environnement
ENV DEBIAN_FRONTEND noninteractive

RUN pacman -Syy --noconfirm --quiet > /dev/null
RUN pacman -S --noconfirm --quiet --needed php-fpm php-gd \
    php-mcrypt php-ldap php-sqlite php-pgsql php-pear \
    php-xcache >/dev/null 2>/dev/null

RUN sed -i 's/;extension=gd.so/extension=gd.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=iconv.so/extension=iconv.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=mcrypt.so/extension=mcrypt.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=pgsql.so/extension=pgsql.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=ldap.so/extension=ldap.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=openssl.so/extension=openssl.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=pdo_pgsql.so/extension=pdo_pgsql.so/g' /etc/php/php.ini
RUN sed -i 's/;extension=xcache.so/extension=xcache.so/g' /etc/php/conf.d/xcache.ini
RUN sed -i 's/open_basedir = /open_basedir = \/var\/www\/:/' /etc/php/php.ini
RUN sed -i '/^listen/c listen = 0.0.0.0:9000' /etc/php/php-fpm.conf

RUN paccache -rk0
RUN pacman -Scc --noconfirm

RUN touch /var/log/php-fpm.log
RUN chown -R http /var/log/php-fpm.log /run/php-fpm

USER http

EXPOSE 9000
VOLUME /var/www
ENTRYPOINT ["php-fpm","-F"]