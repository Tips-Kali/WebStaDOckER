#!/bin/sh
POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE wsd_postgres_database_name
CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'
CREATE ROLE developer
GRANT developer TO wsd_postgres_user
GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer
EOSQL