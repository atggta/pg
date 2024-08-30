FROM postgres:15.4-alpine3.18

ARG DBNAME=db
ARG DBUSER=app
ARG DBPASS=pass

ENV POSTGRES_DB=$DBNAME
ENV POSTGRES_USER=$DBUSER
ENV POSTGRES_PASSWORD=$DBPASS
COPY custom.sh /usr/local/bin/custom.sh

COPY docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

RUN custom.sh postgres
