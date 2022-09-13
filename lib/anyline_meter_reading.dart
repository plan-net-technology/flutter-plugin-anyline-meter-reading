import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'constants.dart';
import 'exceptions.dart';
import 'exceptions_parser.dart';

class AnylineMeterReading {
  static const MethodChannel _channel = const MethodChannel('anyline_meter_reading');

  static AnylineMeterReading createInstance() {
    final AnylineMeterReading anylineMeterReading = AnylineMeterReading._internal();
    return anylineMeterReading;
  }

  AnylineMeterReading._internal();

  Future<String> getMeterValue(String license, {AnylineMeterReadingExceptionParserType? anylineMeterReadingExceptionParser}) async {
    try {
      this._setLicenseKey(license);
      final String meterValue = await _channel.invokeMethod(Constants.methodGetMeterValue);
      return meterValue;
    } catch (exception) {
      throw _parseException(exception as Exception);
    }
  }

  Future<bool> isSupported(String license, {AnylineMeterReadingExceptionParserType? anylineMeterReadingExceptionParser}) async {
    if (Platform.isIOS) {
      return true;
    } else {
      try {
        final Map<String, String> arguments = {
          Constants.keyLicenseKey: license
        };
        bool sdkInitialized = await _channel.invokeMethod(Constants.methodInitAnyline, arguments);
        PlatformDispatcher.instance.onError = (error, stack) {
          sdkInitialized = false;
          return true;
        };
        return sdkInitialized;
      } catch (exception) {
        final parsedException = _parseException(exception as Exception);
        if (parsedException is AnylineFailedToInitializeSDKException) {
          return false;
        } else {
          throw parsedException;
        }
      }
    }
  }

  _setLicenseKey(String licenseKey) async {
    final Map<String, String> arguments = { Constants.keyLicenseKey: licenseKey };
    try {
      return await _channel.invokeMethod(Constants.methodSetLicenseKey, arguments);
    } catch (exception) {
      throw _parseException(exception as Exception);
    }
  }

  AnylineMeterReadingException _parseException(Exception exception, {AnylineMeterReadingExceptionParserType? anylineMeterReadingExceptionParser}) {
    return (anylineMeterReadingExceptionParser ?? AnylineMeterReadingExceptionParser()).parseException(exception);
  }
}
