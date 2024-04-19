import os
import re

from connect import cnf_dict

# The below PROJECT_ID is being exported using CLI.
PROJECT_ID = os.environ.get("PROJECT_ID")


class GcpTokens(object):
    def __init__(self):
        """
        The __init__ function is called when the class is instantiated.
        It sets up the instance variables for this particular object.

        :param self: Represent the instance of the class
        :return: A new instance of the class
        :doc-author: Kaoushik Kumar
        """
        self.describe_service = cnf_dict["gcp-utils"]["describe_service"]
        self.gcloud_auth_print_identity_token = cnf_dict["gcp-utils"]["google_print"]

    def get_token(self):
        """
        The get_token function is used to get the token from the gcloud command line tool.
        The function uses os.popen to open a pipe and execute the gcloud_auth_print_identity_token string as a command,
        which returns an identity token for use in authenticating with Google Cloud Storage.

        :param self: Allow an object to refer to itself inside a method
        :return: The token
        :doc-author: Kaoushik kumar
        """
        with os.popen(self.gcloud_auth_print_identity_token) as cmd:
            token = cmd.read().strip()
        return token

    def get_cloud_run_url(self, service_name, project_id):
        """
        The get_cloud_run_url function takes in a service name and project id,
        and returns the URL of the Cloud Run service.

        :param self: Represent the instance of the class
        :param service_name: Specify the name of the service that you want to get information about
        :param project_id: Identify the project that contains the cloud run service
        :return: The url of the cloud run service
        :doc-author: Kaoushik Kumar
        """
        describe_service = self.describe_service.format(
            service_name=service_name, project_id=project_id
        )
        with os.popen(describe_service) as service:
            description = service.read()
        return re.findall("URL:.*\n", description)[0].split()[1].strip()
