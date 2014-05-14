from django.conf import settings
from django.http import JsonResponse

def get_exception_status_code(exception):
    '''
        If the exception object passed has a status_code, return that, else 500
    '''
    return getattr(exception, 'status_code', 500)

def get_exception_error_message(exception):
    '''
        Check for classes of exceptions and return custom error message, or else return default exception error message
    '''
    return unicode(exception)

class APIExceptionMiddleware(object):
    def process_exception(self, request, exception):
        if settings.API_DEBUG: #if in DEBUG mode, throw stack trace exceptions as normal
            return None
        if not request.path.startswith("/api"): #if its not an API request, handle exceptions normally
            return None
        error_message = get_exception_error_message(exception)
        status_code = get_exception_status_code(exception)
        return JsonResponse({'error': error_message}, status=status_code)

