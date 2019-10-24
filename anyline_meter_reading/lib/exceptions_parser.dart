import 'package:anyline_meter_reading/constants.dart';
import 'package:flutter/services.dart';
import 'exceptions.dart';

abstract class AnylineMeterReadingExceptionParserType {
  AnylineMeterReadingException parseException(Exception exception);
}

class AnylineMeterReadingExceptionParser implements AnylineMeterReadingExceptionParserType {
  AnylineMeterReadingException parseException(Exception exception) {
    if (exception is PlatformException) {
      if (exception.code == Constants.EXCEPTION_DEFAULT) {
        return AnylineMeterReadingException(message: exception.message);
      } else if (exception.code == Constants.EXCEPTION_NO_CAMERA_PERMISSION) {
        return AnylineMeterReadingNoCameraPermissionException();
      }
    }
    return AnylineMeterReadingException();
  }
}