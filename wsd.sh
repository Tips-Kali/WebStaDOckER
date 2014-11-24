#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
now=$(date +"%Y-%m-%d_%T");
mkdir -p ${dockerDir}/data/logs;
file="${dockerDir}/data/logs/${1}_${now}.log";
touch "$file";
(
    sudo apt-get install -y -qq php5-cli;
    chmod +x "${dockerDir}/lib/WebStaDOckER.php";
    sudo php -f "${dockerDir}/lib/WebStaDOckER.php" ${1} ${2};
) 2>&1 | tee -a ${file};