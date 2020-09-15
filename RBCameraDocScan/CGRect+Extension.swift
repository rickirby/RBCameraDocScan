//
//  CGRect+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public extension CGRect {
	
	func scaleAndCenter(withRatio ratio: CGFloat) -> CGRect {
		let scaleTransform = CGAffineTransform(scaleX: ratio, y: ratio)
		let scaledRect = applying(scaleTransform)
		
		let translateTransform = CGAffineTransform(translationX: origin.x * (1 - ratio) + (width - scaledRect.width) / 2.0, y: origin.y * (1 - ratio) + (height - scaledRect.height) / 2.0)
		let translatedRect = scaledRect.applying(translateTransform)
		
		return translatedRect
	}
}
