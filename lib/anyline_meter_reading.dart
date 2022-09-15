import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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

  Future<bool> isSupported() async {
    if (Platform.isIOS) {
      return true;
    }
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final deviceSupportedAbis = androidInfo.supportedAbis;
    if (deviceSupportedAbis.isEmpty) {
      return false;
    }
    for (String? abi in deviceSupportedAbis) {
      if (abi != null && Constants.anylineSupportedAbisList.contains(abi)) {
        return true;
      }
    }
    return false;
  }

  Future<String> getMeterValue(String license, {AnylineMeterReadingExceptionParserType? anylineMeterReadingExceptionParser}) async {
    try {
      this._setLicenseKey(license);
      final String meterValue = await _channel.invokeMethod(Constants.methodGetMeterValue);
      return meterValue;
    } catch (exception) {
      throw _parseException(exception as Exception);
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
