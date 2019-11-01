import Flutter
import UIKit

public class SwiftAnylineMeterReadingPlugin: NSObject, FlutterPlugin {
    private var licenseKey: String?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "anyline_meter_reading", binaryMessenger: registrar.messenger())
        let instance = SwiftAnylineMeterReadingPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case Constants.METHOD_SET_LICENSE_KEY: handleSetLicenseKey(call, result: result)
        case Constants.METHOD_GET_METER_VALUE: presentMeterReading(result: result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func handleSetLicenseKey(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
            let licenseKey = arguments[Constants.KEY_LICENSE_KEY] as? String else {
                result(FlutterMethodNotImplemented)
                return
        }
        self.licenseKey = licenseKey
        result("")
    }
    
    private func presentMeterReading(result: @escaping FlutterResult) {
        guard let licenseKey = licenseKey,
            let vc = ScanViewController.createInstance(result: result, licenseKey: licenseKey) else {
                result(FlutterMethodNotImplemented)
                return
        }
        vc.modalPresentationStyle = .fullScreen
        UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true, completion: nil)
    }
}
