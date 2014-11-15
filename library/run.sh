#!/bin/sh

show "CREATION DES CONTAINERS";

# Suppression de tous les container ( remise à zéro )
sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q);

# Todo : limiter la conso RAM/CPU des container : https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting
# Todo : voir le démarrage automatique des containers : https://docs.docker.com/articles/host_integration/

# Crée le container : Lancement de php-fpm sur le port 9000
sudo docker run \
    --name webstack_php_1 \
    -p 9000:9000 \
    -v ${dockerDir}dockerfiles/nginx/LINK/www:/var/www:rw \
    -d wsd_phpfpm && sudo docker logs webstack_php_1;

# PostgreSQL
sudo docker run \
    --name webstack_postgres_1 \
    -it \
    -v ${dockerDir}dockerfiles/postgres/LINK/data:/var/lib/postgresql/data:rw \
    -d wsd_postgres && sudo docker logs webstack_postgres_1;

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
    -d maxexcloo/phppgadmin && sudo docker logs webstack_phppgadmin_1;

# Crée le container : Redirige le port TCP/80 de notre hôte vers le port TCP/80 du conteneur
sudo docker run \
    --name webstack_nginx_1 \
    -p 80:80 \
    -v ${dockerDir}dockerfiles/nginx/LINK/www:/var/www:rw \
    -v ${dockerDir}dockerfiles/nginx/LINK/htpasswds/${wsd_project_name}:/etc/nginx/htpasswds:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/sites-enabled:/etc/nginx/sites-available:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/sites-enabled:/etc/nginx/sites-enabled:ro \
    -v ${dockerDir}dockerfiles/nginx/LINK/log:/var/log/nginx:rw \
    --link webstack_php_1:webstack_php \
    --link webstack_postgres_1:postgres \
    -d wsd_nginx && sudo docker logs webstack_nginx_1;

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

# Memcached
sudo docker run \
    --name webstack_memcached_1 \
    -p 11211:11211 \
    -d wsd_memcached;

# Confirmation de création des conteneurs
sudo docker ps;