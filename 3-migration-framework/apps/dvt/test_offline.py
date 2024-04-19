# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
import re

import main
import requests

PROJECT_ID = os.environ.get("PROJECT_ID")
SOURCE_PWD = os.environ.get("SOURCE_PWD")
DEST_PWD = os.environ.get("DEST_PWD")

config = {
    "source_conn": {
        "source_type": "MSSQL",
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "35.225.164.168",
        "port": 1433,
        "user": "sqlserver",
        "password": SOURCE_PWD,
        "database": "adventure-works-2019",
    },
    "target_conn": {
        "source_type": "Postgres",
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "34.23.80.176",
        "port": 5432,
        "user": "postgres",
        "password": DEST_PWD,
        "database": "postgres",
    },
    "type": "Column",
    "schema_name": "Sales",
    "table_name": "SalesOrderHeader",
    "target_schema_name": "public",
    "target_table_name": "SalesOrderHeader",
    "result_handler": {"type": "Stackdriver", "project_id": PROJECT_ID},
    "aggregates": [
        {
            "source_column": None,
            "target_column": None,
            "field_alias": "count",
            "type": "count",
        }
    ],
}

if __name__ == "__main__":
    result = main.validate(config)
