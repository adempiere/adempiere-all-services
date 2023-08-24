ARG POSTGRES_IMAGE
FROM $POSTGRES_IMAGE

# Command wget might be used for downloading the standard Adempiere Database in initdb.sh
RUN echo 'Update APT package handling utility'
RUN  apt-get update
RUN echo 'Install wget'
RUN apt-get install -y wget
RUN echo 'wget installed'

COPY --chown=1  initdb.sh /docker-entrypoint-initdb.d
RUN chmod +x /docker-entrypoint-initdb.d/initdb.sh 

# The following commands are not required, because the volume definition creates the directories on container.
#RUN mkdir $HOME_PATH_ON_CONTAINERS
#RUN mkdir ${POSTGRES_DB_BACKUP_PATH_ON_CONTAINER}   # =${HOME_PATH_ON_CONTAINERS}/backups
