#!/bin/sh

# Installation de Docker
if [[ $(cat /etc/debian_version | cut -d/ -f1) == "jessie" ]]; then
    if [[ $(version_compare "3.16" "$(uname -r|cut -d\- -f1| tr -d '[A-Z][a-z]')") != "inferieur" ]]; then
        echo "Version du kernel : ok";
        apt-get -y install docker.io;
    else
        echo "Oups, votre kernel n'est pas à jour (3.16 minimum, vous êtes en $(uname -r|cut -d\- -f1| tr -d '[A-Z][a-z]'))";
        lsb_release -a;
        cat /proc/version;
        exit;
    fi
elif [[ $(cat /etc/debian_version | cut -d/ -f1) == "wheezy" ]]; then
    if [[ $(version_compare "3.16" "$(uname -r|cut -d\- -f1| tr -d '[A-Z][a-z]')") != "inferieur" ]]; then
        echo "Version du kernel : ok";
        echo '[ATTENTION] Execution en tant que root :';
        su -l root -c "echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list;";
        apt-get -y install -t wheezy-backports linux-image-amd64 curl;
        curl -sSL https://get.docker.com/ | /bin/sh;
    else
        echo "Oups, votre kernel n'est pas à jour (3.16 minimum, vous êtes en $(uname -r|cut -d\- -f1| tr -d '[A-Z][a-z]'))";
        lsb_release -a;
        cat /proc/version;
        exit;
    fi
else
    echo "Votre version debian est trop ancienne ( Wheezy ou Jessie sont requis ) !";
fi

# Suppression image par défaut
docker rmi hello-world;