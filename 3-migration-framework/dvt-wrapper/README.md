# Data Validation Tool (DVT) Wrapper API

The purpose of the DVT Wrapper is to enable database migration users to submit a single payload, which in turn generates data validation checks by interacting with the DVT system. For each table pair to compare and each data validation type to execute, a separate request is generated.

The API allows you to submit a payload containing information about the source and target databases, as well as the tables and columns to be validated. A consolidated data validation result report is then returned.

The Pydantic models are responsible for verifying the payload. If both the request payload and the Pydantic models pass validation, the process will proceed, and the DVT system will be called N number of times based on the user input. If there is a discrepancy in the validation, an exception will be returned to the user.

## Endpoints

### /dvt-run-validation

* Method: POST
* Description: This endpoint is responsible for validating the user input, generating DVT payload and initiating requests to the DVT API.
It accepts a JSON payload in the request body containing the source and target database configurations, tables, validation type, and optional columns.

## Models

* DB: A Pydantic model representing a generic database configuration. It includes fields like db_type, db_host, db_name, db_user, db_port, and db_password.
* TargetDataBase: A model that inherits from DB and represents the target database configuration.
* SourceDataBase: A model that inherits from DB and represents the source database configuration.
* SourceTargetPayload: A Pydantic model representing the payload to be sent to the DVT API.

## Example Payload

The provided payload initiates two data validation jobs, each of the row_count type. One validation request will be executed for each table pair to compare.

```json
{
    "target_database": {
        "db_type": "postgresql",
        "db_host": "target-db-host",
        "db_name": "target-db-name",
        "db_user": "target-db-user",
        "db_port": "5432",
        "db_password": "target-db-password"
    },
    "source_database": {
        "db_type": "mssql",
        "db_host": "source-db-host",
        "db_name": "source-db-name",
        "db_user": "source-db-user",
        "db_port": "1433",
        "db_password": "source-db-password"
    },
    "tables": "dbo.foo,public.foo;dbo.mytable,public.mytable",
    "validation_type": "row_count"
}
```

## Example Response

The response contains the validation results for all validation types and table pairs

```json
{
  "response": true,
  "results": [
    {
      "validation_name": "count",
      "validation_type": "Column",
      "aggregation_type": "count",
      "source_table_name": "Sales.SalesOrderHeader",
      "source_column_name": null,
      "source_agg_value": "4463527",
      "target_table_name": "public.SalesOrderHeader",
      "target_column_name": null,
      "target_agg_value": "853834",
      "group_by_columns": null,
      "primary_keys": null,
      "num_random_rows": null,
      "difference": -3609693.0,
      "pct_difference": -80.87086736565053,
      "pct_threshold": 0.0,
      "validation_status": "fail",
      "run_id": "baf0dc54-1106-4804-8754-69a1c1a70d01",
      "labels": [],
      "start_time": "2023-04-20 18:00:21.322403+00:00",
      "end_time": "2023-04-20 18:00:23.542082+00:00"
    },
    {
      "validation_name": "count",
      "validation_type": "Column",
      "aggregation_type": "count",
      "source_table_name": "dbo.foo",
      "source_column_name": null,
      "source_agg_value": "1",
      "target_table_name": "public.foo",
      "target_column_name": null,
      "target_agg_value": "1",
      "group_by_columns": null,
      "primary_keys": null,
      "num_random_rows": null,
      "difference": 0.0,
      "pct_difference": 0.0,
      "pct_threshold": 0.0,
      "validation_status": "success",
      "run_id": "9490cc59-1cf8-4263-894f-42cf1fcb0f64",
      "labels": [],
      "start_time": "2023-04-20 18:00:24.402474+00:00",
      "end_time": "2023-04-20 18:00:25.039327+00:00"
    }
  ]
}
```

## Application Flow

![where is the diagram?](dvt-wrapper.png "DVT Wrapper Application Flow")
