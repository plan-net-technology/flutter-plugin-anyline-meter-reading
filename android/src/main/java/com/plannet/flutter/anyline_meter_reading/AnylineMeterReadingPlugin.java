/*
 * *
 *  * Created by Gabriel Dusa on 6/30/20 11:11 AM
 *  * Copyright (c) 2020 Plan.net Technology . All rights reserved.
 *  * Last modified 6/30/20 11:11 AM
 *
 */

package com.plannet.ewi;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;

import com.adobe.marketing.mobile.*;
import com.plannet.ewi.*;

public class AdobeAnalyticsManager {
  final static int sharedPreferencesMode = Context.MODE_PRIVATE;
  final  static String sharedPreferencesName = "FlutterSharedPreferences";
  static final String kTrackingEnabledStatus = "flutter.KEY_TRACKING_STATUS"; // we need 'flutter.' as this is how the Flutter
  // plugin shared_preferences prefixes the keys
  static final String TAG = "AdobeAnalyticsManager";

  static public void setupAnalytics(Application application) {
    MobileCore.setApplication(application);
    MobileCore.configureWithAppID(BuildConfig.ADOBE_ANALYTICS_APP_ID);
    try {
      Analytics.registerExtension(); //Register Analytics with Mobile Core
      Identity.registerExtension();
      MobileCore.setWrapperType(WrapperType.FLUTTER);
      MobileCore.start(null);
      Lifecycle.registerExtension();
    } catch (Exception e) {
      android.util.Log.e(TAG, "setupAnalytics: " + "exception: " + e.toString());
    }
  }

  static public void lifecycleStart(Application application) {
    if (isTrackingEnabled(application)) {
      MobileCore.setApplication(application);
      MobileCore.lifecycleStart(null);
    }
  }

  static public void lifecyclePause(Application application) {
    if (isTrackingEnabled(application)) {
      MobileCore.lifecyclePause();
    }
  }

  static private boolean isTrackingEnabled(Application application) {
    final SharedPreferences sharedPreferences = application.getSharedPreferences(sharedPreferencesName, sharedPreferencesMode);
    return sharedPreferences.getBoolean(kTrackingEnabledStatus, false);
  }
}