#!/bin/sh
set -e

DB_PATH="/var/lib/mysql"
DB_NAME="${MYSQL_DATABASE}"
DB_USER="${MYSQL_USER}"
DB_PASS="$(cat /run/secrets/db_password.txt)"
DB_ROOT_PASS="$(cat /run/secrets/db_root_password.txt)"

if [ ! -d ${DB_PATH}/mysql ]; then
	mariadb-install-db --user=mysql --ldata=${DB_PATH} > /dev/null
	mariadbd --user=mysql --skip-networking &
	pid="$!"
	sleep 5

	mariadb -uroot <<-SQL
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
		CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}';
		GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
		DELETE FROM mysql.user WHERE User='';
		FLUSH PRIVILEGES;
SQL

	mariadb -uroot -p"${DB_ROOT_PASS}" <<-SQL
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		FLUSH PRIVILEGES;
SQL

	mysqladmin -uroot -p"${DB_ROOT_PASS}" shutdown
	wait "$pid" || true
fi

exec mariadbd --user=mysql --bind-address=0.0.0.0 --port=3306 --skip-networking=0
