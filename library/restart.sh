#!/bin/sh

now=$(date +"%Y-%m-%d_%T");
file="${dockerDir}logs/restart_${now}.log";
touch "$file";
(
    source ${dockerDir}library/asciiart.sh;
    source ${dockerDir}config.sh; # Config
    source ${dockerDir}library/functions.sh; # Fonctions utiles tout au long du script
    source ${dockerDir}library/run.sh; # Run les containers
) 2>&1 | tee -a ${file};