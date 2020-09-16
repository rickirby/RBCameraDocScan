//
//  CGSize+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension CGSize {
	func scaleFactor(forMaxWidth maxWidth: CGFloat, maxHeight: CGFloat) -> CGFloat {
		if width < maxWidth && height < maxHeight { return 1 }
		
		let widthScaleFactor = 1 / (width / maxWidth)
		let heightScaleFactor = 1 / (height / maxHeight)
		
		return min(widthScaleFactor, heightScaleFactor)
	}
}
