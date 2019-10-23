import 'dart:async';

import 'package:flutter/services.dart';

class AnylineMeterReading {
  static const MethodChannel _channel =
      const MethodChannel('anyline_meter_reading');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
