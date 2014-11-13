#!/bin/sh

gosu postgres createdb wsd_postgres_database_name;
# Todo : ajouter un role "developper"
gosu postgres createuser wsd_postgres_user;
psql -X -U postgres --set ON_ERROR_STOP=no -c "ALTER USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password';";

psql -X -U postgres --set ON_ERROR_STOP=no -c "SELECT * FROM pg_roles;";
psql -U postgres wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;