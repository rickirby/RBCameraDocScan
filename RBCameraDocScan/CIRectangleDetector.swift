//
//  CIRectangleDetector.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import AVFoundation

enum CIRectangleDetector {
	
	static let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle,
											  context: CIContext(options: nil),
											  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
	
	static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
		let biggestRectangle = rectangle(forImage: image)
		completion(biggestRectangle)
	}
	
	static func rectangle(forImage image: CIImage) -> Quadrilateral? {
		guard let rectangleFeatures = rectangleDetector?.features(in: image) as? [CIRectangleFeature] else {
			return nil
		}
		
		let quads = rectangleFeatures.map { rectangle in
			return Quadrilateral(rectangleFeature: rectangle)
		}
		
		return quads.biggest()
	}
}
