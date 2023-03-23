import 'http.exception.dart';

class ExceptionHandler {
  static void httpExceptionHandle(int statusCode, String body) {
    if (statusCode < 400) {
      return;
    } else if (statusCode >= 400 && statusCode < 500) {
      throw HttpClientException('$statusCode : $body');
    } else if (statusCode >= 500 && statusCode < 600) {
      throw HttpServerException('Server Error');
    }
  }
}

