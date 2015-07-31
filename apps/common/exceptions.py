from rest_framework.exceptions import APIException


class APIError(APIException):
    '''
        Custom exception. Can be raised with something like:
            raise APIError("some error message", status_code=501)
        This is then handled by the middleware to return a JSON
        error message with supplied status code
    '''

    def __init__(self, message, status_code=500):
        self.status_code = status_code
        self.detail = message
