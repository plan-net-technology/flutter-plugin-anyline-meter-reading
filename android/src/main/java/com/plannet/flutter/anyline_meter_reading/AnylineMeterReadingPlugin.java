package com.plannet.flutter.anyline_meter_reading;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.NonNull;

import at.nineyards.anyline.core.LicenseException;
import io.anyline.AnylineSDK;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;


import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;
import io.flutter.plugin.common.PluginRegistry;

/** AnylineMeterReadingPlugin */
public class AnylineMeterReadingPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private ActivityPluginBinding pluginBinding;
  private Activity activity;

  private MethodChannel.Result result;
  private String licenseKey;

  private void startScanActivity(Activity activity) {
    Intent i = new Intent(activity, ScanActivity.class);
    i.putExtra(Constants.KEY_LICENSE_KEY, licenseKey);
    activity.startActivityForResult(i, Constants.SCAN_ACTIVITY_REQUEST_CODE);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == Constants.SCAN_ACTIVITY_REQUEST_CODE) {
      if (resultCode == Constants.RESULT_SUCCESS) {
        result.success(data.getStringExtra(Constants.KEY_METER_VALUE));
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

 //V2 Engine
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "anyline_meter_reading");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      this.result = result;
      switch (call.method) {
          case Constants.METHOD_SET_LICENSE_KEY:
              this.licenseKey = call.argument(Constants.KEY_LICENSE_KEY);
              result.success("");
              break;
          case Constants.METHOD_GET_METER_VALUE:
              try {
                  AnylineSDK.init(licenseKey, activity.getApplicationContext());
                  startScanActivity(activity);
              } catch (Exception e) {
                  if (e instanceof LicenseException) {
                      result.error(String.valueOf(Constants.RESULT_EXCEPTION_LICENSE_EXPIRED), null, null);
                  } else {
                      result.error(String.valueOf(Constants.RESULT_EXCEPTION_FAILED_TO_INIT_ANYLINE), null, null);
                  }
                  e.printStackTrace();
              } catch (Throwable error) {
                  error.printStackTrace();
                  result.error(String.valueOf(Constants.RESULT_EXCEPTION_FAILED_TO_INIT_ANYLINE), null, null);
              }
              break;
          default:
              result.notImplemented();
              break;
      }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  // --- ActivityAware

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
    pluginBinding = binding;
    pluginBinding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
    pluginBinding.removeActivityResultListener(this);
    pluginBinding = null;
  }
}
