package com.plannet.ewi.anyline_meter_reading;

public class Constants {
    // Methods
    static final String METHOD_SET_LICENSE_KEY = "METHOD_SET_LICENSE_KEY";
    static final String METHOD_GET_METER_VALUE = "METHOD_GET_METER_VALUE";

    // Keys
    static final String KEY_LICENSE_KEY = "KEY_LICENSE_KEY";
    static final String KEY_METER_VALUE = "KEY_METER_VALUE";
    static final String KEY_EXCEPTION = "KEY_EXCEPTION";

    // EXCEPTIONS
    static final String EXCEPTION_DEFAULT = "EXCEPTION_DEFAULT";
    static final String EXCEPTION_PERMISSIONS = "EXCEPTION_PERMISSIONS";

    // RESULT VALUES
    static final int RESULT_SUCCESS = 100;
    static final int RESULT_DEFAULT_ERROR = 101;
    static final int RESULT_CAMERA_PERMISSION_ERROR = 102;

    // ACTIVITY REQUEST
    static final int SCAN_ACTIVITY_REQUEST_CODE = 10000;

    // CONFIG
    static final String CONFIG_FILE_NAME = "config.json";
}
