//
//  CGAffineTransform+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public extension CGAffineTransform {
	
	static func scaleTransform(forSize fromSize: CGSize, aspectFillInSize toSize: CGSize) -> CGAffineTransform {
		let scale = max(toSize.width / fromSize.width, toSize.height / fromSize.height)
		return CGAffineTransform(scaleX: scale, y: scale)
	}
	
	static func translateTransform(fromCenterOfRect fromRect: CGRect, toCenterOfRect toRect: CGRect) -> CGAffineTransform {
		let translate = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
		return CGAffineTransform(translationX: translate.x, y: translate.y)
	}
	
}
