#!/bin/bash

# Ensure the script is being run as sudo (root)
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root privileges. Please enter your sudo password."
    sudo -v  # This will prompt the user for the sudo password if necessary
fi

# Initial Information
domain_name=$(hostname -I | awk '{print $1}')  # Automatically get the server's IP address
read -p "Enter the WordPress project folder name (e.g., 'myproject'): " project_name
project_path="/var/www/html/$project_name"

# MySQL credentials
read -p "Enter the MySQL username: " db_user
read -p "Enter the MySQL password: " db_password
echo

# Check if the provided directory exists, if not, create it
if [ ! -d "$project_path" ]; then
    echo "The directory $project_path does not exist. Creating it now..."
    sudo mkdir -p $project_path
    sudo chown -R $USER:$USER $project_path  # Give ownership to the current user
else
    echo "Directory $project_path already exists."
fi

# Update and install necessary packages
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 mysql-server php php-mysql php-fpm php-xml php-gd php-mbstring php-curl php-zip wget unzip

# Configure MySQL for a new database
sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE $project_name;
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $project_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Go to the user-provided project directory
cd $project_path

# Download WordPress
sudo wget https://wordpress.org/latest.tar.gz

# Extract WordPress in the same directory and clean up
sudo tar -xzvf latest.tar.gz --strip-components=1  # --strip-components=1 removes the top level directory from extraction
sudo rm latest.tar.gz

# Configure WordPress wp-config.php
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$project_name/" wp-config.php
sudo sed -i "s/username_here/$db_user/" wp-config.php
sudo sed -i "s/password_here/$db_password/" wp-config.php

# Set proper permissions for WordPress files
sudo chown -R www-data:www-data $project_path
sudo chmod -R 755 $project_path

# Apache configuration for the new project
sudo bash -c "cat > /etc/apache2/sites-available/$project_name.conf <<EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    ServerName $domain_name
    DocumentRoot /var/www/html
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"

# Enable the new site configuration and restart Apache
sudo a2ensite $project_name.conf
sudo systemctl restart apache2

# Enable mod_rewrite for WordPress
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "WordPress project installation and configuration completed successfully in '$project_path'!"

