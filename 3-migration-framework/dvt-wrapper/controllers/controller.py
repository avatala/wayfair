"""
This is a Controller File will be used for DVT wrapper, which will request the DVT or any third-party URL calls.
"""
from typing import Any, Union

import constants as constant
import requests
from connect import cnf_dict
from exceptions.loggers import Logger
from schema_mappings.schema import ResponseModel
from utils.dvt_utils import dvt_json_request


class WrapperController(object):
    def __init__(self):
        """
        The __init__ function is called when the class is instantiated.
        It sets up the instance variables for this particular object.

        :param self: Represent the instance of the class
        :return: An instance of the class
        :doc-author: Kaoushik Kumar
        """
        self.platform_url = cnf_dict["dvt-config"]["platform_auth_url"]

    def wrapper(self, payload: dict) -> Union[Union[bool, list[Any]], Any]:
        """
        The wrapper function is used to make a request to the Data Validation Tool (DVT) API.
        The function takes in a payload dictionary and returns the results of the DVT API call.

        :param self: Represent the instance of the class
        :param payload: dict: Pass the payload to the wrapper function
        :return: A list of dictionaries
        :doc-author: Kaoushik Kumar
        """
        results, source_column, target_column = list(), None, None
        # The below line will be used to remove the extra spaces to validate the strings
        # and also split the string into two different characters if ';' presents.
        table_lists = payload["tables"].replace(" ", "").split(";")
        for table_list in table_lists:
            # The below line will be used to validate the table_list strings followed by comma(',')
            db_source_schema_name, db_target_schema_name = self._table_list(table_list)
            # As columns in an option field in the request payload.
            # if condition and logic will only be performed if columns is there in the request payload.
            if payload["columns"]:
                # The below line will be used to remove the extra spaces to validate the column's strings
                # and also split the string into two different characters if ';' presents.
                columns = payload["columns"].replace(" ", "").split(";")
                source_column, target_column = self._columns(payload, columns)
            # The below dvt_json_request function will be used to restructure the payload as per DVT-System.
            requested_payload = dvt_json_request(
                payload,
                db_source_schema_name,
                db_target_schema_name,
                source_column,
                target_column,
            )
            if not requested_payload:
                Logger().logging().error(
                    "{}, is Invalid validation_type".format(payload["validation_type"])
                )
                return {
                    "response": False,
                    "message": "{}, is Invalid validation_type".format(
                        payload["validation_type"]
                    ),
                }
            # The below code will be used to send the API call request to DVT-System, to get the response for request.
            response = self._dvt_post_request(requested_payload)
            if response.status_code == 200:
                # The below try-except have been added to handle the exception from the response.
                # Even for the status_code = 200, there are excepting under the code.
                try:
                    # Validating the DVT-Response using Pydantic Model(ResponseModel).
                    response_dict = ResponseModel(
                        validation_name=table_list.split(",")[1].split(".")[1]
                        + "."
                        + payload[constant.VALIDATION_TYPE],
                        validation_type=response.json()[0].get(
                            constant.VALIDATION_TYPE
                        ),
                        aggregation_type=response.json()[0].get(
                            constant.AGGREGATION_TYPE
                        ),
                        source_table_name=response.json()[0].get(
                            constant.SOURCE_TABLE_NAME
                        ),
                        source_agg_value=response.json()[0].get(
                            constant.SOURCE_AGG_VALUE
                        ),
                        target_table_name=response.json()[0].get(
                            constant.TARGET_TABLE_NAME
                        ),
                        target_agg_value=response.json()[0].get(
                            constant.TARGET_AGG_VALUE
                        ),
                        difference=response.json()[0].get(constant.DIFFERENCE),
                        pct_difference=response.json()[0].get(constant.PCT_DIFFERENCE),
                        pct_threshold=response.json()[0].get(constant.PCT_THRESHOLD),
                        validation_status=response.json()[0].get(
                            constant.VALIDATION_STATUS
                        ),
                    )
                    results.append(response_dict.dict())
                except Exception as e:
                    # All the exception from the response can be Logged under the logger's file for code optimization.
                    # Below logger will log the Exception occur in the response code.
                    Logger().logging().exception(str(e))
                    # Below logger will log the same error in a text(readable) format.
                    Logger().logging().error(response.text)
                    return {"response": False, "results": response.text}
        return {"response": True, "results": results}

    def _table_list(self, table_list) -> Any:
        """
        The _table_list function will be used to validate the table_list strings followed by comma(',')
            Args:
                table_list (str): The string of tables list.

        :param self: Represent the instance of the class
        :param table_list: Validate the table_list strings followed by comma(',')
        :return: A tuple with two list elements
        :doc-author: Kaoushik Kumar
        """
        # The function will be used to validate the table_list strings followed by comma(',')
        if "," not in table_list:
            Logger().logging().error("'{}' Invalid Payload".format(table_list))
            return {
                "response": False,
                "results": "{} is Invalid Payload".format(table_list),
            }
        db_source_schema_name = table_list.split(",")[0].split(".")
        db_target_schema_name = table_list.split(",")[1].split(".")
        return db_source_schema_name, db_target_schema_name

    def _columns(self, payload, columns) -> Any:
        """
        The _columns function will be used to validate the columns strings followed by comma(',')
            Args:
                payload (dict): The dictionary of the payload.
                columns (list): The list of column names.

        :param self: Represent the instance of the class
        :param payload: Pass the payload to the function
        :param columns: Validate the columns strings followed by comma(',')
        :return: The source column and target column
        :doc-author: Kaoushik Kumar
        """
        # The function will be used to validate the columns strings followed by comma(',')
        if "," not in payload["columns"]:
            Logger().logging().error(f"Invalid Payload, {payload['columns']}")
            return {
                "response": False,
                "results": "{} is Invalid Payload".format(payload["columns"]),
            }
        for column in columns:
            source_column = column.split(",")[0]
            target_column = column.split(",")[1]
            return source_column, target_column

    def _dvt_post_request(self, requested_payload):
        """
        The dvt_post_request function is used to make a POST request to the DVT API.
            The function takes in a requested_payload parameter, which is the JSON payload that will be sent with
            the POST request.
            The function returns a response object.

        :param self: Represent the instance of the class
        :param requested_payload: Pass the payload to the api
        :return: A response object
        :doc-author: Kaoushik Kumar
        """
        response = requests.post(
            url=str(self.platform_url),
            json=requested_payload,
        )
        return response


class HealthCheck(object):
    def __init__(self):
        """
        The __init__ function is called when the class is instantiated.
        It sets up the instance of the class, and defines what attributes it has.
        In this case, we are setting up a Success object that will have one attribute: message.

        :param self: Represent the instance of the class
        :return: The instance of the class
        :doc-author: Kaoushik Kumar
        """
        self.message = "Success"

    def health_check(self) -> str:
        """
        The health_check function is a simple function that returns the message 'I am healthy!'
            This can be used to test if the server is running and responding.

        :param self: Refer to the class instance
        :return: A string
        :doc-author: Kaoushik Kumar
        """
        return self.message
