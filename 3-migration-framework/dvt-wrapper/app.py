"""
This file will be used for adding all the configurations, end-points, etc... to run the application
"""
from flask import Flask
from flask_cors import CORS
from flask_restful import Api
from google.cloud import logging as cloud_logging
from routes.route import bp

client = cloud_logging.Client()
client.setup_logging()

app = Flask(__name__)

# Registering the Blueprint with Flask App.
app.register_blueprint(bp)


CORS(app)
api = Api(app)
app.config[
    "SQLALCHEMY_DATABASE_URI"
] = "postgresql://postgres:<password>@<host_name>:<port:5432>/<db_name>"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = True
