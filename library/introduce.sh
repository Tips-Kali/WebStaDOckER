#!/bin/sh

show "DROITS";

# Install Sudo et rend sudoers l'utilisateur par défaut
echo "Rendre sudoers l'utilisateur : ${wsd_user} [y/n] ?" && read REPLY && if [ "$REPLY" == "y" ]; then
   wait;
    if [[ ${USER} == "root" ]]; then
        apt-get -y install sudo;
        echo ${wsd_user} '         ALL=(ALL)       PASSWD: ALL' >> /etc/sudoers;
        cat /etc/sudoers;
        echo "Mot de passe de l'utilisateur : ${wsd_user} :";
        su ${wsd_user};
    else
        echo '[ATTENTION] Execution en tant que root :';
        su -l root -c "apt-get install -y sudo && echo ${wsd_user} '         ALL=(ALL)       PASSWD: ALL' >> /etc/sudoers && cat /etc/sudoers;";
    fi
fi

show "INSTALLATION DE DOCKER";

# Mise a jour des paquets
sudo apt-get -y update && sudo apt-get -y upgrade;

# Installation de Docker
if [[ $(cat /etc/debian_version | cut -d/ -f1) == "jessie" ]]; then
    if [[ $(version_compare "3.16" "$(uname -r|cut -d\- -f1| tr -d '[A-Z][a-z]')") != "inferieur" ]]; then
        echo "Version du kernel : ok";
        sudo apt-get -y install docker.io;
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
        sudo apt-get -y install -t wheezy-backports linux-image-amd64 curl;
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

# Todo : optimisation de la mémoire et du swap : https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting

# Suppression image par défaut
sudo docker rmi hello-world;

# Installation de Glance
if [ ${wsd_project_environment} != "development" ]; then
    echo "Installer Glances ?" && read REPLY && if [ "$REPLY" == "y" ]; then
        show "MISE EN PLACE DE 'GLANCES'";
        installedGlance="oui";
        sudo apt-get -y install curl;
        sudo curl -L http://bit.ly/glances | /bin/bash;
    fi
fi

# Outils de travail
if [ ${wsd_project_environment} == "development" ]; then
    # Todo : si en DEV : proposer d'installer : java, phpstorm, smartgit...
    echo 'java, phpstorm, smartgit...';
fi

# Installation de NeoVIM