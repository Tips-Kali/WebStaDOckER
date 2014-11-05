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
# Todo : ne plus poser la question, on doit savoir automatiquement si c'est wheezy ou jessie
PS3='Quelle est la version de votre OS ?'
options=("Debian 7 - Wheezy" "Debian 8 - Jessie" "Quitter")
select opt in "${options[@]}"
do
    case $opt in
        "Debian 7 - Wheezy")
            echo '[ATTENTION] Execution en tant que root :';
            su -l root -c "echo 'deb http://http.debian.net/debian wheezy-backports main' >> /etc/apt/sources.list;";
            sudo apt-get -y install -t wheezy-backports linux-image-amd64 curl;
            curl -sSL https://get.docker.com/ | /bin/sh;
            # Todo : vérifier et installer le kernel > 3.8
            #uname -mrns
            #wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz
            #wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.sign
            #tar -xvf linux-3.16.tar
            #gpg --verify linux-3.16.tar.sign
            #gpg --recv-keys  00411886
            #gpg --verify linux-3.16.tar.sign
            #sudo apt-get -y install libncurses5-dev fakeroot kernel-package
            #cd linux-3.16/
            #cp /boot/config-'uname -r' .config
            #ls -al
            #make menuconfig
            #make-kpkg clean
            #cat /proc/cpuinfo
            #export CONCURRENCY_LEVEL=3
            #fakeroot make-kpkg --append-to-version "-tecmintkernel" --revision "1" --initrd kernel_image kernel_headers
            break;
            ;;
        "Debian 8 - Jessie")
            sudo apt-get -y install docker.io;
            break;
            ;;
        "Quitter")
            exit;
            ;;
        *) echo invalid option;;
    esac
done

# Todo : optimisation de la mémoire et du swap : https://docs.docker.com/installation/ubuntulinux/#memory-and-swap-accounting

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