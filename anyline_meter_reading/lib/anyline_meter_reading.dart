import 'dart:async';

import 'package:flutter/services.dart';

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

  Future<String> getMeterValue() async {
    return await _channel.invokeMethod("METHOD_GET_METER_VALUE");
  }

  _setLicenseKey(String licenseKey) async {
    return await _channel.invokeMethod("METHOD_SET_LICENSE_KEY", {
      "KEY_LICENSE_KEY": licenseKey
    });
  }
}
