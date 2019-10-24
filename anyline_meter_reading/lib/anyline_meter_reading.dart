import 'dart:async';
import 'package:anyline_meter_reading/exceptions.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'exceptions_parser.dart';

class AnylineMeterReading {
  static const MethodChannel _channel = const MethodChannel('anyline_meter_reading');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<AnylineMeterReading> createInstance(String licenseKey) async {
    final AnylineMeterReading anylineMeterReading = AnylineMeterReading._internal();
    await anylineMeterReading._setLicenseKey(licenseKey);
    return anylineMeterReading;
  }

  AnylineMeterReading._internal();

  Future<String> getMeterValue({AnylineMeterReadingExceptionParserType anylineMeterReadingExceptionParser}) async {
    try {
      final String meterValue = await _channel.invokeMethod(Constants.METHOD_GET_METER_VALUE);
      return meterValue;
    } catch (exception) {
      throw _parseException(exception);
    }
  }

  _setLicenseKey(String licenseKey) async {
    final Map<String, String> arguments = { Constants.KEY_LICENSE_KEY: licenseKey };
    try {
      return await _channel.invokeMethod(Constants.METHOD_SET_LICENSE_KEY, arguments);
    } catch (exception) {
      throw _parseException(exception);
    }
  }

  AnylineMeterReadingException _parseException(Exception exception, {AnylineMeterReadingExceptionParserType anylineMeterReadingExceptionParser}) {
    return (anylineMeterReadingExceptionParser ?? AnylineMeterReadingExceptionParser()).parseException(exception);
  }
}