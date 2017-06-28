#!/bin/bash

set -e

export PGPASSWORD=openxds

echo "### Init DB ###"
sleep 5

psql -h postgresql-openxds -p 5432 -d openxds -U openxds -f /opt/openxds/misc/create_database_schema_postgres.sql

echo "### Start OpenXDS ###"
cd /opt/openxds/
java -jar /opt/openxds/openxds-1.1.2.jar 
