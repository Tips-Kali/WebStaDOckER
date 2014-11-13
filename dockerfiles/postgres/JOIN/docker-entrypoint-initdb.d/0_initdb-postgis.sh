#!/bin/sh
POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE template_postgis
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'
EOSQL

POSTGIS_CONFIG=/usr/share/postgresql/$PG_MAJOR/contrib/postgis-$POSTGIS_MAJOR
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/postgis.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/spatial_ref_sys.sql

cp --force /wsd_postgres/postgresql.conf /var/lib/postgresql/data/postgresql.conf

#gosu postgres psql -h localhost -U dev nogalere < /wsd_postgres/dbexport.pgsql;
#exec psql -X -U dev nogalere --set ON_ERROR_STOP=on -c "SELECT * FROM pg_roles;"