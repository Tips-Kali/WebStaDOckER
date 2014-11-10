#!/bin/sh

echo "Environnement : ${1}";
echo "Action : ${2}";

if [ -z ${1} ]; then
    1="production";
fi

if [ -z ${2} ]; then
    2="install";
fi

cd /project;
npm ${2};
npm ${2} -g bower grunt-cli;
bower ${2} --allow-root;
grunt --gruntfile /project/Gruntfile.js $1;