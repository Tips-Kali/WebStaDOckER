#!/bin/sh
cp --force /wsd_postgres/postgresql.conf /var/lib/postgresql/data/postgresql.conf
cp --force /wsd_postgres/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf