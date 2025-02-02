class AppException implements Exception {
  static AppException from(dynamic exception) {
    if (exception is AppException) {
      return exception;
    }

    return UnknownException();
  }
}

class UnknownException extends AppException {}

class NetworkException extends AppException {}
