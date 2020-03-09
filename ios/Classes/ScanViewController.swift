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
    // MARK: - Properties
    
    var meterScanViewPlugin : ALMeterScanViewPlugin!
    var meterScanPlugin : ALMeterScanPlugin!
    var scanView : ALScanView!
    var licenseKey: String!
    var result: FlutterResult!
    
    // MARK: - Init
    
    static func createInstance(result: @escaping FlutterResult, licenseKey: String) -> ScanViewController? {
        let vc = ScanViewController()
        vc.result = result
        vc.licenseKey = licenseKey
        return vc
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkCameraPermissions()
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		startAnylineScanning()
	}
	
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnylineScanning()
    }
    
    // MARK: - Public
    
    func anylineMeterScanPlugin(_ anylineMeterScanPlugin: ALMeterScanPlugin, didFind scanResult: ALMeterResult) {
        handleScanResult(meterValue: String(scanResult.result))
    }
    
    // MARK: - Private
    
	private func setupUI() {
		view.backgroundColor = UIColor.black
	}
	
	private func checkCameraPermissions() {
		DispatchQueue.main.async {
			if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
				self.startScanning()
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
	}
	
    private func startScanning() {
        DispatchQueue.main.async {
            do {
                self.meterScanPlugin = try ALMeterScanPlugin.init(
                    pluginID: "ENERGY",
                    licenseKey: self.licenseKey,
                    delegate: self)
                try self.meterScanPlugin.setScanMode(ALScanMode.autoAnalogDigitalMeter)
                
                self.meterScanViewPlugin = ALMeterScanViewPlugin.init(scanPlugin: self.meterScanPlugin)
                self.scanView = ALScanView.init(frame: self.view.bounds, scanViewPlugin: self.meterScanViewPlugin)
                self.view.addSubview(self.scanView)
                self.addOkButton()
				self.startAnylineScanning()
                self.scanView.startCamera()
            } catch {
                self.handleError(error: error)
            }
        }
    }
    
	private func startAnylineScanning() {
		do {
			try self.meterScanViewPlugin?.stop()
			try self.meterScanViewPlugin?.start()
		} catch {
			handleError(error: error)
		}
	}
	
	private func stopAnylineScanning() {
		do {
            try self.meterScanViewPlugin?.stop()
        } catch {
            handleError(error: error)
        }
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
		DispatchQueue.main.async {
			self.dismiss(animated: true) {
				self.result(FlutterError(code: Constants.RESULT_EXCEPTION_NO_CAMERA_PERMISSION, message: nil, details: nil))
			}
		}
    }
}
