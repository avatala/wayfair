####################################################
### DVT Installation sctipt for centos 7 machine ###
####################################################

## prerequisites:
# Place the app.py and google_pso_data_validator-2.6.0.1-py2.py3-none-any.whl package under /opt/apps/dvt folder
# Make sure to have this execution permission for the script centos-dvt-deploy.sh (chmod 755 centos-dvt-deploy.sh)

#!/bin/bash

LOG_FILE=/var/log/dvt_installation.log
APP_DIR=/opt/apps/dvt/

LOG()
{
    printf "$(date '+%Y-%b-%d %H:%M:%S') - $0 - $* \n" >> ${LOG_FILE}
}


# Save the current directory
ORIGINAL_DIR=$(pwd)

# Adding if /usr/local/bin is not present in the default path
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
  LOG "/usr/local/bin is not in the default \$PATH. Adding it now..."
  export PATH="/usr/local/bin:$PATH"
  LOG "export PATH=\"/usr/local/bin:\$PATH\"" >> ~/.bashrc
fi

# Check if SELinux is enabled
if [[ $(getenforce) == "Enforcing" ]]; then
    LOG "Info: SELinux is enabled, disabling it..."
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
    LOG "Info: SELinux has been disabled."
else
    LOG "Info: SELinux is already disabled."
fi


# Install dependency packages
LOG "Info: gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel wget make Installation"
sudo yum update -y
sudo yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel wget make
yum clean all
LOG "Info: gcc openssl-devel bzip2-devel libffi-devel zlib-devel xz-devel wget make Installation successfull"

# Install Python3.7 packages
LOG "Info: Starting Python-3.7.11 installation"
sudo wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz -P /usr/src
sudo tar -xzf /usr/src/Python-3.7.11.tgz -C /usr/src
cd /usr/src/Python-3.7.11
sudo ./configure --enable-optimizations 
sudo make altinstall 

# Check if Python 3.7 is installed
if ! command -v python3.7 &> /dev/null
then
    LOG "ERROR: Python 3.7 is not installed successfully. Exit 1"
    exit 1
else
    LOG "Info: Completed Python-3.7.11 installation"
fi


# Change back to the original directory
cd $ORIGINAL_DIR


# Install google-pso-data-validator and its packages
LOG "Info: google-pso-data-validator Installation"
pip3.7 install --upgrade pip
pip install /opt/apps/dvt/google_pso_data_validator-2.6.0.1-py2.py3-none-any.whl
pip install pyodbc

#pip install /opt/m2m-wayfair/3-migration-framework/apps/dvt/


# odbc 17 installation
LOG "Info: ODBC 17 installation"
curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
sudo yum remove unixODBC-utf16 unixODBC-utf16-devel
sudo ACCEPT_EULA=Y yum install -y msodbcsql17
sudo ACCEPT_EULA=Y yum install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo yum install -y unixODBC-devel


# Install gunicorn, supervisor, and nginx:
LOG "Info: gunicorn, supervisor and nginx Installation"
pip install gunicorn
sudo yum install -y supervisor nginx  

# Add the default port nginx configuration 
LOG "Info: Add the default port nginx configuration to 9082"
config="
    server {
        listen       9082;
        listen       [::]:9082;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
"

# Backup the original nginx.conf file
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

# Remove the last curly brace in the original nginx.conf file
sed -i '/^\s*}$/d' /etc/nginx/nginx.conf.bak

# Append the new configuration block
echo "$config" | sudo tee -a /etc/nginx/nginx.conf >/dev/null

# Add back the closing curly brace
echo "}" | sudo tee -a /etc/nginx/nginx.conf >/dev/null

# Get public IP address
PUBLIC_IP=$(curl -s ifconfig.me)

LOG "Info: Add the default port nginx configuration to 9082"

 
# Create a gunicorn and write a dvt execution details
cat << EOF > $APP_DIR/gunicorn.conf.py
bind = "127.0.0.1:8080"
worker = 3
accesslog = '/var/log/dvt_access.log'
errorlog = '/var/log/dvt_error.log'
EOF
LOG "Info: $APP_DIR/gunicorn.conf.py file created successfully"

 
# Create a supervisor file with execution details
cat << EOF > /etc/supervisord.d/dvt.ini
[program:app]
command=gunicorn app:app -c $APP_DIR/gunicorn.conf.py
directory=$APP_DIR
user=root
autostart=true
autorestart=true
redirect_stderr=true
EOF
LOG "Info: /etc/supervisord.d/dvt.ini file created successfully"


# Create a nginx file with the dvt details
cat << EOF > /etc/nginx/conf.d/dvt.conf
server {
    listen 9082;
    server_name ${PUBLIC_IP};
    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
LOG "Info: /etc/nginx/conf.d/dvt.conf file created successfully"


# Restart Nginx and Supervisor
sudo systemctl restart nginx
sudo systemctl restart supervisord

LOG "Info: DVT application available in http://${PUBLIC_IP}:9082"
echo "Info: DVT application available in http://${PUBLIC_IP}:9082"