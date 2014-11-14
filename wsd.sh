#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/";
wsd_action=${1};

if [[ ${wsd_action} == "install" ]]; then
    source "${dockerDir}library/install.sh";
elif [[ ${wsd_action} == "restart" ]]; then
    source "${dockerDir}library/restart.sh";
else
    echo 'Commande introuvable, essayez "/wsd.sh install" ou "/wsd.sh restart"';
fi