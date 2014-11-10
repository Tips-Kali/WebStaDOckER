#!/bin/sh
POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE wsd_postgres_database_name
CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'
CREATE ROLE developer
GRANT developer TO dev
GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer
EOSQL

exec psql -U dev wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;
#exec psql -X -U dev wsd_postgres_database_name --set ON_ERROR_STOP=on -c "SELECT * FROM pg_roles;"