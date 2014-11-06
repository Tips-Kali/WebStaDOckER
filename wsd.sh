#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/";

if [[ ${1} == "install" ]]; then
    source "${dockerDir}library/install.sh";
elif [[ ${1} == "restart" ]]; then
    source "${dockerDir}library/restart.sh";
else
    echo 'Commande introuvable, essayez "/wsd.sh install" ou "/wsd.sh restart"';
fi