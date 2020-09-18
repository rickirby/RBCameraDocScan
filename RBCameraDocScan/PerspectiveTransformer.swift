//
//  PerspectiveTransformer.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public class PerspectiveTransformer {
	
	public static func applyTransform(to image: UIImage, withQuad quad: Quadrilateral) -> UIImage {
		
		guard let ciImage = CIImage(image: image) else { return UIImage() }
		let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
		let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
		
		var cartesianScaledQuad = quad.toCartesian(withHeight: image.size.height)
		cartesianScaledQuad.reorganize()
		
		let filteredImage = orientedImage.applyingFilter("CIPerspectiveCorrection", parameters: [
			"inputTopLeft": CIVector(cgPoint: cartesianScaledQuad.bottomLeft),
			"inputTopRight": CIVector(cgPoint: cartesianScaledQuad.bottomRight),
			"inputBottomLeft": CIVector(cgPoint: cartesianScaledQuad.topLeft),
			"inputBottomRight": CIVector(cgPoint: cartesianScaledQuad.topRight)
			])
		
		return UIImage.from(ciImage: filteredImage)
	}
	
}
