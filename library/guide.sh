#!/bin/sh

if [ ${wsd_project_environment} != "development" ]; then
    echo 'Veuillez ne pas oublier de configurer les DNS : ';
    echo '';
    echo "127.0.0.1   phppgadmin.${wsd_project_domain}"
fi

echo 'Vos URLs :';
echo '';
echo "phpPgAdmin : http://phppgadmin.${wsd_project_domain}:3321/";
echo "-user : ${wsd_postgres_user}";
echo "-password : ${wsd_postgres_password}";
echo '';

echo 'Veuillez patienter, votre fichier spécifique (local.sh) va être exécuter...';
wait;