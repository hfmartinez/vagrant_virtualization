#!/bin/bash

# Variables (these should be passed as environment variables)
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-"your_root_password"}
DB_NAME=${DB_NAME:-"universidad"}
DB_HOST=${DB_HOST:-"localhost"}
APP_HOST=${APP_HOST:-"localhost"}
APP_DIR=${APP_DIR:-"/home/vagrant/app"}
HOSTNAME=$(hostname)

# Update the system
apt-get update
apt-get upgrade -y

# Install essential packages only for the database server
if [[ "$HOSTNAME" == "db" ]]; then

    # Install essential packages for the database server
    apt-get install -y mysql-server python3 python3-pip python3-dev default-libmysqlclient-dev build-essential pkg-config libmysqlclient-dev

    # Set MySQL bind address to allow external connections
    sed -i "s/^bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

    # Ensure MySQL is running
    service mysql start

    # Change root user authentication method and set password
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE USER 'root'@'${APP_HOST}' IDENTIFIED WITH mysql_native_password BY '${DB_ROOT_PASSWORD}';"

    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "ALTER USER 'root'@'${APP_HOST}' IDENTIFIED WITH mysql_native_password BY '${DB_ROOT_PASSWORD}';"

    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'${APP_HOST}' WITH GRANT OPTION;"

    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

    # Create the database
    mysql -u root -p"${DB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

    # Load initial data from SQL file if it exists
    if [ -f /vagrant/init_data.sql ]; then
        mysql -u root -p"${DB_ROOT_PASSWORD}" "${DB_NAME}" < /vagrant/init_data.sql
    fi

    # Restart MySQL service to apply changes
    service mysql restart

    # Install Python MySQL client
    pip3 install mysqlclient
    
else
    # For the FastAPI application server, only install the Python dependencies
    apt-get install -y python3 python3-pip

    # Create application directory
    mkdir -p "${APP_DIR}"

    # Copy application code from the host to the app directory
    cp -r /vagrant/app/* "${APP_DIR}/"

    # Install Python dependencies from requirements.txt
    if [ -f "${APP_DIR}/requirements.txt" ]; then
        pip3 install -r "${APP_DIR}/requirements.txt"
    fi

    # Create .env file
    cat <<EOL > "${APP_DIR}/.env"
    DB_USER=root
    DB_PASSWORD=${DB_ROOT_PASSWORD}
    DB_HOST=${DB_HOST}
    DB_DATABASE=${DB_NAME}
EOL

    # Create systemd service file for FastAPI
    cat <<EOL > /etc/systemd/system/fastapi.service
    [Unit]
    Description=FastAPI Application
    After=network.target

    [Service]
    User=vagrant
    WorkingDirectory=${APP_DIR}
    ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 5500 --proxy-headers
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOL

    # Reload systemd to recognize the new service
    systemctl daemon-reload

    # Enable FastAPI service to start on boot
    systemctl enable fastapi

    # Start FastAPI service
    systemctl start fastapi

fi
