# ADempiere All Services
All services integrated for run with a docker compose. This is a simple project with compose with all project images.


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
