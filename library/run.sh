#!/bin/sh

show "CREATION DES CONTAINERS";

# Suppression de tous les container ( remise à zéro )
sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q);

# Todo : limiter la conso RAM/CPU des container : https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting
# Todo : voir le démarrage automatique des containers : https://docs.docker.com/articles/host_integration/

# SkyDNS
sudo docker run \
    -d \
    -p 172.17.42.1:53:53/udp \
    --name skydns \
    crosbymichael/skydns \
    -nameserver 8.8.8.8:53 \
    -domain local.docker;

# SkyDOCK
sudo docker run \
    -d \
    -v /var/run/docker.sock:/docker.sock \
    --name skydock \
    crosbymichael/skydock \
    -ttl 30 \
    -environment dev \
    -s /docker.sock \
    -domain local.docker \
    -name skydns;

# PostgreSQL
sudo docker run \
    --name webstack_postgres_1 \
    -it \
    -v ${dockerDir}dockerfiles/postgres/LINK/data:/var/lib/postgresql/data:rw \
    --dns=172.17.42.1 \
    -d wsd_postgres;

# Configuration du DNS
dig @172.17.42.1 dev.local.docker;
#set -x SKYDNS "http://$(dig @172.17.42.1 +short dev.local.docker):8080";

if [[ ${wsd_action} == "install" ]]; then
    echo "Attend que Postgres se prépare...";
    sleep 30;

    # Après installation, première configuration de la base de donnée
    sudo docker exec \
        -it  \
        webstack_postgres_1  \
        /bin/bash /wsd_postgres/manually_modified.sh;
fi

# phpPgAdmin
sudo docker run \
    --name webstack_phppgadmin_1 \
    -p 3321:80 \
    --link webstack_postgres_1:postgresql \
    -e "VIRTUAL_HOST=phppgadmin.${wsd_project_domain}" \
    --dns=172.17.42.1 \
    -d maxexcloo/phppgadmin;

# Memcached
sudo docker run \
    --name webstack_memcached_1 \
    -p 11211:11211 \
    --dns=172.17.42.1 \
    -d wsd_memcached;

# Crée le container : Lancement de php-fpm sur le port 9000
sudo docker run \
    --name webstack_php_1 \
    -p 9000:9000 \
    -v ${dockerDir}dockerfiles/nginx/LINK/www:/var/www:rw \
    --dns=172.17.42.1 \
    -d wsd_phpfpm;

# Crée le container : Redirige le port TCP/80 de notre hôte vers le port TCP/80 du conteneur
sudo docker run \
    --name webstack_nginx_1 \
    -t \
    -i \
    -p 8080:80 \
    -v ${dockerDir}dockerfiles/nginx/LINK/www:/var/www:rw \
    -v ${dockerDir}dockerfiles/nginx/LINK/htpasswds/${wsd_project_name}:/etc/nginx/htpasswds:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/sites-enabled:/etc/nginx/sites-available:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/sites-enabled:/etc/nginx/sites-enabled:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/log:/var/log/nginx:rw \
    --dns=172.17.42.1 \
    -d wsd_nginx;

# Construit les vendors
sudo docker run \
    -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/app:rw \
    wsd_composer install; #--ignore-platform-reqs

# Bower & Grunt
if [[ ${wsd_action} == "install" ]]; then
    if [ ${wsd_project_environment} == "development" ]; then
        sudo docker run \
            --name webstack_nodejs_bower_grunt_1 \
            -i \
            -e "environment=development" \
            -e "action=install" \
            -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/project:rw \
            --dns=172.17.42.1 \
            -d wsd_nodejs_bower_grunt;
    else
        sudo docker run \
            -i \
            --rm \
            -e "environment=production" \
            -e "action=install" \
            -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/project:rw \
            wsd_nodejs_bower_grunt;
    fi
else
  if [ ${wsd_project_environment} == "development" ]; then
        sudo docker run \
            --name webstack_nodejs_bower_grunt_1 \
            -i \
            -e "environment=development" \
            -e "action=update" \
            -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/project:rw \
            --dns=172.17.42.1 \
            -d wsd_nodejs_bower_grunt;
    else
        sudo docker run \
            -i \
            --rm \
            -e "environment=production" \
            -e "action=update" \
            -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/project:rw \
            wsd_nodejs_bower_grunt;
    fi
fi

#Varnish
sudo docker run \
    --name webstack_varnish_1 \
    -v ${dockerDir}dockerfiles/varnish/LINK/default.vcl:/etc/varnish/default.vcl:ro \
    -p 80:80 \
    --dns=172.17.42.1 \
    -d jacksoncage/varnish;

# Confirmation de création des conteneurs
sudo docker ps;

# Résumé du réseau
echo "Utilisez ces HOSTNAMEs pour communiquer avec vos containers :";
echo "";
echo "phpPgAdmin : webstack_phppgadmin_1.phppgadmin.dev.local.docker";
echo "Postgres SQL : webstack_postgres_1.wsd_postgres.dev.local.docker";
echo "Memcached : webstack_memcached_1.wsd_memcached.dev.local.docker";
echo "Varnish : webstack_varnish_1.wsd_varnish.dev.local.docker";
echo "PHP FPM : webstack_phpfpm_1.wsd_phpfpm.dev.local.docker";
echo "NGINX : webstack_nginx_1.wsd_nginx.dev.local.docker";
echo "NodeJS - Bower/Grunt : webstack_nodejs_bower_grunt_1.wsd_nodejs_bower_grunt.dev.local.docker";