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

""" A ResultHandler class is supplied to the DataValidation manager class.

The execute function of any result handler is used to process
the validation results.  It expects to receive the config
for the validation and Pandas DataFrame with the results
from the validation run.

Output validation report to gcp structured logging
"""
import json

from data_validation import consts


def filter_validation_status(status_list, result_df):
    return result_df[result_df.validation_status.isin(status_list)]


def init_logger(logger_name, project_id):
    from google.cloud import logging

    logging_client = logging.Client(project=project_id)
    logger = logging_client.logger(logger_name)
    return logger


class StackdriverResultHandler(object):
    def __init__(
        self,
        format,
        status_list=None,
        cols_filter_list=consts.COLUMN_FILTER_LIST,
        project_id=None,
        source_database=None,
        environment=None,
    ):
        self.format = format
        self.cols_filter_list = cols_filter_list
        self.status_list = status_list
        self.project_id = project_id
        self.source_database = source_database
        self.environment = environment
        self.logger = init_logger("dmp", project_id)

    def print_formatted_(self, result_df):
        """
        Utility for printing formatted results
        :param result_df
        """
        if self.status_list is not None:
            result_df = filter_validation_status(self.status_list, result_df)

        results_json = json.loads(result_df.to_json())
        output = {}

        output["environment"] = self.environment
        output["source_database"] = self.source_database
        output["validation_name"] = results_json.get("validation_name").get("0")
        output["validation_type"] = results_json.get("validation_type").get("0")
        output["aggregation_type"] = results_json.get("aggregation_type").get("0")
        output["group_by_columns"] = results_json.get("group_by_columns").get("0")
        output["primary_keys"] = results_json.get("primary_keys").get("0")
        output["difference"] = results_json.get("difference").get("0")
        output["pct_difference"] = results_json.get("pct_difference").get("0")
        output["validation_status"] = results_json.get("validation_status").get("0")
        output["run_id"] = results_json.get("run_id").get("0")

        output["source_table_name"] = results_json.get("source_table_name").get("0")
        output["source_column_name"] = results_json.get("source_column_name").get("0")
        output["source_agg_value"] = results_json.get("source_agg_value").get("0")

        output["target_table_name"] = results_json.get("target_table_name").get("0")
        output["target_column_name"] = results_json.get("target_column_name").get("0")
        output["target_agg_value"] = results_json.get("target_agg_value").get("0")

        # print (output)
        self.logger.log_struct(output)

        # if self.format == "text":
        #     print(result_df.to_string(index=False))
        # elif self.format == "csv":
        #     print(result_df.to_csv(index=False))
        # elif self.format == "json":
        #     self.logger.log_struct(result_df.to_json(orient="index"))
        # else:
        #     print(
        #         result_df.drop(self.cols_filter_list, axis=1).to_markdown(
        #             tablefmt="fancy_grid", index=False
        #         )
        #     )

        if self.format not in consts.FORMAT_TYPES:
            error_msg = (
                f"format [{self.format}] not supported, results printed in default(table) mode. "
                f"Supported formats are [text, csv, json, table]"
            )
            raise ValueError(error_msg)

        return result_df

    def execute(self, result_df):
        return self.print_formatted_(result_df)
