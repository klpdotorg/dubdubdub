
class APIException(Exception):
    '''
        Custom exception. Can be raised with something like:
            raise APIException("some error message", status_code=501)
        This is then handled by the middleware to return a JSON
        error message with supplied status code
    '''
    
    def __init__(self, message, status_code=500):
        super(APIException, self).__init__(self, message, status_code)
        self.message = message
        self.status_code = status_code