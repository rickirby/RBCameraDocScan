//
//  Error.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import Foundation

public enum CameraScannerControllerError: Error {
	/// The user didn't grant permission to use the camera.
	case authorization
	/// An error occured when setting up the user's device.
	case inputDevice
	/// An error occured when trying to capture a picture.
	case capture
	/// Error when creating the CIImage.
	case ciImageCreation
}

extension CameraScannerControllerError: LocalizedError {
	
	public var errorDescription: String? {
		switch self {
		case .authorization:
			return "Failed to get the user's authorization for camera."
		case .inputDevice:
			return "Could not setup input device."
		case .capture:
			return "Could not capture pitcure."
		case .ciImageCreation:
			return "Internal Error - Could not create CIImage"
		}
	}
	
}
