//
//  CameraScannerResults.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public struct CameraScannerResults {
	
	public var originalScan: CameraScannerScan
	public var croppedScan: CameraScannerScan
	public var enhancedScan: CameraScannerScan?
	public var doesUserPreferEnhancedScan: Bool
	public var detectedRectangle: Quadrilateral
	
	@available(*, unavailable, renamed: "originalScan")
	public var originalImage: UIImage?
	
	@available(*, unavailable, renamed: "croppedScan")
	public var scannedImage: UIImage?
	
	@available(*, unavailable, renamed: "enhancedScan")
	public var enhancedImage: UIImage?
	
	@available(*, unavailable, renamed: "doesUserPreferEnhancedScan")
	public var doesUserPreferEnhancedImage: Bool = false
	
	init(detectedRectangle: Quadrilateral, originalScan: CameraScannerScan, croppedScan: CameraScannerScan, enhancedScan: CameraScannerScan?, doesUserPreferEnhancedScan: Bool = false) {
		self.detectedRectangle = detectedRectangle
		
		self.originalScan = originalScan
		self.croppedScan = croppedScan
		self.enhancedScan = enhancedScan
		
		self.doesUserPreferEnhancedScan = doesUserPreferEnhancedScan
	}
}
