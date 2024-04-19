import os
import re

import pyodbc
from sqlalchemy import create_engine


def select_mssql_driver():
    """Find least version of: ODBC Driver for SQL Server."""
    drv = sorted(
        [
            drv
            for drv in pyodbc.drivers()
            if "ODBC Driver " in drv and " for SQL Server" in drv
        ]
    )
    if len(drv) == 0:
        raise Exception("No 'ODBC Driver XX for SQL Server' found.")
    return drv[-1]


MSSQLSERVER_HOST = os.environ.get("MSSQLSERVER_HOST")
MSSQLSERVER_PORT = 1433
MSSQLSERVER_DB = os.environ.get("MSSQLSERVER_DB")
MSSQLSERVER_USER = os.environ.get("MSSQLSERVER_USER")
MSSQLSERVER_PASS = os.environ.get("MSSQLSERVER_PASS")

mssql_driver = select_mssql_driver()
mssqlserver_uri = f"mssql+pyodbc://{MSSQLSERVER_USER}:{MSSQLSERVER_PASS}@{MSSQLSERVER_HOST}:{MSSQLSERVER_PORT}/{MSSQLSERVER_DB}?driver={mssql_driver}"
mssqlserver_engine = create_engine(mssqlserver_uri)

mssqlserver_table_query = """

    SELECT
          t.name AS table_name
        , s.name AS schema_name
    FROM sys.tables t
    INNER JOIN sys.schemas s
    ON t.schema_id = s.schema_id

    UNION

    SELECT
          v.name AS table_name
        , s.name AS schema_name
    FROM sys.views v
    INNER JOIN sys.schemas s
    ON v.schema_id = s.schema_id

    ORDER BY schema_name, table_name;

"""

mssqlserver_connection = mssqlserver_engine.connect()

mssqlserver_tables = mssqlserver_connection.execute(mssqlserver_table_query)
mssqlserver_tables = mssqlserver_tables.fetchall()
mssqlserver_tables = dict(mssqlserver_tables)

mssqlserver_schemas = set(mssqlserver_tables.values())

mssqlserver_connection.close()

for table_name, schema_name in mssqlserver_tables.items():
    print("{}.{}".format(schema_name, table_name))
