# Flutter Anyline plugin
This plugin allows to use the Anyline meter reading functionality whithin a Flutter project.
The plugin uses natively the iOS and Android Anyline SDKs (more info on the Anyline SDKs can be found here: https://documentation.anyline.com).

Requirements:
* Flutter version 1.12.13+hotfix.5
* Dart version 2.7.0
* Android Studio 3.5.3 (Build #AI-191.8026.42.35.6010548, built on November 15, 2019)
* Xcode Version 11.3.1 (11C504)
* CocoaPods 1.8.1+


**Integration**

- add anyline_meter_reading plugin to **pubspec.yaml**

```
anyline_meter_reading:
    git: 
        url: https://github.com/plan-net-technology/flutter-plugin-anyline-meter-reading
```

**For Android**

- add the following permissions to **android/app/src/main/AndroidManifest.xml**

```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.hardware.camera.autofocus" />
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
```
- add packaging options to **android/app/build.gradle**

```
android {
    packagingOptions {
        pickFirst 'lib/x86/libc++_shared.so'
        pickFirst 'lib/x86_64/libc++_shared.so'
        pickFirst 'lib/armeabi-v7a/libc++_shared.so'
        pickFirst 'lib/arm64-v8a/libc++_shared.so'
    }
}
```
            
**For iOS:**
    
- add camera permission to your **ios/Runner/Info.plist**

```
    <key>NSCameraUsageDescription</key>
    <string>YOUR-USAGE-DESCRIPTION</string>
```
    
**Usage example:**
```
    try {
      final AnylineMeterReading anylineMeterReading = await AnylineMeterReading.createInstance(YOUR_LICENSE_KEY);
      final String meterValue = await anylineMeterReading.getMeterValue();
    } catch (e) {
      // Handle AnylineMeterReadingException here
      // Possible Exceptions: 
      //    - AnylineMeterReadingException (default exception, message is optional)
      //    - AnylineMeterReadingNoCameraPermissionException
    }
```
