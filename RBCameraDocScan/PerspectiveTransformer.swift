//
//  PerspectiveTransformer.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

public class PerspectiveTransformer {
	
	public static func applyTransform(to image: UIImage, withQuad quad: Quadrilateral) -> UIImage {
		
		guard let ciImage = CIImage(image: image) else { return UIImage() }
		let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
		let orientedImage = ciImage.oriented(forExifOrientation: Int32(cgOrientation.rawValue))
		
		var cartesianScaledQuad = quad.toCartesian(withHeight: image.size.height)
		cartesianScaledQuad.reorganize()
		
		let context = CIContext(options: nil)
		let perspective = CIFilter.perspectiveCorrection()
		perspective.inputImage = orientedImage
		perspective.topLeft = cartesianScaledQuad.bottomLeft
		perspective.topRight = cartesianScaledQuad.bottomRight
		perspective.bottomRight = cartesianScaledQuad.topRight
		perspective.bottomLeft = cartesianScaledQuad.topLeft
		
		if let output = perspective.outputImage {
			if let cgimg = context.createCGImage(output, from: output.extent) {
				
				return UIImage(cgImage: cgimg)
			}
		}
		
		return UIImage()
	}
	
}
