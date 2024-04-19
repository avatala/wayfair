"""
This file will be used for validating the request payload from the Wayfair or etc...
"""
from typing import List, Optional

from pydantic import BaseModel, Field


class DB(BaseModel):
    """
    This DB Model will be used under the SourceTargetPayload model of request_model file
    which could be sent by End-User to validate schema designed.
    """

    db_type: str
    db_host: str
    db_name: str
    db_user: str
    db_port: str
    db_password: str


class SourceTargetPayload(BaseModel):
    """
    The SourceTargetPayload Model will be used to accepting the request payload from the End-Users.
    """

    target_database: DB
    source_database: DB
    tables: str
    validation_type: str
    columns: Optional[str] = Field(default=None)
    pct_threshold: Optional[int] = 0

    class Config:
        orm_mode = True


class ResponseModel(BaseModel):
    """
    The ResponseModel Model will be used to return the response from the DVT-System
    after the validation of below Pydantic Model Fields.
    """

    validation_name: str
    validation_type: str
    aggregation_type: str
    source_table_name: str
    source_agg_value: str
    target_table_name: str
    target_agg_value: str
    difference: float
    pct_difference: float
    pct_threshold: int
    validation_status: str

    class Config:
        orm_mode = True


class ConnectionRequest(BaseModel):
    """
    The ConnectionRequest will be used to for the Source and Target Connection String for DVT-System as per DVT payload.
    """

    source_type: str
    host: str
    port: int
    user: str
    password: str
    database: str

    class Config:
        orm_mode = True


class Aggregates(BaseModel):
    """
    This Aggregates field is also a part of DVT Request Payload which need to be in the form of List of aggregates.
    """

    source_column: str = Field(default=None)
    target_column: str = Field(default=None)
    field_alias: str
    type: str

    class Config:
        orm_mode = True


class RequestHandler(BaseModel):
    """
    This RequestHandler field is also a part of DVT Request Payload.
    """

    type: str = "Stackdriver"
    project_id: str
    environment: str = "dev"

    class Config:
        orm_mode = True


class DVTRequestPayload(BaseModel):
    """
    This DVTRequestPayload is the main payload, which has consolidated all the above Pydantic Models of DVT System and
    Restructured is as per DVT Request Payload.
    """

    source_conn: ConnectionRequest
    target_conn: ConnectionRequest
    type: str = "Column"
    schema_name: str
    table_name: str
    target_schema_name: str
    target_table_name: str
    result_handler: RequestHandler
    aggregates: List[Aggregates]

    class Config:
        orm_mode = True
