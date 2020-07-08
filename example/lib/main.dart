import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:anyline_meter_reading/anyline_meter_reading.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {

  String meterText = "Click the camera button to scan";
  ImageProvider cutoutImage;

  @override
  void initState() {
    super.initState();
    cutoutImage = NetworkImage("https://hansmengroup.com/wp-content/uploads/2014/12/anyline.jpg");
  }

  void callAnyline() async {

    try {
    final AnylineMeterReading anylineMeterReading = await AnylineMeterReading.createInstance("ewogICJsaWNlbnNlS2V5VmVyc2lvbiI6IDIsCiAgImRlYnVnUmVwb3J0aW5nIjogIm9mZiIsCiAgImltYWdlUmVwb3J0Q2FjaGluZyI6IHRydWUsCiAgIm1ham9yVmVyc2lvbiI6ICIyIiwKICAibWF4RGF5c05vdFJlcG9ydGVkIjogMiwKICAicGluZ1JlcG9ydGluZyI6IHRydWUsCiAgInBsYXRmb3JtIjogWwogICAgImlPUyIKICBdLAogICJzY29wZSI6IFsKICAgICJBTEwiCiAgXSwKICAic2hvd1BvcFVwQWZ0ZXJFeHBpcnkiOiB0cnVlLAogICJzaG93V2F0ZXJtYXJrIjogdHJ1ZSwKICAidG9sZXJhbmNlRGF5cyI6IDUsCiAgInZhbGlkIjogIjIwMjAtMDYtMjUiLAogICJpb3NJZGVudGlmaWVyIjogWwogICAgImNvbS50ZXN0cy5yaWNhcmRvb2xpdmVpcmEuYW55bGluZU1ldGVyUmVhZGluZ0V4YW1wbGUiCiAgXQp9Ck51aU5aNWZOeENBK24xRDBrZGRMRzhjK2o4NW93S3g3R1pRWWFLQy9vbUErSVFwN2RSR1FDSDUvYit0K3JoM3k1SlRiajNPaDZwNmZhOWZwOFF0dGRuT3BPZEpCd3lpZHkrMjZ0SU5XcGhDcGpvTlRrM2c0NjU1cmE1L1NRdUFIOGJtYVo5Y0g1b2hCM0lvNmd3S1dHdCtPSmtvd0VueHZzZ1hFT1hwQkFTZzY0cTlLemc2SDgyZXJEU29KOS91Zy9CSEk5dXd5dTV3a2FWYitWTGVJeDVrYi9hVGppb0hNamttZUtoeGk1ZXQyb0pTRTBiOEtLR3dZZXBCMGhCTzlHL0RqKzRyZTI3Qm5DL1R2dTRmTFJ3bHJQTlNKbmlFS0xzV1pMdHZkeGxOQVRCWnlQNWNuNCtRbGpURyswYjdXZXFLSUVBNThTbkVONWVjSXpHai81dz09");
    List<dynamic> result = await anylineMeterReading.getMeterValue();
    setState((){
      meterText = result[0].toString();
      cutoutImage = FileImage(new File(result[1].toString()));
    });
  } catch (e) {
    var d = "bug";
    // Handle AnylineMeterReadingException here
    // Possible Exceptions: 
    //    - AnylineMeterReadingException (default exception, message is optional)
    //    - AnylineMeterReadingNoCameraPermissionException
  }
}

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Anyline Meter Reading'),
        ),
        body: Center(
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[ 
              Text('$meterText', style: Theme.of(context).textTheme.headline4),
              Image(
                image:cutoutImage,
                fit: BoxFit.contain,
                )
            ]
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: callAnyline,
          tooltip: "Start Scanning Meter",
          child: Icon(Icons.camera_alt)
          ),
      ),
    );
  }



  
}