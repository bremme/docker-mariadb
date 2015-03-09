#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

MYSQL_CNF=/etc/mysql/my.cnf

sed -i -r 's/.*bind-address.*$/bind-address = '$MYSQL_BIND_ADDRESS'/' $MYSQL_CNF
sed -i -r 's/port\s*=.*$/port\t=\t'$MYSQL_PORT'/' $MYSQL_CNF


if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MariaDB volume is detected in $VOLUME_HOME"
    echo "=> Installing MariaDB ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"  
    /usr/local/bin/create_mariadb_admin_user.sh
else
    echo "=> Using an existing volume of MariaDB"
fi

exec mysqld_safe --defaults-file=$MYSQL_CNF
