#!/bin/bash

# This file is skipped automatically when directory "./postgresql/postgres_database" exists and contains data.
if [[ -z `psql -Atqc '\list adempiere' postgres` ]]  # Test database existence
then
    echo "The database 'adempiere' does not exist; it will be created and restored"
    createuser adempiere -dlrs
    createuser novatech -DlRS  # User "novatech" only because a customer of Westfalia (for others: delete line). No create DB, no create role, no SuperUser
    psql -tAc "alter user adempiere password 'adempiere';"
    createdb -U adempiere adempiere
    
    echo "Restore of database 'adempiere' starting..."
    #psql -U adempiere -d adempiere < Adempiere/data/Adempiere_pg.dmp
    #pg_restore -U adempiere -d adempiere < /tmp/seed.backup -v  # In case Backup was created with pg_dump
    psql -U adempiere -d adempiere < /home/adempiere/backups/seed.backup  # In case Backup was created with  RUN_DBExport
    echo "Restore of database 'adempiere' finished"
else
    echo "Database 'adempiere' does already exist; it needs not be created"
fi
