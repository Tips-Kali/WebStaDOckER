#!/bin/sh
POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE wsd_postgres_database_name
CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'
CREATE ROLE developer
GRANT developer TO wsd_postgres_user
GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer
EOSQL

# Todo : plutot faire une bloucle sur tous les *.pgsql dans /wsd_postgres/dump/
psql -U wsd_postgres_user wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql