#!/bin/bash

# Directory needed for storing the Postgres database
FILE=postgresql/postgres_database
if [ ! -d "$FILE" ]; then
    echo "Create directory $FILE"
    mkdir $FILE
else
    echo "Directory $FILE exists already: no need to create it"
fi

cp env_template .env
docker compose up -d
