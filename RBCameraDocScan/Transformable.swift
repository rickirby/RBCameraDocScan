//
//  Transformable.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

protocol Transformable {
	func applying(_ transform: CGAffineTransform) -> Self
}

extension Transformable {
	func applyTransforms(_ transforms: [CGAffineTransform]) -> Self {
		
		var transformableObject = self
		
		transforms.forEach { (transform) in
			transformableObject = transformableObject.applying(transform)
		}
		
		return transformableObject
	}
	
}
