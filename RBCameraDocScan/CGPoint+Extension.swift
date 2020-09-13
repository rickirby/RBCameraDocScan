//
//  CGPoint+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension CGPoint {
	
	func surroundingSquare(withSize size: CGFloat) -> CGRect {
		return CGRect(x: x - size / 2.0, y: y - size / 2.0, width: size, height: size)
	}
	
	func isWithin(delta: CGFloat, ofPoint point: CGPoint) -> Bool {
		return (abs(x - point.x) <= delta) && (abs(y - point.y) <= delta)
	}
	
	func cartesian(withHeight height: CGFloat) -> CGPoint {
		return CGPoint(x: x, y: height - y)
	}
	
	func distanceTo(point: CGPoint) -> CGFloat {
		return hypot((self.x - point.x), (self.y - point.y))
	}
	
	func closestCornerFrom(quad: Quadrilateral) -> CornerPosition {
		var smallestDistance = distanceTo(point: quad.topLeft)
		var closestCorner = CornerPosition.topLeft
		
		if distanceTo(point: quad.topRight) < smallestDistance {
			smallestDistance = distanceTo(point: quad.topRight)
			closestCorner = .topRight
		}
		
		if distanceTo(point: quad.bottomRight) < smallestDistance {
			smallestDistance = distanceTo(point: quad.bottomRight)
			closestCorner = .bottomRight
		}
		
		if distanceTo(point: quad.bottomLeft) < smallestDistance {
			smallestDistance = distanceTo(point: quad.bottomLeft)
			closestCorner = .bottomLeft
		}
		
		return closestCorner
	}
}
