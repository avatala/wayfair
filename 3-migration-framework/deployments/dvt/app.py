import json
import logging
import os

import flask
import pandas
from data_validation import data_validation

app = flask.Flask(__name__)


def _clean_dataframe(df):
    rows = df.to_dict(orient="record")
    for row in rows:
        for key in row:
            if type(row[key]) in [pandas.Timestamp]:
                row[key] = str(row[key])

    return json.dumps(rows)


def _get_request_content(request):
    return request.json


def validate(config):
    """Run Data Validation against the supplied config."""
    validator = data_validation.DataValidation(config)
    df = validator.execute()

    return _clean_dataframe(df)


def main(request):
    """Handle incoming Data Validation requests.

    request (flask.Request): HTTP request object.
    """
    try:
        config = _get_request_content(request)["config"]
        return validate(config)
    except Exception as e:
        return "Unknown Error: {}".format(e)


@app.route("/", methods=["POST"])
def run():
    try:
        config = _get_request_content(flask.request)
        result = validate(config)
        return str(result)
    except Exception as e:
        logging.exception(e)
        return "Found Error: {}".format(e)


@app.route("/test", methods=["POST"])
def other():
    return _get_request_content(flask.request)


@app.route("health", methods=["GET"])
def health():
    return "success"


if __name__ == "__main__":
    app.run()
