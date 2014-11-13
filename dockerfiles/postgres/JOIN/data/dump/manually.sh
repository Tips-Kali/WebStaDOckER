#!/bin/sh
psql -X -U postgres --set ON_ERROR_STOP=on -c "CREATE DATABASE wsd_postgres_database_name";

#adduser wsd_postgres_user;
psql -X -U postgres --set ON_ERROR_STOP=on -c "CREATE USER wsd_postgres_user WITH PASSWORD 'wsd_postgres_password'";
psql -X -U postgres --set ON_ERROR_STOP=on -c "CREATE ROLE developer";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT developer TO wsd_postgres_user";
psql -X -U postgres --set ON_ERROR_STOP=on -c "SELECT * FROM pg_roles;";

psql -X -U postgres --set ON_ERROR_STOP=on -c "ALTER ROLE wsd_postgres_user WITH superuser;";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON DATABASE wsd_postgres_database_name TO developer";
psql -U wsd_postgres_user --set ON_ERROR_STOP=on wsd_postgres_database_name < /wsd_postgres/dbexport.pgsql;
# After restoring a backup, it is wise to run ANALYZE on each database so the query optimizer has useful statistics; see Section 23.1.3 and Section 23.1.5 for more information. For more advice on how to load large amounts of data into PostgreSQL efficiently, refer to Section 14.4.

psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO developer;";
psql -X -U postgres --set ON_ERROR_STOP=on -c "GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO developer;";