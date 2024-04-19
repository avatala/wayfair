# Deploy a Python Flask Restful API app using gunicorn, supervisor, and nginx.
## This execution has 2 types. 
    1) Wheel package installation
    2) Complie and run the whole DVT code.
## prerequisites:
* The script (ubuntu-dvt-deploy.sh) well suited for ubuntu (20.04.1-Ubuntu) based system with x86/64 architecture.
* The script (centos-dvt-deploy.sh) well suited for centos (centos el7.x86_64) based system with x86/64 architecture.
### Wheel package installation
* If you choose to install a wheel package, Please place the app.py and google_pso_data_validator-2.6.0.1-py2.py3-none-any.whl package under /opt/apps/dvt folder
* Copy the script to the machine and make sure to have execute permission (e.x: chmod 755 centos-dvt-deploy.sh)
* Navigate to the script directory and Execute the script by running ./centos-dvt-deploy.sh
* Installation, access and error logs present in /var/log/ directory
### Clone the DVT code repo to the application (/opt) directory
* If you choose to compile the DVT code and install it, Please clone the repo into the /opt directory.
    1) git clone https://github.com/66degrees/m2m-wayfair.git /opt/m2m-wayfair
* dvt-deploy script present under /opt/m2m-wayfair/3-migration-framework/deployments/dvt/ and make sure to have execute permission (e.x: chmod 755 ubuntu-dvt-deploy.sh)
* Navigate to the script directory and Execute the script by running ./ubuntu-dvt-deploy.sh
* Installation, access and error logs present in /var/log/ directory