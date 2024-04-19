rowcount = {
    "source_conn": {
        "source_type": "",  # constant
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "",
        "port": "",  # constant
        "user": "",
        "password": "",
        "database": "",
    },
    "target_conn": {
        "source_type": "",
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "",
        "port": "",
        "user": "",
        "password": "",
        "database": "",
    },
    "type": "Column",
    "schema_name": "",
    "table_name": "",
    "target_schema_name": "",
    "target_table_name": "",
    "result_handler": {"type": "Stackdriver", "project_id": "", "environment": "dev"},
    "aggregates": [
        {
            "source_column": None,
            "target_column": None,
            "field_alias": "count",
            "type": "count",
        }
    ],
}

sum_column = {
    "source_conn": {
        "source_type": "",
        "host": "",
        "port": "",
        "user": "",
        "password": "",
        "database": "",
    },
    "target_conn": {
        "source_type": "",
        "host": "",
        "port": "",
        "user": "",
        "password": "",
        "database": "",
    },
    "type": "Column",
    "schema_name": "",
    "table_name": "",
    "target_schema_name": "",
    "target_table_name": "",
    "result_handler": {"type": "Stackdriver", "project_id": "", "environment": "dev"},
    "aggregates": [
        {
            "source_column": "",
            "target_column": "",
            "field_alias": "my_sum",
            "type": "sum",
        }
    ],
}
