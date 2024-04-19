"""
Here class is define to read the Config Data from config .ini file
"""

import configparser


class Config(object):
    """Project configuration"""

    def __init__(self):
        self.config = None  # set it to conf

    @staticmethod
    def read_configurations_from_ini(ini_file_path):
        cnf = configparser.ConfigParser()
        cnf.read(ini_file_path)
        cnf_dict = {}
        for section in cnf.sections():
            cnf_dict[section] = {}
            for k, v in cnf.items(section):
                cnf_dict[section][k] = v
        return cnf_dict
