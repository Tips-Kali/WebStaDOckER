WebStaDOckER - Wiki
=========

En Général
-----------

Dans le repertoire "/dockerfiles" se trouve donc toutes les applications (composer, memcached, nginx, nodejs-bower/grunt, phpfpm, postgres....)
Dans chaque répertoire d'application, se trouve le Dockerfile ainsi que 2 répertoires : JOIN et LINK

- JOIN : Vous pouvez adapter le contenu de ces répertoires AVANT de lancer l'installation !
- LINK : Le contenu de ce répertoire peut être modifié à tout moment (sous réserve que l'application en question le permette, ou restart de celle-ci)

Postgres
-----------

Pour le moment WebStaDOckER, part du principe qu'on doit founir un dump initial, le fichier doit être : "/dockerfiles/postgres/JOIN/data/dump/dbexport.pgsql"
Si vous ne voulez pas importer de dump, et juste partir d'une base de donnée vierge, vous devez éditer le fichier : "/dockerfiles/postgres/JOIN/data/dump/manually.sh" AVANT lancement de l'installation