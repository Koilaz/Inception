#!/bin/sh

chown -R mysql:mysql /var/lib/mysql /run/mysqld

# 1. Initialiser le répertoire de données s'il est vide
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # 2. Démarrer MariaDB en arrière-plan pour exécuter l'initialisation
    mariadbd-safe &

    # Attendre que la base soit prête à accepter des connexions
    sleep 5

    # 3. Exécuter les commandes SQL de configuration
    mariadb -u root -e "
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '$(cat /run/secrets/db_password)';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$(cat /run/secrets/db_root_password)';
        FLUSH PRIVILEGES;
    "

    # 4. Arrêter le serveur de fond pour le relancer proprement au premier plan
    mariadb-admin -u root -p$(cat /run/secrets/db_root_password) shutdown
	echo "Maria Db database Initialised"

	else
	echo "Maria Db Already Initialised"

fi

# 5. Démarrer MariaDB au premier plan pour maintenir le conteneur actif
echo "Maria Db launched"
exec mariadbd-safe
