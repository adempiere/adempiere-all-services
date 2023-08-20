#!/bin/bash

# Directory needed for storing persistently Postgres database.
# Directory will be created only if inexistent.
DBFILE=postgresql/postgres_database
if [ ! -d "$DBFILE" ]; then
    echo "Directory $DBFILE does not exist. It must be created."
    echo "Create directory $DBFILE"
    mkdir $DBFILE
else
    echo "Directory $DBFILE exists already: no need to create it"
fi

# Backup directory for storing the Postgres backup file.
# The name of the backup file must be "seed.backup"
BACKUPFILE=postgresql/backups
if [ ! -d "$BACKUPFILE" ]; then
    echo "Directory $BACKUPFILE does not exist. It must be created."
    echo "Create directory $BACKUPFILE"
    mkdir $BACKUPFILE
else
    echo "Directory $BACKUPFILE exists already: no need to create it"
fi

cp env_template .env
docker compose up -d
