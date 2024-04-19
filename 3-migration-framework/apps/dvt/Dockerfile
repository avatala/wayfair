FROM python:3.9-slim

# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./


# Install production dependencies.
RUN apt-get update \
    && apt-get install gcc -y && apt-get install curl -y && apt-get install -y gnupg2 \
    && apt-get install -y unixodbc-dev && apt-get install -y libgssapi-krb5-2 \
    && apt-get clean
RUN pip install --upgrade pip
#Download the desired package(s)
RUN su
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN exit

RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && ACCEPT_EULA=Y apt-get install -y mssql-tools \ 
    && apt-get clean 
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
# RUN source ~/.bashrc
RUN pip install pyodbc
#RUN pip install Flask gunicorn google_pso_data_validator
RUN pip install Flask gunicorn
RUN python3 -m pip install $APP_HOME


# Hive/Impala Dependencies 
# RUN pip install hdfs
# RUN pip install thrift-sasl

# Oracle Dependencies
# if you are using Oracle you should add .rpm files
# under your license to a directory called oracle/
# and then uncomment the setup below.

# ENV ORACLE_SID oracle
# ENV ORACLE_ODBC_VERSION 12.2
# ENV ORACLE_HOME /usr/lib/oracle/${ORACLE_ODBC_VERSION}/client64

# RUN pip install cx_Oracle
# RUN apt-get -y install --fix-missing --upgrade vim alien unixodbc-dev wget libaio1 libaio-dev

# COPY oracle/*.rpm ./
# RUN alien -i *.rpm && rm *.rpm \
#     && echo "/usr/lib/oracle/${ORACLE_ODBC_VERSION}/client64/lib/" > /etc/ld.so.conf.d/oracle.conf \
#     && ln -s /usr/include/oracle/${ORACLE_ODBC_VERSION}/client64 $ORACLE_HOME/include \
#     && ldconfig -v


# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app
