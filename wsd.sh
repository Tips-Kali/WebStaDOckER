#!/bin/sh

WebStaDOckERDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
now=$(date +"%Y-%m-%d_%T");
mkdir -p ${WebStaDOckERDir}/data/logs;
file="${WebStaDOckERDir}/data/logs/${1}_${2}_${now}.log";
touch "$file";
(
    sudo apt-get install -y -qq php5-cli;
    chmod +x "${WebStaDOckERDir}/lib/WebStaDOckER.php";
    sudo php -f "${WebStaDOckERDir}/lib/WebStaDOckER.php" ${1} ${2};
) 2>&1 | tee -a ${file};