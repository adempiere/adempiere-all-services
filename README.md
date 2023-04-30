# ADempiere All Services
 A *docker compose* project defines all services needed to run ADempiere on ZK and Vue. 
 
 When executed, the *docker compose* project eventually runs the services defined in file *docker-compose.yml* as Docker containers.
 The running Docker containers comprise the application.

## General Explanations
### User's perspective
From a user's point of view, the application consists of the following:
- A home web site accesible via port **8080**, from which all applications can be called
- An ADempiere ZK UI accesible via port **8888**
- An ADempiere Vue UI accesible via port **8891**
- A Postgres databasee accesible via port **55432**

### Application Stack
The application stack consists of the following services defined in *docker-compose.yml*, which eventually will be run as containers:
- *adempiere.db*: defines the Postgres database 
- *adempiere-zk*: defines the Jetty server and the ADempiere ZK UI
- *adempiere-site*: defines the landing page (web site) for this application
- *adempiere-middleware*:
- *adempiere-backend-rs*:
- *adempiere-grpc-server*: defines the grpc server for Vue
- *vue-api*:
- *vue-ui*: defines ADempiere Vue UI

Additional objects defined in *docker-compose.yml*
- *adempiere_network*: defines the subnet used in the involved Docker containers (**192.168.100.0/24**)
- *volume_postgres*: defines the mounting point of the Postgres database (directory **/var/lib/postgresql/data**) to a local directory on the host where the Docker container runs.
- *volume_backups*: defines the mounting point of a backup directory on the Docker container to a local directrory on the host where the Docker container runs.

### File Structure
- *README.md*: this very file
- *docker-compose.yml*: the docker compose definition file. Here are defined all services.
  Variables used in this file are taken from file *.env*.
- *.env*: definition of all variables used in *docker-compose.yml*.
- *env_template*: template for definition of all variables.
- *start-all.sh*: shell script to automatically execute docker compose.
- *stop-and-delete-all.sh*: shell script to delete all containers, images, networks and volumnes created with *start-all.sh*
- *postgresql/Dockerfile*: the Dockerfile used.
- *postgresql/initdb.sh*: shell script executed when Postgres starts. It launches a restore database when there is no database and a backup exists.
- *postgresql/postgres_database*: mounting point on the host for the Postgres container's database. This makes sure that the database is not deleted even if the docker containers, docker images and even docker are deleted.
- *postgresql/backups*: the mounting point for the backups/restores from the Postgres container.

## Installation
### Requirements
##### Install Tools
Make sure to install the following:
- JDK  11
- Docker
- Docker compose: [Docker Compose v2.16.0 or later](https://docs.docker.com/compose/install/linux/)
- Git

##### Check versions
Check `java version`:
```Shell
java --version
    openjdk 11.0.11 2021-04-20
    OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
    OpenJDK 64-Bit Server VM AdoptOpenJDK-11.0.11+9 (build 11.0.11+9, mixed mode
```
Check `docker version`:
```Shell
docker --version
    Docker version 23.0.3, build 3e7cbfd
```
Check `docker compose version`:
```Shell
docker compose version
    Docker Compose version v2.17.2
```
### Clone This Repository
```Shell
git clone https://github.com/SusanneCalderon/adempiere-all-services
cd adempiere-all-services
```

### Manual Execution
Alternative to **Automatic Execution**.
Recommendable for the first installation.
- Create the directory on the host where the database will be mounted:
```Shell
mkdir postgresql/postgres_database
```
- Create the directory on the host where the backups will be mounted:
```Shell
mkdir postgresql/backups
```
- If you're executing this project for the first time or you want to restore the database, copy a database backup (the file must be named `seed.backup`) to `adempiere-all-service/postgresql/backups`. 
Make sure it is not the compressed backup (e.g. .jar):
```Shell
cp <PATH-TO-BACKUP-FILE> postgresql/backups
```
- Modify *env_template* as needed and copy it to *.env*:
```Shell
cp env_template .env
```
- Modify `postgresql/initdb.sh` as necessary, depending on the backup file you are using. 
  A different restore command is needed in *postgresql/initdb.sh* depending on the way the backup was done (*RUN_DBExport.sh* or *pg_dump*).
- Run `docker compose`:
```Shell
docker compose up -d
```

**Result: all images are downloaded, containers and other docker objects created, containers are started, and database restored**.

This might take some time, depending on your bandwith and the size of the restore file.
### Automatic Execution
Alternative to **Manual Execution**.
Recommendable when docker compose was run before.

Execute script `start-all.sh`:
```Shell
./start-all.sh
```
The script *start-all.sh* carries out the steps of the manual installation.
If directories *postgresql/postgres_database* and *postgresql/backups* do not exist, they are created.

If 
- there is a file *seed.backup* in *postgresql/backups*, and 
- the database as specified in *postgresql/initdb.sh* does not exist in Postgres, and
- directory *postgresql/postgres_database* has no contents

**The database  will be restored**.

If directory *postgresql/postgres_database* has contents, no restore will be executed (actually, *postgresql/initdb.sh* will be ignored).


**Result: all images are downloaded, containers and other docker objects created, containers are started, and -depending on conditions explained before- database restored**.

This might take some time, depending on your bandwith and the size of the restore file.
## Open Applications
- Project site: open browser and type in the following url [http://localhost:8080](http://localhost:8080)

  From here, the user can navigate to ZK UI or Vue UI.
- Adempiere ZK: open browser and type in the following url [http://localhost:8888/webui](http://localhost:8888/webui)
- Adempiere Vue:open browser and type in the following url [http://localhost:8891/#/login?redirect=%2Fdashboard](http://localhost:8891/#/login?redirect=%2Fdashboard)
## Close Containers
- All containers will shut down.
- The database will be preserved.
- All docker images, networks, and volumes will be preserved.
```Shell
docker compose down
```
- Stop and delete one service
```Shell
docker compose rm -s -f adempiere.db
docker compose rm -s -f adempiere-zk
```
- Stop and delete all services
```Shell
docker compose rm -s -f
```
- Create and restart all services
```Shell
docker compose up -d
```

## Delete All Docker Objects
Sometimes, you need to undo everything and start anew.

Then, 
- All Docker containers must be shut down.
- All Docker containers must be deleted.
- All Docker images must be deleted.
- The Docker installation cache must be cleared.
- All Docker networks and volumes must be deleted.

Execute command:
```Shell
./stop-and-delete-all.sh
```
## Access to Database
Connect via port **55432** with a DB connector.

![ADempiere Vue](docs/ADempiere_All_Services_Vue.gif)

![ADempiere ZK](docs/ADempiere_All_Services_ZK.gif)
