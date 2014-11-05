#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/";
now=$(date +"%Y-%m-%d_%T");
file="${dockerDir}logs/install_${now}.log";
touch "$file";
(
    source ${dockerDir}library/asciiart.sh;
    source ${dockerDir}config.sh; # Config
    source ${dockerDir}library/functions.sh; # Fonctions utiles tout au long du script
    source ${dockerDir}library/configure.sh; # Récupère la configuration et pose les question necessaire
    source ${dockerDir}library/install.sh; # Install sur la machine hôte
    source ${dockerDir}library/build.sh; # Construit les images
    source ${dockerDir}library/run.sh; # Run les containers
    source ${dockerDir}library/guide.sh; # Actions perso
    source ${dockerDir}library/local.sh; # Actions perso
) 2>&1 | tee -a ${file};