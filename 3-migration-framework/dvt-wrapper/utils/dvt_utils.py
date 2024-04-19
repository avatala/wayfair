"""
This file will be used for formatting the DVT-Payload, required by DVT as a request payloads.
"""
import os
from typing import Any, Union

import constants as constant
from connect import cnf_dict
from schema_mappings import schema as pydantic_model

# Added PROJECT_ID under the OS. PROJECT_ID need to be exported using below cmd for your local development
# export PROJECT_ID=<name_of_the_project_id>
PROJECT_ID = os.environ.get("PROJECT_ID")


def dvt_json_request(
    payload: dict,
    db_source_schema_name: list,
    db_target_schema_name: list,
    source_column: str,
    target_column: str,
) -> Union[Union[bool, list[Any]], Any]:
    """
    The dvt_json_request function will take the payload, source and target schema name,
    source column and target column as input. It will validate the payload based on validation_type.
    If validation_type is rowcount or sum_column then it will form a DVT Request Payload for DVT System.

    :param payload: dict: Pass the request payload from the api
    :param db_source_schema_name: list: Pass the list of source db schema names
    :param db_target_schema_name: list: Pass the list of target db schema names
    :param source_column: str: Pass the column name for which sum is to be calculated
    :param target_column: str: Pass the column name of the target table
    :return: The payload in the below format
    :doc-author: Kaoushik Kumar
    """
    # Below if condition will check the validation_type of the request payload.
    # Based on the validation_type DVT Json Request Payload will be formed, else it will return False.
    if (
        payload["validation_type"] == "rowcount"
        or payload["validation_type"] == "sum_column"
    ):
        # The below ConnectionRequest Pydantic Model will validate the payload for Source DB
        # and then form the request payload for DVT System.
        source_connection = source_connection_model(payload)
        # The below ConnectionRequest Pydantic Model will validate the payload for Target DB
        # and then form the request payload for DVT System.
        target_connection = target_connection_model(payload)
        # The below RequestHandler Pydantic Model will validate the payload
        # and then form the request payload for DVT System.
        request_handler = request_handler_model(PROJECT_ID)
        # The below Aggregates Pydantic Model will validate the payload
        # and then form the request payload for DVT System.
        aggregates = aggregates_model(payload, source_column, target_column)
        # The below DVTRequestPayload Pydantic Model is the main payload,
        # which will validate and restructure all the above Pydantic Model payload,
        # and then form the request payload as per DVT System requested.
        data_dict = dvt_request_payload(
            source_connection,
            target_connection,
            db_source_schema_name,
            db_target_schema_name,
            request_handler,
            aggregates,
            payload,
        )
        return data_dict
    else:
        return False


def source_connection_model(payload: dict) -> dict:
    """
    The source_connection_model function takes a dictionary as an argument and returns a dictionary.
    The function uses the pydantic_model.ConnectionRequest class to create a connection request object,
    which is then converted into a dictionary using the .dict() method.

    :param payload: dict: Get the data from the payload
    :return: A dict with the following keys:
    :doc-author: Kaoushik Kumar
    """
    source_connection = pydantic_model.ConnectionRequest(
        source_type=payload[constant.SOURCE_DATABASE][constant.DB_TYPE],
        host=payload[constant.SOURCE_DATABASE][constant.DB_HOST],
        port=int(payload[constant.SOURCE_DATABASE][constant.DB_PORT]),
        user=payload[constant.SOURCE_DATABASE][constant.DB_USER],
        password=payload[constant.SOURCE_DATABASE][constant.DB_PASSWORD],
        database=payload[constant.SOURCE_DATABASE][constant.DB_NAME],
    ).dict()
    return source_connection


def target_connection_model(payload: dict) -> dict:
    """
    The target_connection_model function takes a dictionary as an argument and returns a dictionary.
    The function is used to create the target database connection model for use in the pydantic_model module.

    :param payload: dict: Pass the payload from the api request
    :return: The target connection details in the form of a dictionary
    :doc-author: Kaoushik Kumar
    """
    target_connection = pydantic_model.ConnectionRequest(
        source_type=payload[constant.TARGET_DATABASE][constant.DB_TYPE],
        host=payload[constant.TARGET_DATABASE][constant.DB_HOST],
        port=int(payload[constant.TARGET_DATABASE][constant.DB_PORT]),
        user=payload[constant.TARGET_DATABASE][constant.DB_USER],
        password=payload[constant.TARGET_DATABASE][constant.DB_PASSWORD],
        database=payload[constant.TARGET_DATABASE][constant.DB_NAME],
    ).dict()
    return target_connection


def request_handler_model(project_id) -> dict:
    """
    The request_handler_model function takes in a project_id and returns a dictionary of the request handler model.
        Args:
            project_id (str): The id of the project to be used for this request handler.

    :param project_id: Identify the project that is being requested
    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    request_handler = pydantic_model.RequestHandler(project_id=project_id).dict()
    return request_handler


def aggregates_model(payload: dict, source_column: str, target_column: str) -> dict:
    """
    The aggregates_model function takes in a payload dictionary, source_column string, and target_column string.
    It returns a dictionary with the following keys:
        - field_alias (string)
        - type (string)

    :param payload: dict: Pass the payload from the request
    :param source_column: str: Specify the column name of the source dataframe
    :param target_column: str: Specify the column name of the target column
    :return: A dictionary with the following structure:
    :doc-author: Kaoushik Kumar
    """
    aggregates = pydantic_model.Aggregates(
        source_column=source_column,
        target_column=target_column,
        field_alias=cnf_dict["aggregates"][payload["validation_type"] + "_field_alias"],
        type=cnf_dict["aggregates"][payload["validation_type"] + "_type"],
    ).dict()
    return aggregates


def dvt_request_payload(
    source_connection: dict,
    target_connection: dict,
    db_source_schema_name: list,
    db_target_schema_name: list,
    request_handler: dict,
    aggregates: dict,
    payload: dict,
) -> dict:
    """
    The dvt_request_payload function takes in the following parameters:
        source_connection (dict): The connection information for the source database.
        target_connection (dict): The connection information for the target database.
        db_source_schema_name (list): A list containing two elements, where element 0 is
            a string representing the name of a schema and element 1 is a string representing
            the name of a table within that schema. This list represents an object in your
            source database that you want to compare against an object with identical structure
            in your target database. For example, if you

    :param source_connection: dict: Define the source connection
    :param target_connection: dict: Connect to the target database
    :param db_source_schema_name: dict: Get the schema name and table name from the source database
    :param db_target_schema_name: dict: Create the target table name
    :param request_handler: dict: Specify the type of response to be returned
    :param aggregates: dict: Define the columns to be used for aggregation
    :param payload: dict: Pass the threshold value to the dvt_request_payload function
    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    data_dict = pydantic_model.DVTRequestPayload(
        source_conn=source_connection,
        target_conn=target_connection,
        schema_name=db_source_schema_name[0],
        table_name=db_source_schema_name[-1],
        target_schema_name=db_target_schema_name[0],
        target_table_name=db_target_schema_name[-1],
        result_handler=request_handler,
        aggregates=[aggregates],
        threshold=payload[constant.PCT_THRESHOLD],
    ).dict()
    return data_dict
