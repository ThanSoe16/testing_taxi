class HttpClientException implements Exception {
  final String message;

  HttpClientException(this.message);

  @override
  String toString() {
    return message;
  }
}

class HttpServerException implements Exception {
  final String message;

  HttpServerException(this.message);

  @override
  String toString() {
    return message;
  }
}

