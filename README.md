# ADempiere All Services
 A *docker compose* project defines all services needed to run ADempiere on ZK and Vue. 
 When executed, the *docker compose* project eventually runs the services defined in file *docker-compose.yml* as Docker containers.
 The running Docker containers comprise the application.

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
- *volume_postgres*: defines the mounting point of the Postgres database (directory **/var/lib/postgresql/data**) to a local directrory on the host where the Docker container runs.
- *volume_backups*: defines the mounting point of a backup directory on the Docker container to a local directrory on the host where the Docker container runs.

### File Structure
- *README.md*: this very file
- *docker-compose.yml*: the docker compose definition file. Here are defined all services.
  Variables used in this file are taken from file *.env*.
- *.env*: definition of all variables used in *docker-compose.yml*.
- *env_template*: template for definition of all variables.
- *start-all.sh*: shell script to start docker compose.
- *stop-and-delete-all.sh*: shell script to delete all containers, images, networks and volumnes created with *start-all.sh*
- *postgresql/Dockerfile*: the Dockerfile used.
- *postgresql/initdb.sh*: Postgres starting shell script.It launches a restore database when there is none and a backup exists.
- *postgresql/postgres_database*: the mounting point on the host for the database from the Postgres Container. This makes sure that the database is not deleted even if the docker containers, docker images and even docker are deleted.
- *postgresql/backups*: the mounting point for the backups/restores from the Postgres Container.

## Run Docker Compose

You can also run it with `docker compose` for develop enviroment. Note that this is a easy way for start the service with PostgreSQL and middleware.

### Requirements

- [Docker Compose v2.16.0 or later](https://docs.docker.com/compose/install/linux/)

```Shell
docker compose version
Docker Compose version v2.16.0
```

## Run it

Just clone it

Before it you should copy your database to `adempiere-all-service/postgresql/seed.backup`

```Shell
git clone https://github.com/adempiere/adempiere-all-services
cd adempiere-all-services
cp env_template .env
```

```Shell
docker compose up
```

Open browser in the follow url [http://localhost:8080](http://localhost:8080)


![ADempiere Vue](docs/ADempiere_All_Services_Vue.gif)

![ADempiere ZK](docs/ADempiere_All_Services_ZK.gif)
