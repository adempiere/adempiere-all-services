# ADempiere All Services
This application downloads the required images, runs the configured containers and restores the database if needed on your local machine just by calling a script!
 
It consists of a *docker compose* project that defines all services needed to run ADempiere on ZK and Vue. 
 
When executed, the *docker compose* project eventually runs the services defined in file *docker-compose.yml* as Docker containers.
The running Docker containers comprise the application.
 
Benefits of the application:
- In its simplest form, it can be used as a demo of the latest ADempiere version.
- No big installation hassle for getting it running: just execute a shell script.
- It can run on different hosts just by changing the target IP to the one of the host.
- Completly configurable: any value can be changed for the whole application at one single configuration file.
- Single containers or images can be updated and/or replaced easily, making deployments and test speedy.
- The timezone and location for all containers are the same as the hosts'.
- Ideal for testing situations due to its ease of configuration and execution.
- No need of deep knowledge of Docker, Images or Postgres.
- Every container, image and object is unique, derived from a configuration file.

## Example of Application Running
![ADempiere Vue](docs/ADempiere_All_Services_Vue.gif)

![ADempiere ZK](docs/ADempiere_All_Services_ZK.gif)

## General Explanations
### User's perspective
From a user's point of view, the application consists of the following calls.

Take note that the ports are defined in file *env_template* as external ports and can be changed if needed or desired.
- A home web site accesible via port **8080**
  From which all applications can be called
- An ADempiere ZK UI accesible via port **8888**
- An ADempiere Vue UI accesible via port **8891**
- A Postgres databasee accesible e.g. by PGAdmin via port **55432**

### Application Stack
The application stack consists of the following services defined in *docker-compose.yml*, which eventually will be run as containers:
- *adempiere-site*: defines the landing page (web site) for this application
- *adempiere.db*: defines the Postgres database 
- *adempiere-zk*: defines the Jetty server and the ADempiere ZK UI
- *adempiere-middleware*: manages Database Insert, Update, Delete 
- *adempiere-backend-rs*:
- *adempiere-grpc-server*: defines the backend server for Vue
- *adempiere-scheduler*: for processes that are executed outside Adempiere
- *vue-api*: proxy
- *vue-ui*: defines ADempiere Vue UI

Additional objects defined in *docker-compose.yml*:
- *adempiere_network*: defines the subnet used in the involved Docker containers (e.g. **192.168.100.0/24**)
- *volume_postgres*: defines the mounting point of the Postgres database on the Docker container (typically directory **/var/lib/postgresql/data**) to a local directory on the host where the Docker container runs.
- *volume_backups*: defines the mounting point of a backup directory on the Docker container to a local directrory on the host where the Docker container runs.
- *volume_scheduler*: defines the mounting point for the scheduler

### Architecture
The application stack as graphic:
![ADempiere Architecture](docs/ADempiere_All_Services_Architecture.png)

### File Structure
- *README.md*: this very file
- *env_template*: template for definition of all variables. Usually, this file is edited and tested before copied to *.env*.
- *.env*: definition of all variables used in *docker-compose.yml*.
- *docker-compose.yml*: the docker compose definition file. Here all services are defined.
  Variables used in this file are taken from file *.env*.
- *start-all.sh*: shell script to automatically execute docker compose.
  The persistent directory (database) and the backup directory are created when needed, the file *env_template* is copied to *.env* and docker compose is started.
- *stop-and-delete-all.sh*: shell script to delete all containers, images, networks, cache and volumes created with *start-all.sh* or by executing *docker-compose.yml*.
  After executing this shell, no trace of the application will be left over. Only the persistent directory will not be affected.
- *postgresql/Dockerfile*: the Dockerfile used.
  It mainly copies postgresql/initdb.sh to the container, so it can be executed at start.
- *postgresql/initdb.sh*: shell script executed in the container when Postgres starts. 
  If there is a database named "adempiere", nothing happens.
  If there is no database named "adempiere", the script checks if there is a database seed file in the backups directory. 
  - If there is one, it launches a restore database.
  - If there is none, the latest ADempiere seed is downloaded from Github and the restore is started with it.
- *postgresql/postgres_database*: directory on host used as the mounting point on the host for the Postgres container's database. 
  This makes sure that the database is not deleted even if the docker containers, docker images and even docker are deleted.
  The database contents are kept always persistently on the host.
- *postgresql/backups*: directory on host used as the mounting point for the backups/restores from the Postgres container.
  Here the seed file for a potential restore can be copied. 
  The name of the seed can be defined in *env_template*.
  The seed is a backup file created with psql.
  If there is a seed, but a database exists already, there will be no restore.
  This directory is also useful when creating a backup: it can be created here, without needing to transfer it from the container to the host.
- *docs*: directory containing images and documents used in this README file.

## Next Functionality
In a further step, the application can be implemented in a way that it may concurrently be executed for different customers databases using the same database server on the same host by just changing the project name and running anew. The only open issue is where Adempiere calls the database.

## Installation
### Requirements
##### 1 Install Tools
Make sure to install the following:
- JDK  11
- Docker
- Docker compose: [Docker Compose v2.16.0 or later](https://docs.docker.com/compose/install/linux/)
- Git

##### 2 Check versions
2.1 Check `java version`
```Shell
java --version
    openjdk 11.0.11 2021-04-20
    OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
    OpenJDK 64-Bit Server VM AdoptOpenJDK-11.0.11+9 (build 11.0.11+9, mixed mode
```
2.2 Check `docker version`
```Shell
docker --version
    Docker version 23.0.3, build 3e7cbfd
```
2.3 Check `docker compose version`
```Shell
docker compose version
    Docker Compose version v2.17.2
```
### Clone This Repository
```Shell
git clone https://github.com/adempiere/adempiere-all-services
cd adempiere-all-services
```
### Make sure to use correct branch
```Shell
git checkout main
```

### Manual Execution
Alternative to **Automatic Execution**.
Recommendable for the first installation.
##### 1 Create the directory on the host where the database will be mounted
```Shell
mkdir postgresql/postgres_database
```
##### 2 Create the directory on the host where the backups will be mounted
```Shell
mkdir postgresql/backups
```
##### 3 Copy backup file (if restore is needed)
- If you are executing this project for the first time or you want to restore the database, execute a database backup e.g.: 
`pg_dump -v --no-owner -h localhost -U postgres <DB-NAME> > adempiere-$(date '+%Y-%m-%d').backup`. 
- The file must be named `seed.backup` or as it was defined in *env_template*, variable *POSTGRES_RESTORE_FILE_NAME*. 
  Then, copy or move it to `adempiere-all-service/postgresql/backups`. 
- Make sure it is not the compressed backup (e.g. .jar).
- The database directory `adempiere-all-service/postgresql/postgres_database` must be empty for the restore to ocurr. 
  A backup will not ocurr if the database directory has contents.
```Shell
cp <PATH-TO-BACKUP-FILE> postgresql/backups
```
##### 5 Modify env_template as needed (optional)
The only variables actually needed to change in *env_template* are 
- *COMPOSE_PROJECT_NAME* -> to the name you want to give the project, e.g. *demo*, *test*, or the name of your client).
  From this name, all images and container names are derived.
- *HOST_IP*  -> to to the IP your host has, though you can leave it with 0.0.0.0 to work locally.
- *POSTGRES_IMAGE* -> to the Postgres version you want to use.
- *ADEMPIERE_GITHUB_VERSION* -> to the DB version needed. This applies only if you want to restore from the Github official ADempiere release.
- *ADEMPIERE_GITHUB_COMPRESSED_FILE* -> to the DB version needed. This applies only if you want to restore from the Github official ADempiere release, too.

![ADempiere Template](docs/ADempiere_All_Services_env_template.png)

Other values in *env_template* are default values. 
Feel free to change them accordingly to your wishes/purposes.
There should be no need to change file *docker-compose.yml*.
##### 6 Copy env_template if it was modified (optional)
Once you modified *env_template* as needed, copy it to *.env*. This is not needed if you run *start-all.sh*. 
```Shell
cp env_template .env
```
##### 7 File initdb.sh (optional)
Modify `postgresql/initdb.sh` as necessary, depending on what you may want to do at database first start.
You may create roles, schemas, etc.
##### 8 Execute docker compose
Run `docker compose`
```Shell
docker compose up -d
```

**Result: all images are downloaded, containers and other docker objects created, containers are started, and database restored**.

This might take some time, depending on your bandwith and the size of the restore file.
### Automatic Execution
Alternative to **Manual Execution**.
Recommendable when docker compose was run manually before.

##### 1 Execute With One Script
Execute script `start-all.sh`:
```Shell
./start-all.sh
```
The script *start-all.sh* carries out the steps of the manual installation.
If directories *postgresql/postgres_database* and *postgresql/backups* do not exist, they are created.

##### 2 Result Of Script Execution
All images are downloaded, containers and other docker objects created, containers are started, and -depending on conditions explained in the following section- database restored.

This might take some time, depending on your bandwith and the size of the restore file.

##### 3 Cases When Database Will Be Restored
If 
- there is a file *seed.backup* (or as defined in env_template, variable POSTGRES_RESTORE_FILE_NAME) in *postgresql/backups*, and 
- the database as specified in *env_template*, variable *POSTGRES_DATABASE_NAME* does not exist in Postgres, and
- directory *postgresql/postgres_database* has no contents

The database  will be restored.

##### 4 Cases When Database Will Not Be Restored
The execution of *postgresql/initdb.sh* will be skipped if 
- directory *postgresql/postgres_database* has contents, or 
- in file *docker-compose.yml* there is a definition for *image*.
  Here, the Dockerfile is ignored and thus also *docker-compose.yml*.
## Open Applications
- Project site: open browser and type in the following url [http://localhost:8080](http://localhost:8080)
  From here, the user can navigate via buttons to ZK UI or Vue UI.
- Open separately Adempiere ZK: open browser and type in the following url [http://localhost:8888/webui](http://localhost:8888/webui)
- Open separately Adempiere Vue:open browser and type in the following url [http://localhost:8891/#/login?redirect=%2Fdashboard](http://localhost:8891/#/login?redirect=%2Fdashboard)

### Delete All Docker Objects
Sometimes, due to different reasons, you need to undo everything and start anew.
Then:All
- All Docker containers must be shut down.
- All Docker containers must be deleted.
- All Docker images must be deleted.
- The Docker installation cache must be cleared.
- All Docker networks and volumes must be deleted.

Execute command:
```Shell
./stop-and-delete-all.sh
```

### Database Access
Connect to database via port **55432** with a DB connector, e.g. PGAdmin.
Or to the port the variable *POSTGRES_EXTERNAL_PORT* points in file *env_template*.

## Useful Commands
### Container Management
##### Shut Down All Containers
  The database will be preserved.
  All docker images, networks, and volumes will be preserved.
```Shell
docker compose down
```
##### Stop aAd Delete One Service (services defined in *docker-compose.yml*)
```Shell
docker compose rm -s -f <service name>
docker compose rm -s -f adempiere.db
docker compose rm -s -f adempiere-zk
etc.
```
##### Stop And Delete All Services
```Shell
docker compose rm -s -f
```
##### Create And Restart All Services
```Shell
docker compose up -d
```
##### Stop One Single Service
```Shell
docker compose stop <service name>
docker compose stop adempiere-site
etc.
```
##### Start One Single Service (after it was stopped)
```Shell
docker compose start <service name>
docker compose start adempiere-site
etc.
```
##### Start And Stop One Single Service
```Shell
docker compose restart <service name>
docker compose restart adempiere-site
etc.
```
##### Find Containers And Services
```Shell
docker compose ps -a
```

### Misc Commands
##### Display All Docker Images
```Shell
docker images -a
```

##### Display All Docker Containers
```Shell
docker ps -a
docker ps -a --format "{{.ID}}: {{.Names}}"
```

##### Debug I: Display Values To Be Used In Application
Renders the actual data model to be applied on the Docker engine by merging *env_template* and *docker-compose.yml*.
If you have modified *env_template*, make sure to copy it to *.env*.
```Shell
cp env_template .env
docker compose convert

```

##### Debug II: Display Container Logs
```Shell
docker container logs <CONTAINER>                         -->> variable defined in *env_template*
docker container logs <CONTAINER> | less                  -->> variable defined in *env_template*
docker container logs adempiere-all.postgres
docker container logs adempiere-all.postgres | less

```

##### Debug III: Display Container Values
Display the values a container is working with.
```Shell
docker container inspect <CONTAINER>
docker container inspect adempiere-all.postgres
docker container inspect adempiere-all.zk
etc.

```

##### Debug IV: Log Into Container
```Shell
docker container exec -it <CONTAINER> <COMMAND>                
docker container exec -it adempiere-all.postgres bash
etc.

```

##### Delete Database On Host I (Using Docker File System)
Physically delete database from the host via Docker elements.
Sometimes it is needed to delete all files that comprises the database.
Be careful with these commands, once done, there is no way to undo it!
The database directory must be empty for the restore to work.
```Shell
sudo ls -al /var/lib/docker/volumes/<POSTGRES_VOLUME>              -->> variable defined in *env_template*
sudo ls -al /var/lib/docker/volumes/adempiere-all.volume_postgres  -->> default value

sudo rm -rf /var/lib/docker/volumes/<POSTGRES_VOLUME>/_data
sudo rm -rf /var/lib/docker/volumes/adempiere-all.volume_postgres/_data
```

##### Delete Databse On Host II (using mounted volume on host)
Physically delete database from the host via mounted volumes.
Sometimes it is needed to delete all files that comprises the database.
Be careful with these commands, once done, there is no way to undo it!
The database directory must be empty for the restore to work.
```Shell
sudo ls -al <POSTGRES_DB_PATH_ON_HOST>                         -->> variable defined in *env_template*
sudo ls -al <PATH TO REPOSITORY>/postgresql/postgres_database  -->> default value

sudo rm -rf <POSTGRES_DB_PATH_ON_HOST>
sudo rm -rf <PATH TO REPOSITORY>/postgresql/postgres_database
```
