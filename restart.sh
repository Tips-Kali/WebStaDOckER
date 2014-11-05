#!/bin/sh

dockerDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/";
now=$(date +"%Y-%m-%d_%T");
file="${dockerDir}logs/restart_${now}.log";
touch "$file";
(
    source ${dockerDir}library/asciiart.sh;
    source ${dockerDir}config.sh; # Config
    source ${dockerDir}library/run.sh; # Run les containers
) 2>&1 | tee -a ${file};