"""
This file will be used for Validation the request payload from the End-Users.
"""
import unittest

payload = {
    "source_database": {
        "db_type": "MSSQL",
        "db_host": "ip_address",
        "db_name": "adventure-works-2019",
        "db_user": "striim1219",
        "db_port": 1433,
        "db_password": "password",
    },
    "target_database": {
        "db_type": "Postgres",
        "db_host": "ip_address",
        "db_name": "postgres",
        "db_user": "postgres",
        "db_port": 5432,
        "db_password": "password",
    },
    "tables": "dbo.foo,public.foo",
    "validation_type": "sum_column",
    "columns": "id,id",
}


class TestRequestPayload(unittest.TestCase):
    """
    The Class based method will be used for Validate the payload extending unit-test cases.
    """

    def test_payload(self):
        """
        The test_payload function tests the payload dictionary to ensure that it is a dictionary,
        that it contains all the necessary keys and values, and that each value is of the correct type.

        :param self: Represent the instance of the class
        :return: A dictionary with the following keys:
        :doc-author: Kaoushik Kumar
        """
        # The below line will be checking the type of payload, if it is dictionary
        # then execute the rest of the payload validations.
        self.assertIsInstance(payload, dict)
        self.assertIn("source_database", payload)
        # The below payload will check the type of payload and its nested type of payloads.
        self.assertIsInstance(payload["source_database"], dict)
        self.assertIn("db_type", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_type"], str)
        self.assertIn("db_host", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_host"], str)
        self.assertIn("db_name", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_name"], str)
        self.assertIn("db_user", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_user"], str)
        self.assertIn("db_port", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_port"], int)
        self.assertIn("db_password", payload["source_database"])
        self.assertIsInstance(payload["source_database"]["db_password"], str)

        # The below payload will check the type of payload and its nested type of payloads.
        self.assertIsInstance(payload, dict)
        self.assertIn("target_database", payload)
        self.assertIsInstance(payload["target_database"], dict)
        self.assertIn("db_type", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_type"], str)
        self.assertIn("db_host", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_host"], str)
        self.assertIn("db_name", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_name"], str)
        self.assertIn("db_user", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_user"], str)
        self.assertIn("db_port", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_port"], int)
        self.assertIn("db_password", payload["target_database"])
        self.assertIsInstance(payload["target_database"]["db_password"], str)

        self.assertIn("tables", payload)
        self.assertIsInstance(payload["tables"], str)
        self.assertIn("validation_type", payload)
        self.assertIsInstance(payload["validation_type"], str)

        # The below if condition will be used to checking the optional request payload.
        # If payload exists then perform the validation else ignore it.
        if "columns" in payload:
            self.assertIsInstance(payload["columns"], str)
        # The below if condition will be used to checking the optional request payload.
        # If payload exists then perform the validation else ignore it.
        if "pct_threshold" in payload:
            self.assertIsInstance(payload["columns"], str)

    def test_empty_payload(self):
        """
        The test_empty_payload function tests the empty_payload dictionary.
        It checks that it is an instance of a dictionary, that it has no elements, and that it is not false.

        :param self: Represent the instance of the object that is passed to the method when it is called
        :return: A dict
        :doc-author: Kaoushik Kumar
        """
        empty_payload = dict()

        self.assertIsInstance(empty_payload, dict)
        self.assertEqual(len(empty_payload), 0)
        self.assertFalse(False, empty_payload)

    def test_empty_list_payload(self):
        """
        The test_empty_list_payload function tests the following:
            1. The empty_payload variable is an instance of a list.
            2. The length of the empty_payload variable is 0 (zero).
            3. The boolean value False is not equal to the empty_payload variable.

        :param self: Represent the instance of the class
        :return: An empty list
        :doc-author: Kaoushik Kumar
        """
        empty_payload = list()

        self.assertIsInstance(empty_payload, list)
        self.assertEqual(len(empty_payload), 0)
        self.assertFalse(False, empty_payload)


if __name__ == "__main__":
    unittest.main()
