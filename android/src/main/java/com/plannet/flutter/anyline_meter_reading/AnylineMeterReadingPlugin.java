package com.plannet.flutter.anyline_meter_reading;

import android.app.Activity;
import android.content.Intent;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AnylineMeterReadingPlugin */
public class AnylineMeterReadingPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private final Activity activity;
  private MethodChannel.Result result;
  private String licenseKey;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "anyline_meter_reading");
    final AnylineMeterReadingPlugin instance = new AnylineMeterReadingPlugin(registrar.activity());
    registrar.addActivityResultListener(instance);
    channel.setMethodCallHandler(instance);
  }

  private AnylineMeterReadingPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    this.result = result;
    switch (call.method) {
      case Constants.METHOD_SET_LICENSE_KEY:
        this.licenseKey = call.argument(Constants.KEY_LICENSE_KEY);
        result.success("");
        break;
      case Constants.METHOD_GET_METER_VALUE:
        startScanActivity(activity);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == Constants.SCAN_ACTIVITY_REQUEST_CODE) {
      if (resultCode == Constants.RESULT_SUCCESS) {
        final List<String> results = new ArrayList<>();
        results.add(data.getStringExtra(Constants.KEY_METER_VALUE));
        results.add(data.getStringExtra(Constants.KEY_METER_CUTOUT_IMAGE));
        result.success(results);
        return true;
      } else if (resultCode == Constants.RESULT_EXCEPTION_DEFAULT) {
        result.error(String.valueOf(Constants.RESULT_EXCEPTION_DEFAULT), data.getStringExtra(Constants.KEY_EXCEPTION), null);
        return true;
      } else if (resultCode == Constants.RESULT_EXCEPTION_NO_CAMERA_PERMISSION) {
        result.error(String.valueOf(Constants.RESULT_EXCEPTION_NO_CAMERA_PERMISSION), null, null);
        return true;
      }
    }
    return false;
  }

  private void startScanActivity(Activity activity) {
    Intent i = new Intent(activity, ScanActivity.class);
    i.putExtra(Constants.KEY_LICENSE_KEY, licenseKey);
    activity.startActivityForResult(i, Constants.SCAN_ACTIVITY_REQUEST_CODE);
  }

}
