#!/bin/sh

psql -X -U postgres --set ON_ERROR_STOP=no -c "CREATE DATABASE wsd_postgres_database_name";
psql -X -U postgres --set ON_ERROR_STOP=no -c "CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'";
psql -X -U postgres --set ON_ERROR_STOP=no -c "CREATE ROLE developer";
psql -X -U postgres --set ON_ERROR_STOP=no -c "GRANT developer TO wsd_postgres_user";
psql -X -U postgres --set ON_ERROR_STOP=no -c "GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer";
psql -X -U postgres --set ON_ERROR_STOP=no -c "SELECT * FROM pg_roles;";
psql -U postgres wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;