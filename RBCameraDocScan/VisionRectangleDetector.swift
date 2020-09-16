//
//  VisionRectangleDetector.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import Vision
import Foundation

@available(iOS 11.0, *)
enum VisionRectangleDetector {
	
	private static func completeImageRequest(for request: VNImageRequestHandler, width: CGFloat, height: CGFloat, completion: @escaping ((Quadrilateral?) -> Void)) {
		let rectangleDetectionRequest: VNDetectRectanglesRequest = {
			let rectDetectRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
				guard error == nil, let results = request.results as? [VNRectangleObservation], !results.isEmpty else {
					completion(nil)
					return
				}
				
				let quads: [Quadrilateral] = results.map(Quadrilateral.init)
				
				guard let biggest = quads.biggest() else {
					completion(nil)
					return
				}
				
				let transform = CGAffineTransform.identity
					.scaledBy(x: width, y: height)
				
				completion(biggest.applying(transform))
			})
			
			rectDetectRequest.minimumConfidence = 0.8
			rectDetectRequest.maximumObservations = 15
			rectDetectRequest.minimumAspectRatio = 0.3
			
			return rectDetectRequest
		}()
		
		do {
			try request.perform([rectangleDetectionRequest])
		} catch {
			completion(nil)
			return
		}
		
	}
	
	static func rectangle(forPixelBuffer pixelBuffer: CVPixelBuffer, completion: @escaping ((Quadrilateral?) -> Void)) {
		let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
		VisionRectangleDetector.completeImageRequest(
			for: imageRequestHandler,
			width: CGFloat(CVPixelBufferGetWidth(pixelBuffer)),
			height: CGFloat(CVPixelBufferGetHeight(pixelBuffer)),
			completion: completion)
	}
	
	static func rectangle(forImage image: CIImage, completion: @escaping ((Quadrilateral?) -> Void)) {
		let imageRequestHandler = VNImageRequestHandler(ciImage: image, options: [:])
		VisionRectangleDetector.completeImageRequest(
			for: imageRequestHandler, width: image.extent.width,
			height: image.extent.height, completion: completion)
	}
	
	static func rectangle(forImage image: CIImage, orientation: CGImagePropertyOrientation, completion: @escaping ((Quadrilateral?) -> Void)) {
		let imageRequestHandler = VNImageRequestHandler(ciImage: image, orientation: orientation, options: [:])
		let orientedImage = image.oriented(orientation)
		VisionRectangleDetector.completeImageRequest(
			for: imageRequestHandler, width: orientedImage.extent.width,
			height: orientedImage.extent.height, completion: completion)
	}
}
