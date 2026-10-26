FROM postgres:18.6-alpine

COPY ./bin/*.sh /bin/
COPY install.sql /docker-entrypoint-initdb.d/

RUN apk add --no-cache musl-locales musl-locales-lang
ENV LANG=es_MX.UTF-8 \
    LC_ALL=es_MX.UTF-8

EXPOSE 5432
