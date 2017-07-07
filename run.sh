#!/bin/bash

set -e

export PGPASSWORD=openxds


if [[ ! -z `psql -h postgresql-openxds -p 5432 -U postgres -lqt | cut -d \| -f 1 | grep -w 'openxds'` ]]; then
   	echo "# Database OpenXDS exists #"
else
	echo "# Init OpenXDS Database #"
	psql -h postgresql-openxds -p 5432 -U postgres -c "CREATE USER openxds SUPERUSER PASSWORD 'openxds'"
	psql -h postgresql-openxds -p 5432 -U postgres -f /opt/openxds/misc/create_database_schema_postgres.sql
fi

if [[ ! -z `psql -h postgresql-openxds -p 5432 -U postgres -lqt | cut -d \| -f 1 | grep -w 'log2'` ]]; then
	echo "# Database log2 exists #"
else
	echo "# Init log2 Database#"
	psql -h postgresql-openxds -p 5432 -U postgres -f /opt/openxds/misc/create_database_schema_log2_postgres.sql
fi


echo "# Start OpenXDS #"
cd /opt/openxds/
java -jar /opt/openxds/openxds-1.1.2.jar 
