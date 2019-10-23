import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anyline_meter_reading/anyline_meter_reading.dart';

void main() {
  const MethodChannel channel = MethodChannel('anyline_meter_reading');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AnylineMeterReading.platformVersion, '42');
  });
}
