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
    -d wsd_postgres && sudo docker logs webstack_postgres_1;

# Restore backup from dbexport.pgsql (fichier précédemment importé dans l'image)
sudo docker exec \
    -it \
    webstack_postgres_1 \
    /bin/bash -c "exec psql -U ${wsd_postgres_user} ${wsd_postgres_database_name} < /wsd_postgres/dbexport.pgsql";

# Liste des rôles
sudo docker exec \
    -it \
    webstack_postgres_1 \
    /bin/bash -c "exec psql -X -U ${wsd_postgres_user} ${wsd_postgres_database_name} --set ON_ERROR_STOP=on -c 'SELECT * FROM pg_roles;'";

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
sudo docker run \
    -i \
    --rm \
    -e "environment=production" \
    -e "action=install" \
    -v ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}:/project:rw \
    wsd_nodejs_bower_grunt;

# Confirmation de création des conteneurs
sudo docker ps;