"""
This file will be used for testing the Pytest Validation Test Cases.
"""
import controllers.controller
import pytest
from utils import dvt_utils as utils_functions


@pytest.fixture
def requested_source_model():
    """
    The requested_source_model function returns a dictionary that contains the information
    needed to connect to a source database.
    The function is used in the following request_payload:

    :return: A dictionary that contains the source database information
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "source_database": {
            "db_type": "source_type",
            "db_host": "host",
            "db_port": 1234,
            "db_user": "user",
            "db_password": "password",
            "db_name": "database",
        }
    }
    return payload


@pytest.fixture
def response_source_model():
    """
    The response_source_model function returns a dictionary containing the following keys:
        source_type, host, port, user, password and database.

    :return: The following request_payload
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "source_type": "source_type",
        "host": "host",
        "port": 1234,
        "user": "user",
        "password": "password",
        "database": "database",
    }
    return payload


def test_source_connection_model(
    requested_source_model: dict, response_source_model: dict
):
    """
    The test_source_connection_model function tests the source_connection_model function in utils.py
        by comparing the response from that function to a known correct response.

    :param requested_source_model: dict: Pass the source model
    :param response_source_model: dict: Compare the response from the function to a known good response
    :return: A dictionary with the following structure:
    :doc-author: Kaoushik Kumar
    """
    response = utils_functions.source_connection_model(requested_source_model)
    assert response == response_source_model


@pytest.fixture
def requested_target_model():
    """
    The requested_target_model function returns a dictionary that contains the information
    needed to create a target database.
    The function is used in the test_create_target_database function.

    :return: A dictionary with the following keys:
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "target_database": {
            "db_type": "source_type",
            "db_host": "host",
            "db_port": 1234,
            "db_user": "user",
            "db_password": "password",
            "db_name": "database",
        }
    }
    return payload


@pytest.fixture
def response_target_model():
    """
    The response_target_model function returns a dictionary containing the following keys:
        source_type, host, port, user, password and database.

        The values of these keys are as follows:

    :return: The following payload:
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "source_type": "source_type",
        "host": "host",
        "port": 1234,
        "user": "user",
        "password": "password",
        "database": "database",
    }
    return payload


def test_target_connection_model(
    requested_target_model: dict, response_target_model: dict
):
    """
    The test_target_connection_model function tests the target_connection_model function in utils.py
        by comparing the output of that function to a known correct output.

    :param requested_target_model: dict: Pass the requested target model
    :param response_target_model: dict: Store the expected response from the target_connection_model function
    :return: A dictionary of the target connection model
    :doc-author: Kaoushik Kumar
    """
    response = utils_functions.target_connection_model(requested_target_model)
    assert response == response_target_model


@pytest.fixture
def request_handler_model():
    """
    The request_handler_model function is used to create a request payload for the Stackdriver API.
        The function takes no arguments and returns a dictionary with the following keys:
            type - A string representing the type of monitoring service being used. In this case, it's 'Stackdriver'.
            project_id - A string representing your Google Cloud Platform project ID.
            This can be found in your GCP console under &quot;Project Info&quot;.
            environment - A string representing which environment you're deploying to (e.g., dev, staging, prod).

    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    payload = {"type": "Stackdriver", "project_id": "project_id", "environment": "dev"}
    return payload


def test_request_handler_model(request_handler_model: dict):
    """
    The test_request_handler_model function tests the request_handler_model function in utils.py
        by passing a dictionary of project id and model name to the function, which returns a dictionary
        with those same values. The test passes if both dictionaries are equal.

    :param request_handler_model: dict: Pass the data from the test
    :return: The request_handler_model dictionary
    :doc-author: Kaoushik Kumar
    """
    response = utils_functions.request_handler_model(
        request_handler_model["project_id"]
    )
    assert response == request_handler_model


@pytest.fixture
def sum_column_validation_type():
    """
    The sum_column_validation_type function returns a dictionary with the validation_type key set to 'sum_column'.

    :return: A dictionary with the validation type set to sum_column
    :doc-author: Kaoushik Kumar
    """
    payload = {"validation_type": "sum_column"}
    return payload


@pytest.fixture
def rowcount_validation_type():
    """
    The rowcount_validation_type function returns a dictionary with the key 'validation_type' and value 'rowcount'.
    This is used to specify that the validation type for this job will be rowcount.

    :return: A dictionary with the validation type set to rowcount
    :doc-author: Kaoushik Kumar
    """
    payload = {"validation_type": "rowcount"}
    return payload


@pytest.fixture
def source_columns():
    """
    The source_columns function returns the name of the column in which
    the source data is stored. This function is used by other functions to
    determine where to look for source data.

    :return: The source_column variable
    :doc-author: Kaoushik Kumar
    """
    source_column = "source_column"
    return source_column


@pytest.fixture
def target_columns():
    """
    The target_columns function returns the name of the target column.

    :return: A string of the column name that is the target variable
    :doc-author: Kaoushik Kumar
    """
    target_column = "target_column"
    return target_column


@pytest.fixture
def sum_count_response_aggregates_model():
    """
    The sum_count_response_aggregates_model function returns a dictionary that contains the following:
        source_column: The column to be aggregated.
        target_column: The name of the new column created by this aggregation.
        field_alias: A descriptive name for this aggregation, which will appear in the UI
        and can be used as a reference when creating rules or filters.
        This is also used as an alias for any columns referenced
        in other parts of your query (e.g., if you are filtering on this value).
        If no value is provided, it will default to 'aggregation'.
        type: The type of aggregation being performed.&quot;

    :return: The following:
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "source_column": "source_column",
        "target_column": "target_column",
        "field_alias": "my_sum",
        "type": "sum",
    }
    return payload


@pytest.fixture
def response_row_count_aggregates_model():
    """
    The response_row_count_aggregates_model function returns a dictionary that contains the following keys:
        source_column, target_column, field_alias and type.

    :return: An object of type aggregates
    :doc-author: Kaoushik Kumar
    """
    payload = {
        "source_column": "source_column",
        "target_column": "target_column",
        "field_alias": "count",
        "type": "count",
    }
    return payload


def test_sum_column_aggregates_model(
    source_columns,
    target_columns,
    sum_column_validation_type,
    sum_count_response_aggregates_model,
):
    """
    The test_sum_column_aggregates_model function tests the aggregates_model function in utils_functions.py
        to ensure that it returns a dictionary of the correct format when given a sum column validation type,
        source columns, and target columns.

    :param source_columns: Pass the source columns to be used in the test
    :param target_columns: Pass the target columns to be validated
    :param sum_column_validation_type: Determine the type of validation to be performed
    :param sum_count_response_aggregates_model: Compare the response data with the expected result
    :return: A dictionary with the following keys:
    :doc-author: Kaoushik Kumar
    """
    response = utils_functions.aggregates_model(
        sum_column_validation_type, source_columns, target_columns
    )
    assert response == sum_count_response_aggregates_model


def test_row_column_aggregates_model(
    source_columns,
    target_columns,
    rowcount_validation_type,
    response_row_count_aggregates_model,
):
    """
    The test_row_column_aggregates_model function tests the aggregates_model function in utils_functions.py
        by comparing the response data from calling that function to a known value.

    :param source_columns: Pass the source columns to be used in the test
    :param target_columns: Pass the target column names to the function
    :param rowcount_validation_type: Determine the type of validation to be performed
    :param response_row_count_aggregates_model: Store the expected response from the aggregates_model function
    :return: A response_data
    :doc-author: Kaoushik Kumar
    """
    response = utils_functions.aggregates_model(
        rowcount_validation_type, source_columns, target_columns
    )
    assert response == response_row_count_aggregates_model


@pytest.fixture
def pct_threshold():
    """
    The pct_threshold function returns a dictionary that can be used as the request payload for a ReST API call to
        set the pct_threshold value. The threshold is an integer between 0 and 100, inclusive.

    :return: A dictionary with the key 'pct_threshold'
    :doc-author: Kaoushik Kumar
    """
    payload = {"pct_threshold": {"threshold": 0}}
    return payload


@pytest.fixture
def db_source_schema():
    """
    The db_source_schema function returns a list of the source database schema names.

    :return: A list of schema names
    :doc-author: Kaoushik Kumar
    """
    db_source_schema_name = ["dbo", "foo"]
    return db_source_schema_name


@pytest.fixture
def db_target_schema():
    """
    The db_target_schema function returns a list of the target database schema names.

    :return: The target schema name
    :doc-author: Kaoushik Kumar
    """
    db_target_schema_name = ["public", "foo"]
    return db_target_schema_name


@pytest.fixture
def dvt_request_payload():
    """
    The dvt_request_payload function returns a dictionary that can be used as the payload for a POST request to the
    dvt endpoint. The function is intended to be used in conjunction with the dvt_request_payload function, which
    returns an object that can be used as a response from dvt.

    :return: A dictionary of the payload
    :doc-author: Trelent
    """
    payload = {
        "aggregates": [
            {
                "field_alias": "my_sum",
                "source_column": "source_column",
                "target_column": "target_column",
                "type": "sum",
            }
        ],
        "result_handler": {
            "environment": "dev",
            "project_id": "project_id",
            "type": "Stackdriver",
        },
        "schema_name": "dbo",
        "source_conn": {
            "database": "database",
            "host": "host",
            "password": "password",
            "port": 1234,
            "source_type": "source_type",
            "user": "user",
        },
        "table_name": "foo",
        "target_conn": {
            "database": "database",
            "host": "host",
            "password": "password",
            "port": 1234,
            "source_type": "source_type",
            "user": "user",
        },
        "target_schema_name": "public",
        "target_table_name": "foo",
        "type": "Column",
    }
    return payload


def test_dvt_request_payload(
    response_source_model: dict,
    response_target_model: dict,
    db_source_schema: list,
    db_target_schema: list,
    request_handler_model: dict,
    sum_count_response_aggregates_model: dict,
    pct_threshold: dict,
    dvt_request_payload: dict,
):
    """
    The test_dvt_request_payload function tests the dvt_request_payload function in utils.py
        Args:
            response_source_model (dict): The source model's response data from a request to the API.
            response_target_model (dict): The target model's response data from a request to the API.
            db_source_schema (list): A list of dictionaries containing information about each column in the
            source database table, including its name and type.
            This is used for comparing against what is returned by an API call to ensure that all columns are present
            and accounted for in both databases.

    :param response_source_model: dict: Pass the source response model
    :param response_target_model: dict: Pass the target model to the function
    :param db_source_schema: list: Pass the list of columns in the source database
    :param db_target_schema: list: Pass the target schema to the function
    :param request_handler_model: dict: Pass the request handler model to the function
    :param sum_count_response_aggregates_model: dict: Pass in the sum_count_response_aggregates function
    :param pct_threshold: dict: Pass the pct_threshold dictionary
    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    response_data = utils_functions.dvt_request_payload(
        response_source_model,
        response_target_model,
        db_source_schema,
        db_target_schema,
        request_handler_model,
        sum_count_response_aggregates_model,
        pct_threshold,
    )
    assert response_data == dvt_request_payload


@pytest.fixture
def request_table_names():
    """
    The db_target_schema function returns a list of the target database schema names.

    :return: The target schema name
    :doc-author: Kaoushik Kumar
    """
    table_data = "Sales.SalesOrderHeader,public.SalesOrderHeader"
    return table_data


@pytest.fixture
def response_table_names():
    """
    The db_target_schema function returns a list of the target database schema names.

    :return: The target schema name
    :doc-author: Kaoushik Kumar
    """
    table_data_one, table_data_two = (
        ["Sales", "SalesOrderHeader"],
        ["public", "SalesOrderHeader"],
    )
    return table_data_one, table_data_two


def test_table_list(request_table_names, response_table_names):
    """
    The test_table_list function tests the _table_list function in the controller.py file.
    The test_table_list function takes two arguments: request_table_names and response table names.
    The request table names argument is a list of strings that represent the tables to be listed,
    and response table names is a list of strings that represents what should be returned from
    the _table list function.

    :param request_table_names: Pass in the table names that will be used to create a list of tables
    :param response_table_names: Compare the response data from the controller to this parameter
    :return: The list of tables
    :doc-author: Kaoushik Kumar
    """
    controller_obj = controllers.controller.WrapperController()
    response_data = controller_obj._table_list(request_table_names)
    assert response_data == response_table_names


@pytest.fixture
def request_column_names():
    """
    The request_column_names function is used to request the column names of a table.
        The function takes no arguments and returns a list of strings containing the column names.

    :return: A list of column names
    :doc-author: Kaoushik Kumar
    """
    table_data = ["id,id"]
    return table_data


@pytest.fixture
def response_column_names():
    """
    The response_column_names function returns the column names of the response dataframe.
        The function takes no arguments and returns two strings, which are the column names.

    :return: A tuple of column names
    :doc-author: Kaoushik Kumar
    """
    column_data_one, column_data_two = ("id", "id")
    return column_data_one, column_data_two


@pytest.fixture
def column_request_payload():
    """
    The column_request_payload function returns a dictionary with the key 'columns' and value 'id,id'.
    This is used to request only the id column from the API.

    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    payload = dict()
    payload["columns"] = "id,id"
    return payload


def test_column_list(
    column_request_payload, request_column_names, response_column_names
):
    """
    The test_column_list function tests the _columns function in the controller.py file.
    The test_column_list function takes three arguments: column_request_payload, request_columns, and response columns.

    :param column_request_payload: Pass the request payload to the controller
    :param request_column_names: Pass the column names that are requested by the user
    :param response_column_names: Compare the response data with the expected output
    :return: The column names in the response
    :doc-author: Kaoushik Kumar
    """
    controller_obj = controllers.controller.WrapperController()
    response_data = controller_obj._columns(
        column_request_payload, request_column_names
    )
    assert response_data == response_column_names


def test_dvt_post_request(column_request_payload):
    """
    The test_dvt_post_request function tests the _dvt_post_request function in the controller.py file.
    The test passes if a 200 status code is returned from the response data.

    :param column_request_payload: Pass the payload to the function
    :return: A response object
    :doc-author: Kaoushik Kumar
    """
    controller_obj = controllers.controller.WrapperController()
    response_data = controller_obj._dvt_post_request(column_request_payload)
    assert response_data.status_code == 200


@pytest.fixture
def wrappers() -> dict:
    """
    The wrappers function is a helper function that returns a fake payload.
        This is used for testing purposes only.

    :return: A dictionary
    :doc-author: Kaoushik Kumar
    """
    fake_payload = {
        "source_database": {
            "db_type": "ABC",
            "db_host": "ABC",
            "db_name": "ABC",
            "db_user": "ABC",
            "db_port": 1433,
            "db_password": "ABC",
        },
        "target_database": {
            "db_type": "ABC",
            "db_host": "ABC",
            "db_name": "ABC",
            "db_user": "ABC",
            "db_port": 5432,
            "db_password": "ABC",
        },
        "tables": "dbo.foo,public.foo",
        "validation_type": "abc",
        "pct_threshold": 0,
        "columns": "id,id",
    }
    return fake_payload


def test_wrapper(wrappers) -> False:
    """
    The test_wrapper function tests the wrapper function in the controller.py file.
        The test_wrapper function takes a dictionary of wrappers as an argument and passes it to
        the wrapper function in controller.py, which returns a response_data object that is then tested for False.

    :param wrappers: Pass in the wrapper object that is created in the test_wrapper function
    :return: A response_data object that contains a key called 'response' and the value is false
    :doc-author: Kaoushik Kumar
    """
    controller_obj = controllers.controller.WrapperController()
    response_data = controller_obj.wrapper(wrappers)
    assert response_data.get("response") is False
