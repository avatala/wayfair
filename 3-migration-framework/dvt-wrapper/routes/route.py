"""
This file is for routes, which will have all HTTP methods for the json request.
"""
from controllers.controller import HealthCheck, WrapperController
from exceptions.loggers import Logger
from flask import Blueprint, request
from flask_restful import Api, Resource
from schema_mappings import schema

# Registering the Blueprint for dvt-routes.
bp = Blueprint("routes", __name__, url_prefix="/")
apps = Api(bp)


class DVTWrapper(Resource):
    """Class for DVTWrapper API."""

    def post(self, **kwargs):
        """
        The get function is used to get the response from dvt-wrapper.
        :param self: Represent the instance of the class
        :param **kwargs: Pass a variable number of keyword arguments to a function
        :return: The response in the form of a dictionary
        :method: GET
        :doc-author: Kaoushik Kumar
        """
        try:
            # The below line will be used to validate Request Payload using Pydantic BaseModel.
            payload = schema.SourceTargetPayload(**request.get_json())
            # The below will take the request payload and send that to dvt-wrapper.
            response = WrapperController().wrapper(payload.dict())
            return response
        except Exception as e:
            Logger().logging().error(f"{str(e)}")
            # If any exception will be occurred in payload, will be returned through exception.
            return {"response": False, "result": str(e)}


class Health(Resource):
    def get(self):
        """
        The get function is used to check the health of the service.
            It returns a response with status code 200 if it's healthy, otherwise 500.

        :param self: Represent the instance of the class
        :return: A dictionary with a key 'response' and the value of that key is the response from health_check()
        :doc-author: Kaoushik Kumar
        """
        try:
            response = HealthCheck().health_check()
            return {"response": response}
        except Exception as e:
            Logger().logging().error(f"{str(e)}")
            return "Found Error: {}".format(e)


#  Registering End-Points
apps.add_resource(DVTWrapper, "/api/v1/dvt-run-validation")
apps.add_resource(Health, "/health-check")
