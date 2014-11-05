#!/bin/sh

show "CONFIGURATION (projet, user, ...)";

echo "Utiliser le fichier config.sh [y/n] ?" && read REPLY && if [ "$REPLY" != "y" ]; then

    # Todo : parser config.json c'est mieux que de poser LES QUESTIONS à chaque fois => voir JSON => http://stackoverflow.com/questions/7795171/json-config-to-bash-variables

    echo 'Url de récupération du projet (Git) : ' && read wsd_git_clone;
    echo 'Votre identité : ' && read wsd_identity_name;
    echo 'Votre e-mail : ' && read wsd_identity_email;

    # Récupère le nom du projet concerné
    echo "Entrez le nom du projet concerné :";
    read wsd_project_name;
    while [ -z ${wsd_project_name} ]
    do
        echo "Vous devez entrer quelque chose !" && echo '...' && sleep 2 && echo "Entrez à nouveau le nom du projet concerné :";
        read wsd_project_name;
    done

    # Récupère le nom de l'utilisateur concerné
    echo "Entrez le nom de l'utilisateur UNIX concerné :";
    read wsd_user;
    while [ -z ${wsd_user} ]
    do
        echo "Vous devez entrer quelque chose !" && echo '...' && sleep 2 && echo "Entrez à nouveau le nom de l'utilisateur UNIX concerné :";
        read wsd_user;
    done

    # Check que l'utilisateur entré existe bien
    while [ -z "$(getent passwd ${wsd_user})" ]
    do
        echo "L'utilisateur ${wsd_user} n'existe pas !" && echo '...' && sleep 2 && echo "Entrez à nouveau le nom de l'utilisateur UNIX concerné :";
        read wsd_user;

        while [ ${wsd_user} == "root" ]
        do
            echo "Ce n'est pas prudent de travailler en root !!";
            echo "Entrez à nouveau le nom d'un AUTRE utilisateur UNIX :";
            read wsd_user;
        done
    done

    # Environnement
    PS3="De quel environnement s'agit t-il ? "
    options=("Développement (machine de travail du développeur)" "Staging (machine où se retrouvent tout les commits des développeurs)" "Test (machine de préproduction et de tests de charge)" "Production (machine de production)" "Compact (machine de production, mais contient aussi : Staging et Test)" "Quitter l'installateur")
    select opt in "${options[@]}"
    do
        case $opt in
            "Développement (machine de travail du développeur)")
                wsd_project_environment="development";
                wsd_project_environment_domains="local.${wsd_project_environment}.${wsd_project_name}";
                echo "127.0.0.1   local.${wsd_project_environment}.${wsd_project_name}" >> /etc/hosts;
                echo "127.0.0.1   www.local.${wsd_project_environment}.${wsd_project_name}" >> /etc/hosts;
                break;
                ;;
            "Staging (machine où se retrouvent tout les commits des développeurs)")
                wsd_project_environment="staging";
                wsd_project_environment_domains="${wsd_project_environment}.${wsd_project_name}";
                break;
                ;;
            "Test (machine de préproduction et de tests de charge)")
                wsd_project_environment="test";
                wsd_project_environment_domains="${wsd_project_environment}.${wsd_project_name}";
                break;
                ;;
            "Production (machine de production)")
                wsd_project_environment="production";
                wsd_project_environment_domains="${wsd_project_name}";
                break;
                ;;
            "Compact (machine de production, mais contient aussi : Staging et Test)")
                wsd_project_environment="production";
                wsd_project_environment_domains="${wsd_project_name} test.${wsd_project_name} staging.${wsd_project_name}";
                break;
                ;;
            "Quitter l'installateur")
                exit;
                ;;
            *) echo invalid option;;
        esac
    done
fi
wait;

show "RESUME";

# Résumé
echo 'Utilisateur : ' ${wsd_user};
echo 'Projet : ' ${wsd_project_name};
echo 'Environnement(s) : ' ${wsd_project_environment};
echo 'Url(s) : ' ${wsd_project_environment_domains};
echo 'Votre nom : ' ${wsd_identity_name};
echo 'Votre e-mail : ' ${wsd_identity_email};
echo 'Url de récupèration du projet (Git) : ' ${wsd_git_clone};
wait;