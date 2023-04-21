#!/bin/bash

if [ "$( psql -U $POSTGRES_USER -tAc "SELECT 1 FROM pg_roles WHERE rolname='adempiere'" )" != '1' ]
then
    createuser -U postgres adempiere -dlrs
    createuser -U novatech novatech -DlRS  # User "novatech", no create DB, no create role, no SuperUser
    psql -U postgres -tAc "alter user adempiere password 'adempiere';"
    createdb -U adempiere adempiere
    #psql -U adempiere -d adempiere < Adempiere/data/Adempiere_pg.dmp
    #pg_restore -U adempiere -d adempiere < /tmp/seed.backup -v  # Wenn mit pg_dump restauriert wird
    psql -U adempiere -d adempiere < /tmp/seed.backup  # Wenn mit RUN_DBExport restauriert wird
fi
