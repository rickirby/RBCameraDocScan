//
//  CGImagePropertyOrientation+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension CGImagePropertyOrientation {
	init(_ uiOrientation: UIImage.Orientation) {
		switch uiOrientation {
		case .up:
			self = .up
		case .upMirrored:
			self = .upMirrored
		case .down:
			self = .down
		case .downMirrored:
			self = .downMirrored
		case .left:
			self = .left
		case .leftMirrored:
			self = .leftMirrored
		case .right:
			self = .right
		case .rightMirrored:
			self = .rightMirrored
		@unknown default:
			assertionFailure("Unknow orientation, falling to default")
			self = .right
		}
	}
}
