#!/bin/bash

rm -rf /var/lib/postgresql/data/*
mkdir -p /var/lib/postgresql/data
chown -R postgres /var/lib/postgresql/data
chown -R postgres /wsd
gosu postgres initdb --pgdata /var/lib/postgresql/data

POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE template_postgis
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'
EOSQL

POSTGIS_CONFIG=/usr/share/postgresql/$PG_MAJOR/contrib/postgis-$POSTGIS_MAJOR
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/postgis.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/spatial_ref_sys.sql

cp --force /wsd/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp --force /wsd/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
#cp --force /wsd/pg_ident.conf /var/lib/postgresql/data/pg_ident.conf