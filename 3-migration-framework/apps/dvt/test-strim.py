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

import requests

PROJECT_ID = os.environ.get("PROJECT_ID")

# DESCRIBE_SERVICE = """
# gcloud run services describe {service_name} --region=us-east1 --project={project_id}
# """


def get_token():
    with os.popen("gcloud auth print-identity-token") as cmd:
        token = cmd.read().strip()

    return token


# def get_cloud_run_url(service_name, project_id):
#     describe_service = DESCRIBE_SERVICE.format(
#         service_name=service_name, project_id=project_id
#     )
#     with os.popen(describe_service) as service:
#         description = service.read()

#     return re.findall("URL:.*\n", description)[0].split()[1].strip()


data = {
    "source_conn": {
        "source_type": "MSSQL",
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "35.225.164.168",
        "port": 1433,
        "user": "sqlserver",
        "password": "4=dYjTJ*0C;*)FES",
        "database": "adventure-works-2019",
    },
    "target_conn": {
        "source_type": "Postgres",
        # "project_id": PROJECT_ID,
        # Connection Details
        "host": "127.0.0.1",
        "port": 5433,
        "user": "workload-sa@m2m-wayfair-dev.iam",
        # "password": "q13%Huu-/jG*=8ln",
        "password": "fooo",
        "database": "postgres",
    },
    "type": "Column",
    "schema_name": "Sales",
    "table_name": "SalesOrderHeader",
    "target_schema_name": "public",
    "target_table_name": "SalesOrderHeader",
    "result_handler": {
        "type": "Stackdriver",
        "project_id": PROJECT_ID,
        "environment": "dev",
    },
    "aggregates": [
        {
            "source_column": None,
            "target_column": None,
            "field_alias": "count",
            "type": "count",
        }
    ],
}

# url = get_cloud_run_url("data-validator", PROJECT_ID)
url = "http://35.229.82.79/"
res = requests.post(url, headers={"Authorization": "Bearer " + get_token()}, json=data)
print(res.content.decode())
