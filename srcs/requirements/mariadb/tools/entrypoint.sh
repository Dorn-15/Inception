#!/bin/sh
set -e

SQL_PATH="/var/lib/mysql"

if [ ! -d ${SQL_PATH}/mysql ]; then
    mariadb-install-db --user=mysql --ldata=${SQL_PATH} > /dev/null
    mariadbd --user=mysql --skip-networking &
    pid="$!"
    sleep 5

    mariadb -uroot <<-SQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        DELETE FROM mysql.user WHERE User='';
        FLUSH PRIVILEGES;
SQL

    mariadb -uroot -p"${SQL_ROOT_PASSWORD}" <<-SQL
        CREATE DATABASE IF NOT EXISTS \`${SQL_DB}\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${SQL_DB}\`.* TO '${SQL_USER}'@'%';
        FLUSH PRIVILEGES;
SQL

    mysqladmin -uroot -p"${SQL_ROOT_PASSWORD}" shutdown
    wait "$pid" || true
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0
