#!/bin/sh

postgres -D /var/lib/postgresql/data
#pg_ctl -D /var/lib/postgresql/data -l logfile start