#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/";
wsd_action=${1};

mkdir -p ${dockerDir}backups;
mkdir -p ${dockerDir}logs;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/log;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/htpasswds;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/www;
mkdir -p ${dockerDir}dockerfiles/nginx/LINK/sites-enabled;
mkdir -p ${dockerDir}dockerfiles/piwik;
mkdir -p ${dockerDir}dockerfiles/postgres/LINK/data;

if [[ ${wsd_action} == "install" ]]; then
    source "${dockerDir}library/install.sh";
elif [[ ${wsd_action} == "restart" ]]; then
    source "${dockerDir}library/restart.sh";
elif [[ ${wsd_action} == "rebuild" ]]; then
    source "${dockerDir}library/rebuild.sh";
else
    wsd_sous_action=${2};
    if [[ ${wsd_action} == "postgres" ]]; then
        if [[ ${wsd_sous_action} == "stop" ]]; then
            echo "Arrêt de Postgres...";
        fi
    else
        echo 'Commande introuvable, essayez "/wsd.sh install" ou "/wsd.sh restart"';
    fi
fi