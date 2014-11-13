#!/bin/sh

psql -X -U postgres --set ON_ERROR_STOP=no -c "SELECT * FROM pg_roles;";
psql -U postgres wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;