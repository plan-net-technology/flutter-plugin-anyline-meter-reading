import 'package:flutter/services.dart';

import 'constants.dart';
import 'exceptions.dart';

abstract class AnylineMeterReadingExceptionParserType {
  AnylineMeterReadingException parseException(Exception exception);
}

class AnylineMeterReadingExceptionParser implements AnylineMeterReadingExceptionParserType {
  AnylineMeterReadingException parseException(Exception exception) {
    if (exception is PlatformException) {
      if (exception.code == Constants.exceptionDefault) {
        return AnylineMeterReadingException(message: exception.message);
      } else if (exception.code == Constants.exceptionNoCameraPermission) {
        return AnylineMeterReadingNoCameraPermissionException();
      }
    }
    return AnylineMeterReadingException();
  }
}
