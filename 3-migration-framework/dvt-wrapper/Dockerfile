FROM python:3.10-slim
# Allow statements and log messages to immediately appear in the Knative logs
ENV PYTHONUNBUFFERED True
# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
ARG PORT=8080
ENV PORT_NUMBER=$PORT
CMD exec gunicorn --bind :$PORT_NUMBER --workers 1 --threads 8 --timeout 0 app:app
