abstract class Constants {
  static final String methodSetLicenseKey = "METHOD_SET_LICENSE_KEY";
  static final String methodGetMeterValue = "METHOD_GET_METER_VALUE";

  static final String keyLicenseKey = "KEY_LICENSE_KEY";

  static final String exceptionDefault = "101";
  static final String exceptionNoCameraPermission = "102";

  static final List<String> anylineSupportedAbisList = [
    'armeabi', 'armeabi-v7a', 'armeabi-v7a-hard', 'arm64-v8a', 'mips64', 'mips'];

  static final List<String> anylineUnsupportedAbisList = ['x86', 'x86_64'];
}
