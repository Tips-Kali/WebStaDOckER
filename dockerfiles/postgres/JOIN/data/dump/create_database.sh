#!/bin/sh
rm -rf /var/lib/postgresql
mkdir -p /var/lib/postgresql/data
chown -R postgres /var/lib/postgresql/data
chown -R postgres /wsd_postgres
gosu postgres initdb --pgdata /var/lib/postgresql/data

POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE wsd_postgres_database_name
CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'
CREATE ROLE developer
GRANT developer TO wsd_postgres_user
GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer
EOSQL

#gosu postgres postgres psql -U wsd_postgres_user wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;
#exec psql -X -U wsd_postgres_user wsd_postgres_database_name --set ON_ERROR_STOP=on -c "SELECT * FROM pg_roles;"