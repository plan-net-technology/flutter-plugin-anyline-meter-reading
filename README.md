**Integration**
    - TBD

**For Android:**
    - add the following permissions to android/app/src/main/AndroidManifest.xml:
```
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.hardware.camera.autofocus" />
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
```
            
**For iOS:**
    - add camera permission to your ios/Runner/Info.plist
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
