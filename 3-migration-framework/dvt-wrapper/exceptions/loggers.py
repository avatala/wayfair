"""
This file will the Global File, which will be used for log the exceptions to the codes.
"""
import logging


class Logger(object):
    def __init__(self):
        """
        The __init__ function is called when the class is instantiated.
        It sets up the logging module with a name, error level and format.

        :param self: Represent the instance of the class
        :return: The name of the module
        :doc-author: Kaoushik Kumar
        """
        self.name = __name__
        self.error = logging.ERROR
        self.__format__ = "%(asctime)s - %(levelname)s - %(message)s"

    def logging(self):
        """
        The logging function is used for logging the errors in a file.
            The function will be called by the other functions to log their errors.
            The function takes three arguments: name, error and format.

            Args: name, error and format

        :param self: Represent the instance of the class
        :return: The logger
        :doc-author: Kaoushik Kumar
        """
        # __name__ have to be registered for the name of the exceptions.
        logger = logging.getLogger(self.name)
        # The below line will be for the type of ERROR needs to be leveled.
        logger.setLevel(self.error)
        # The below line will be used for assigning the format of the Logs(i.e: Date/Time)
        formate = logging.Formatter(self.__format__)
        # The below line will be saved the logs to the corresponding file name.
        file_name = logging.FileHandler("error.log")
        # The below file will be used for Registering the Formats of Logs.
        file_name.setFormatter(formate)
        # And the last line is for adding the file_name to be FileHandler.
        logger.addHandler(file_name)
        return logger
