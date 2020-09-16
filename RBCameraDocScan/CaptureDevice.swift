//
//  CaptureDevice.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import AVFoundation

protocol CaptureDevice: class {
	var torchMode: AVCaptureDevice.TorchMode { get set }
	var isTorchAvailable: Bool { get }
	
	var focusMode: AVCaptureDevice.FocusMode { get set }
	var focusPointOfInterest: CGPoint { get set }
	var isFocusPointOfInterestSupported: Bool { get }
	
	var exposureMode: AVCaptureDevice.ExposureMode { get set }
	var exposurePointOfInterest: CGPoint { get set }
	var isExposurePointOfInterestSupported: Bool { get }
	
	var isSubjectAreaChangeMonitoringEnabled: Bool { get set }
	
	func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool
	func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool
	func unlockForConfiguration()
	func lockForConfiguration() throws
}

extension AVCaptureDevice: CaptureDevice { }
