
FROM debian:jessie
MAINTAINER Bram Harmsen <bramharmsen@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

# install mariadb
RUN apt-get update && \
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
	echo "deb http://mariadb.mirror.triple-it.nl//repo/10.0/debian wheezy main" >> /etc/apt/sources.list && \
	echo "deb-src http://mariadb.mirror.triple-it.nl//repo/10.0/debian wheezy main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install -y mariadb-server

# adding files
COPY ./COPY/my.cnf 							/etc/mysql/my.cnf
COPY ./COPY/bootstrap.sh 					/usr/local/bin/bootstrap.sh
COPY ./COPY/create_mariadb_admin_user.sh	/usr/local/bin/create_mariadb_admin_user.sh
RUN chmod +x /usr/local/bin/*

# configuration options
ENV MYSQL_BIND_ADDRESS 0.0.0.0
ENV MYSQL_PORT 3306
# only applies when /var/lib/mysql/mysql is empty
ENV MYSQL_ADMIN_PASS password
ENV MYSQL_ADMIN_USER admin
ENV MYSQL_ADMIN_HOST %

# Add volumes
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

# Expose ports
EXPOSE 3306

# Run bootstrap
CMD ["/usr/local/bin/bootstrap.sh"]