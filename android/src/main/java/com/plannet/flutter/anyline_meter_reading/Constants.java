package com.plannet.flutter.anyline_meter_reading;

public class Constants {
    static final String METHOD_SET_LICENSE_KEY = "METHOD_SET_LICENSE_KEY";
    static final String METHOD_GET_METER_VALUE = "METHOD_GET_METER_VALUE";

    static final String KEY_LICENSE_KEY = "KEY_LICENSE_KEY";
    static final String KEY_METER_VALUE = "KEY_METER_VALUE";
    static final String KEY_EXCEPTION = "KEY_EXCEPTION";

    static final int RESULT_SUCCESS = 100;
    static final int RESULT_EXCEPTION_DEFAULT = 101;
    static final int RESULT_EXCEPTION_NO_CAMERA_PERMISSION = 102;
    static final int RESULT_EXCEPTION_LICENSE_EXPIRED = 103;
    static final int RESULT_EXCEPTION_FAILED_TO_INIT_ANYLINE = 104;

    static final int SCAN_ACTIVITY_REQUEST_CODE = 10000;

    static final String CONFIG_FILE_NAME = "config.json";
}

