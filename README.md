<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
Table of Contents

- [Docker MariaDB 10.0](#docker-mariadb-100)
- [Building image](#building-image)
- [Running container](#running-container)
  - [Just run](#just-run)
  - [Recommended use](#recommended-use)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Docker MariaDB 10.0

Docker images of MariaDB 10.0 build on Debian Jessie. Admin user, password, host and ports can be set using environmental variables.

# Building image

```shell
$ git clone https://github.com/bremme/docker-mariadb.git
$ sudo docker build -t bremme/mariadb .
```

# Running container

## Just run

```shell
$ sudo docker run \
    --env=MYSQL_ADMIN_PASS=password \
    --publish=3306:3306 \
    --name=mariadb \
    --detach=true \
    bremme/mariadb
```

To connect to the MariaDB instance you will need the containers IP address (and port). You can grab this from stdout:

```shell
$ sudo docker logs mariadb
```

Or you could use docker inspect:

```shell
$ sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' mariadb
```

Once you have the IP (and port) you can just connect to the database using any client, for example using the mysql cli client:

```shell
$ mysql -h<container_ip_address> -p<container_published_port \
    -uadmin -p<password>
```

## Recommended use

It's recommended to use a separate data only container which exposes two volumes: "/etc/mysql" and "/var/lib/mysql". These volumes will be mounted in the MariaDB containerer using "--volumes-from". Furthermore for some added security I'm using a file "__private_vars.env" to pass in the admin database user and password. Be sure to restrict permissions (e.g. "chmod 400") and add to (global) .gitignore.

```shell
docker run \
    --env-file=__private_vars.env \
    --volumes-from=data-mariadb \
    --volume=/etc/timezone:/etc/timezone:ro \
    --publish=3306:3306 \
    --name mariadb \
    --restart=always \
    --detach=true \
    bremme/mariadb
```

For convienence the above command have been added to a run script:

```shell
$ sudo ./run
```