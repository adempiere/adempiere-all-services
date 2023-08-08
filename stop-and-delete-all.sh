#!/bin/bash

docker compose down
docker rmi -f $(docker images -aq)
yes | docker system prune -a
docker volume rm $(docker volume ls -q)
# docker network rm $(docker network ls -q -f name=adempiere-all.adempiere_network)  # not necessary
