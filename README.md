# Flutter Anyline plugin
This is developed for the EWI Flutter project.
The plugin will be used whithin the Flutter Dart code so that at some point the app 
can get meter values from the device camera feed.

Requirements:
* Flutter version 1.9.1+hotfix.5
* Dart version 2.5.0
* Android Studio 3.5.1 (Build #AI-191.8026.42.35.5900203)
* Xcode 11+
* CocoaPods 1.8.3+


**Integration**

- add anyline_meter_reading plugin to **pubspec.yaml**

```
anyline_meter_reading:
    git: 
        url: https://gitlab.plan-net.com/pnt/anyline-meter-reading.git
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
