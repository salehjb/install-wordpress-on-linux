# WordPress Auto Installer

## Overview
This bash script automates the installation and configuration of WordPress on an Ubuntu server. It installs all necessary dependencies, sets up a MySQL database, configures Apache, and deploys WordPress in a specified project directory.

## Features
- **Automated installation** of Apache, MySQL, PHP, and required extensions.
- **WordPress deployment** with automatic downloading and setup.
- **Database configuration** with user-defined credentials.
- **Apache virtual host configuration** for seamless access.
- **File permission adjustments** for security and stability.

## Prerequisites
Ensure you have the following before running the script:
- Ubuntu-based OS
- sudo/root privileges
- Internet connection

## Installation & Usage
1. Clone or download the script:
   ```sh
   git clone https://github.com/your-repo/wordpress-installer.git
   cd wordpress-installer
   ```
2. Grant execute permissions:
   ```sh
   chmod +x install_wordpress.sh
   ```
3. Run the script with sudo:
   ```sh
   sudo ./install_wordpress.sh
   ```
4. Follow the on-screen prompts to enter the project name and MySQL credentials.

## Installation Directory
The WordPress installation will be placed in:
```
/var/www/html/<project_name>
```
where `<project_name>` is the name you specify during installation.

## Post-Installation Steps
- Navigate to `http://your-server-ip/` to complete the WordPress setup.
- Secure your installation:
  ```sh
  sudo mysql_secure_installation
  ```
- Adjust firewall settings if needed:
  ```sh
  sudo ufw allow 'Apache Full'
  ```

## Troubleshooting
- **Permission Issues**: Ensure the script is run with `sudo`.
- **Apache Not Restarting**: Check logs using:
  ```sh
  sudo journalctl -xe
  ```
- **Database Connection Errors**: Verify MySQL credentials in `wp-config.php`.

## Contributions
Feel free to fork the repository and submit pull requests for improvements.

## License
This project is licensed under the MIT License.
