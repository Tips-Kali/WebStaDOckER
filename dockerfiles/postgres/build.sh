#!/bin/sh

database_name=$1;
database_user=$2;
database_password=$3;

psql -X -h localhost -U postgres --set ON_ERROR_STOP=on -c "CREATE DATABASE ${database_name}";

# Add user;
psql -X -U postgres --set ON_ERROR_STOP=on -c "CREATE USER ${database_user} WITH PASSWORD '${database_password}'";
psql -X -U postgres --set ON_ERROR_STOP=on -c "CREATE ROLE developer";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT developer TO ${database_user}";
psql -X -U postgres --set ON_ERROR_STOP=on -c "SELECT * FROM pg_roles;";

psql -X -U postgres --set ON_ERROR_STOP=on -c "ALTER ROLE ${database_user} WITH superuser;";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON DATABASE ${database_name} TO developer";
psql -U ${database_user} --set ON_ERROR_STOP=on ${database_name} < /wsd/dbexport.pgsql;
# After restoring a backup, it is wise to run ANALYZE on each database so the query optimizer has useful statistics; see Section 23.1.3 and Section 23.1.5 for more information. For more advice on how to load large amounts of data into PostgreSQL efficiently, refer to Section 14.4.

psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO developer;";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO developer;";