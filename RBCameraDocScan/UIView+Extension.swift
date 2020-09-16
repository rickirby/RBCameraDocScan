//
//  UIView+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIView {
	func addAllSubviews(views: [UIView]) {
		for everyView in views {
			self.addSubview(everyView)
		}
	}
}
