#!/bin/bash

docker compose down
docker rmi -f $(docker images -aq)
yes | docker system prune -a
docker volume rm $(docker volume ls -q)
