#!/bin/bash


LOG_FILE=/var/log/dvt_installation.log

LOG()
{
    printf "$(date '+%Y-%b-%d %H:%M:%S') - $0 - $* \n" >> ${LOG_FILE}
}


# Install dvt packages
LOG "Info: Python3.7 Installation"
sudo apt-get install python3.7 -y
sudo apt-get install python3-dev -y

sudo apt-get update  && sudo apt-get install gcc -y && sudo apt-get clean

LOG "Info: ODBC 17 installation"
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list > /etc/apt/sources.list.d/mssql-release.list
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get install -y unixodbc-dev

LOG "Info: google-pso-data-validator Installation"
sleep 15
sudo apt-get install python3-pip -y
pip install --upgrade pip
pip install google-pso-data-validator
pip install pyodbc

sleep 5
pip install /opt/m2m-wayfair/3-migration-framework/apps/dvt/


# Install gunicorn, supervisor, and nginx:
LOG "Info: gunicorn, supervisor and nginx Installation"
sudo pip install gunicorn
sudo apt-get install supervisor -y
sudo apt-get install nginx -y

# Get public IP address
PUBLIC_IP=$(curl -s ifconfig.me)

# Create a gunicorn and write a dvt execution details
sudo mkdir /etc/gunicorn.d/
cat << EOF > /etc/gunicorn.d/main
# /etc/gunicorn.d/main
name = 'main'
workers = 3
user = 'root'
bind = '127.0.0.1:8080'
chdir = '/opt/m2m-wayfair/3-migration-framework/apps/dvt/'
accesslog = '/var/log/dvt_access.log'
errorlog = '/var/log/dvt_error.log'
EOF
LOG "Info: /etc/gunicorn.d/main file created successfully"

# Create a supervisor file with execution details
cat << EOF > /etc/supervisor/conf.d/main.conf
[program:main]
command=gunicorn main:app -c /etc/gunicorn.d/main
directory=/opt/m2m-wayfair/3-migration-framework/apps/dvt/
user=root
autostart=true
autorestart=true
redirect_stderr=true
EOF
LOG "Info: /etc/supervisor/conf.d/main.conf file created successfully"

# Create a nginx file with the dvt details

cat << EOF > /etc/nginx/sites-available/main
server {
    listen 80;
    server_name ${PUBLIC_IP};

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        #proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
LOG "Info: /etc/nginx/sites-available/main file created successfully"

# Create the symbolic link for Nginx
if [ ! -h "/etc/nginx/sites-enabled/main" ]; then
  echo "main file not linked, creating symlink"
  ln -s /etc/nginx/sites-available/main /etc/nginx/sites-enabled/
fi

# Restart Nginx and Supervisor
sudo systemctl restart nginx
sudo systemctl restart supervisor

LOG "Info: DVT application available in http://${PUBLIC_IP}"