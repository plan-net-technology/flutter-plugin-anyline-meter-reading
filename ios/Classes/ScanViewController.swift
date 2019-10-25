//
//  ScanViewController.swift
//  anyline_meter_reading
//
//  Created by Constantinescu, Robert on 25/10/2019.
//

import Foundation
import UIKit
import Anyline
import Flutter

class ScanViewController: UIViewController, ALMeterScanPluginDelegate {
    var meterScanViewPlugin : ALMeterScanViewPlugin!
    var meterScanPlugin : ALMeterScanPlugin!
    var scanView : ALScanView!
    
    var licenseKey: String!
    var result: FlutterResult!
    
    static func createInstance(result: @escaping FlutterResult, licenseKey: String) -> ScanViewController? {
        let vc = ScanViewController()
        vc.result = result
        vc.licenseKey = licenseKey
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            startScanning()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.startScanning()
                } else {
                    self.handleCameraPermissionError()
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            try self.meterScanViewPlugin?.start()
        } catch {
            handleError(error: error)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        do {
            try self.meterScanViewPlugin?.stop()
        } catch {
            handleError(error: error)
        }
    }
    
    func anylineMeterScanPlugin(_ anylineMeterScanPlugin: ALMeterScanPlugin, didFind scanResult: ALMeterResult) {
        handleScanResult(meterValue: String(scanResult.result))
    }
    
    private func startScanning() {
        do {
            self.meterScanPlugin = try ALMeterScanPlugin.init(
                pluginID: "ENERGY",
                licenseKey: licenseKey,
                delegate: self)
            try self.meterScanPlugin.setScanMode(ALScanMode.autoAnalogDigitalMeter)
            
            self.meterScanViewPlugin = ALMeterScanViewPlugin.init(scanPlugin: self.meterScanPlugin)
            self.scanView = ALScanView.init(frame: self.view.bounds, scanViewPlugin: self.meterScanViewPlugin)
        } catch {
            handleError(error: error)
        }
        
        self.view.addSubview(self.scanView)
        self.addOkButton()
        self.scanView.startCamera()
    }
    
    private func addOkButton() {
        let okButton = UIButton(frame: CGRect(x: 0, y: view.bounds.height - 400, width: view.bounds.width, height: 400))
        okButton.backgroundColor = UIColor.clear
        okButton.setTitle("OK", for: UIControlState.normal)
        okButton.titleLabel?.font = .systemFont(ofSize: 25)
        okButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        okButton.addTarget(self, action: #selector(handleOkButtonTap), for: UIControlEvents.touchUpInside)
        view.addSubview(okButton)
    }
    
    @objc private func handleOkButtonTap() {
        dismiss(animated: true) {
            self.result("")
        }
    }
    
    @objc private func handleScanResult(meterValue: String) {
        dismiss(animated: true) {
            self.result(meterValue)
        }
    }
    
    private func handleError(error: Error) {
        dismiss(animated: true) {
            self.result(FlutterError(code: Constants.RESULT_EXCEPTION_DEFAULT, message: error.localizedDescription, details: nil))
        }
    }
    
    private func handleCameraPermissionError() {
           dismiss(animated: true) {
               self.result(FlutterError(code: Constants.RESULT_EXCEPTION_NO_CAMERA_PERMISSION, message: nil, details: nil))
           }
    }
}
