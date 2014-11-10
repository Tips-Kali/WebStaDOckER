#!/bin/sh

show "RECUPERATION DU PROJET";

# Récupération
sudo apt-get -y install git;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/www;
cd ${dockerDir}dockerfiles/nginx/LINK/www;
git clone ${wsd_git_clone};
git config core.fileMode false;
git gc;
git fsck;

# Droits générique
sudo chown -R ${wsd_user}:http ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}/; # Todo : récupérer le group de l'user ${wsd_user} dynamiquement
find ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}/ -type d -exec chmod 755 {} +;
find ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}/ -type f -exec chmod 644 {} +;

show "INITIALISE";

echo "Arrêter tous les conteneurs et supprimer toutes les images [y/n] ?" && read REPLY && if [ "$REPLY" == "y" ]; then
    echo "Etes-vous vraiement sûr [y/n] ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        sudo docker stop $(sudo docker ps -a -q) && sudo docker rm $(sudo docker ps -a -q) && sudo docker rmi $(sudo docker images -q);
    fi
fi

show "CONFIGURATION DES DOCKFILES";

subShow "Image : PHP-FPM";

# PHP-FPM
cd ${dockerDir}dockerfiles/phpfpm && sudo docker build -t wsd_phpfpm .;

subShow "Image : NGINX";

# NGINX
cp ${dockerDir}dockerfiles/nginx/LINK/sites-available/example ${dockerDir}dockerfiles/nginx/LINK/sites-enabled/${wsd_project_name};
cp ${dockerDir}dockerfiles/nginx/LINK/www/${wsd_project_name}/package.json ${dockerDir}dockerfiles/nodejs_bower_grunt/JOIN;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/htpasswds/${wsd_project_name};
touch ${dockerDir}dockerfiles/nginx/LINK/htpasswds/${wsd_project_name}/htpasswd;
cat >${dockerDir}dockerfiles/nginx/LINK/htpasswds/${wsd_project_name}/htpasswd <<EOL
magie:\$apr1\$PZIfWzJQ\$gGgMTlYrjqAgmE28v2czr1
EOL
sed -i "s/wsd_project_name/${wsd_project_name}/" ${dockerDir}dockerfiles/nginx/LINK/sites-enabled/${wsd_project_name};
sed -i "s/wsd_project_environment_domains/${wsd_project_environment_domains}/" ${dockerDir}dockerfiles/nginx/LINK/sites-enabled/${wsd_project_name};
sed -i "s/wsd_project_environment/${wsd_project_environment}/" ${dockerDir}dockerfiles/nginx/LINK/sites-enabled/${wsd_project_name};
cd ${dockerDir}dockerfiles/nginx && sudo docker build -t wsd_nginx .;

# ZendServer
# subShow "Image : Composer";
#cd ${dockerDir}dockerfiles/zendserver && sudo docker build -t zendserver .;

subShow "Image : Composer";

# Composer
cd ${dockerDir}dockerfiles/composer && sudo docker build -t wsd_composer .;

subShow "Image : NodeJs : Bower + Grunt";

# NodeJs : Bower + Grunt
cd ${dockerDir}dockerfiles/nodejs_bower_grunt && sudo docker build -t wsd_nodejs_bower_grunt .;

subShow "Image : Postgres SQL";

# Postgres
cd ${dockerDir}dockerfiles/postgres/JOIN/data/certs;
openssl req -new -text -out server.req;
openssl rsa -in privkey.pem -out server.key;
rm privkey.pem;
openssl req -x509 -in server.req -text -key server.key -out server.crt;
chmod og-rwx server.key;
rm -f ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database_modified.sh;
cp ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database.sh ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database_modified.sh;
sed -i "s/wsd_postgres_database_name/${wsd_postgres_database_name}/" ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database_modified.sh;
sed -i "s/wsd_postgres_user/${wsd_postgres_user}/" ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database_modified.sh;
sed -i "s/wsd_postgres_password/${wsd_postgres_password}/" ${dockerDir}dockerfiles/postgres/JOIN/data/dump/create_database_modified.sh;
if [ ${wsd_project_environment} == "development" ]; then
    echo "127.0.0.1   phppgadmin.${wsd_project_domain}" >> /etc/hosts;
fi
cd ${dockerDir}dockerfiles/postgres && sudo docker build -t wsd_postgres .;

show "RECUPERATION DES IMAGES COMPILEES";

# Récupère les images

subShow "Image : phpPgAdmin";
sudo docker pull maxexcloo/phppgadmin; # phpPgAdmin

subShow "Image : Memcached";
sudo docker pull sylvainlasnier/memcached; # Memcached

# Piwik

# Confirmation des images disponible
sudo docker images;