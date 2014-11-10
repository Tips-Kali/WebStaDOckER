#!/bin/sh

# Récupération
sudo docker pull debian:jessie;
sudo docker pull debian:wheezy;
sudo docker pull jprjr/arch;
sudo docker pull postgres:9.4;
sudo docker pull nginx:latest;
sudo docker pull dockerfile/nodejs;
sudo docker pull maxexcloo/phppgadmin;
sudo docker pull sylvainlasnier/memcached;

# Création du container de depôts locaux
sudo docker run -p 5000:5000 registry

# Ajout en local
sudo docker tag debian:jessie localhost:5000/debian:jessie;
sudo docker push localhost:5000/jessie;

sudo docker tag debian:wheezy localhost:5000/debian:wheezy;
sudo docker push localhost:5000/wheezy;

sudo docker tag jprjr/arch localhost:5000/jprjr/arch;
sudo docker push localhost:5000/arch;

sudo docker tag postgres:9.4 localhost:5000/postgres:9.4;
sudo docker push localhost:5000/postgres;

sudo docker tag nginx:latest localhost:5000/nginx:latest;
sudo docker push localhost:5000/nginx;

sudo docker tag dockerfile/nodejs localhost:5000/dockerfile/nodejs;
sudo docker push localhost:5000/nodejs;

sudo docker tag maxexcloo/phppgadmin localhost:5000/maxexcloo/phppgadmin;
sudo docker push localhost:5000/phppgadmin;

sudo docker tag sylvainlasnier/memcached localhost:5000/sylvainlasnier/memcached;
sudo docker push localhost:5000/memcached;

#Exemple de récupéaration locale
sudo docker pull localhost:5000/jessie;
sudo docker pull localhost:5000/wheezy;
sudo docker pull localhost:5000/arch;
sudo docker pull localhost:5000/postgres;
sudo docker pull localhost:5000/nginx;
sudo docker pull localhost:5000/nodejs;
sudo docker pull localhost:5000/phppgadmin;
sudo docker pull localhost:5000/memcached;
