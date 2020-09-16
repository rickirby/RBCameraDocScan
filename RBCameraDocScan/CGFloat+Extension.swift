//
//  CGFloat+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension CGFloat {
	func makeDynamicW() -> CGFloat {
		let devWidth = UIScreen.main.bounds.width
		let val = (self / 414) * devWidth
		return val
	}
	
	func makeDynamicH() -> CGFloat {
		let devHeight = UIScreen.main.bounds.height
		let val = (self / 896) * devHeight
		return val
	}
}
