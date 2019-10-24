import Flutter
import UIKit

public class SwiftAnylineMeterReadingPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "anyline_meter_reading", binaryMessenger: registrar.messenger())
    let instance = SwiftAnylineMeterReadingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
