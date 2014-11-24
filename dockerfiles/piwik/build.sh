#!/bin/bash

wsd_piwik_password_database=${1}; # $1 : password database
wsd_project_domain=${2}; # domain

# Piwik
mkdir -p /var/www
cd /var/www/ && wget http://builds.piwik.org/piwik.zip
cd /var/www/ && unzip piwik.zip && rm -f piwik.zip
chown -R www-data:www-data /var/www

# Base de donnée
service mysql start;
mysqlcheck --repair --all-databases;
mysql -uroot -e "CREATE DATABASE piwikDataBase";
mysql -uroot -e "CREATE USER 'piwikUser'@'localhost' IDENTIFIED BY '${wsd_piwik_password_database}'";
mysql -uroot -e "GRANT ALL PRIVILEGES ON  piwikDataBase.* TO 'piwikUser'@'localhost'";
mysql -uroot -e "FLUSH PRIVILEGES";

# NGINX
service nginx stop;
lsof -i tcp:80;
rm -f /etc/nginx/sites-enabled/default;
mkdir -p /etc/nginx/sites-enabled;
touch /etc/nginx/sites-enabled/piwik;
cat >/etc/nginx/sites-enabled/piwik <<EOL
server {
   ## This is to avoid the spurious if for sub-domain name
   ## rewriting. See http://wiki.nginx.org/Pitfalls#Server_Name.
   #listen [::]:80;
   #server_name www.piwik.${wsd_project_domain};
   #rewrite ^ $scheme://piwik.${wsd_project_domain}$request_uri? permanent;
}

server {
    listen 80;
    listen [::]:80 ipv6only=on;
    server_name piwik.${wsd_project_domain};

    # Parameterization using hostname of access and log filenames.
    access_log  /var/log/nginx/piwik.${wsd_project_domain}_access.log;
    error_log   /var/log/nginx/piwik.${wsd_project_domain}_error.log;

    # Disable all methods besides HEAD, GET and POST.
    #if ($request_method !~ ^(GET|HEAD|POST)$ ) {
    #    return 444;
    #}

    root  /var/www/piwik/;
    index  index.php index.html;

    # Disallow any usage of piwik assets if referer is non valid.
    location ~* ^.+\.(?:jpg|png|css|gif|jpeg|js|swf)$ {
         # Defining the valid referers.
         #valid_referers none blocked *.mysite.com othersite.com;
         #if ($invalid_referer)  {
         #   return 444;
         #}
         expires max;
         break;
    }

    # Support for favicon. Return a 204 (No Content) if the favicon
    # doesn't exist.
    location = /favicon.ico {
         try_files /favicon.ico =204;
    }

    # Try all locations and relay to index.php as a fallback.
    #location / {
         #try_files $uri /index.php;
    #}

    # Relay all index.php requests to fastcgi.
    location ~* ^/(?:index|piwik)\.php$ {
        fastcgi_pass unix:/tmp/php-cgi/php-cgi.socket;
    }

    # Any other attempt to access PHP files returns a 404.
    location ~* ^.+\.php$ {
          return 404;
    }

    # Return a 404 for all text files.
    location ~* ^/(?:README|LICENSE[^.]*|LEGALNOTICE)(?:\.txt)*$ {
         return 404;
    }

    # # The 404 is signaled through a static page.
	# error_page  404  /404.html;

    # ## All server error pages go to 50x.html at the document root.
	# error_page 500 502 503 504  /50x.html;
	# location = /50x.html {
	# 	root   /var/www/nginx-default;
	# }
} # server
EOL