class AnylineMeterReadingException implements Exception {
  final String? _message;

  AnylineMeterReadingException({String? message}):
        this._message = message;

  String toString() {
    return _message == null ? "" : _message!;
  }
}

class AnylineMeterReadingNoCameraPermissionException extends AnylineMeterReadingException {}

class AnylineFailedToInitializeSDKException extends AnylineMeterReadingException {}

class AnylineLicenseExpiredException extends AnylineMeterReadingException {}