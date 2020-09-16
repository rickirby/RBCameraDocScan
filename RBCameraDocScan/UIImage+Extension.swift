//
//  UIImage+Extension.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIImage {
	func scaledImage(atPoint point: CGPoint, scaleFactor: CGFloat, targetSize size: CGSize) -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }
		
		let scaledSize = CGSize(width: size.width / scaleFactor, height: size.height / scaleFactor)
		let midX = point.x - scaledSize.width / 2.0
		let midY = point.y - scaledSize.height / 2.0
		let newRect = CGRect(x: midX, y: midY, width: scaledSize.width, height: scaledSize.height)
		
		guard let croppedImage = cgImage.cropping(to: newRect) else {
			return nil
		}
		
		return UIImage(cgImage: croppedImage)
	}
	
	func scaledImage(scaleFactor: CGFloat) -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }
		
		let customColorSpace = CGColorSpaceCreateDeviceRGB()
		
		let width = CGFloat(cgImage.width) * scaleFactor
		let height = CGFloat(cgImage.height) * scaleFactor
		let bitsPerComponent = cgImage.bitsPerComponent
		let bytesPerRow = cgImage.bytesPerRow
		let bitmapInfo = cgImage.bitmapInfo.rawValue
		
		guard let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: customColorSpace, bitmapInfo: bitmapInfo) else { return nil }
		
		context.interpolationQuality = .high
		context.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
		
		return context.makeImage().flatMap { UIImage(cgImage: $0) }
	}
	
	func pixelBuffer() -> CVPixelBuffer? {
		let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
		var pixelBufferOpt: CVPixelBuffer?
		let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBufferOpt)
		guard status == kCVReturnSuccess, let pixelBuffer = pixelBufferOpt else {
			return nil
		}
		
		CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
		let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
		
		let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
		guard let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
			return nil
		}
		
		context.translateBy(x: 0, y: self.size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		
		UIGraphicsPushContext(context)
		self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
		UIGraphicsPopContext()
		CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
		
		return pixelBuffer
	}
	
}

public extension UIImage {
	
	struct RotationOptions: OptionSet {
		public let rawValue: Int
		
		static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
		static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
		
		public init(rawValue: Int) {
			self.rawValue = rawValue
		}
	}
	
	static func from(ciImage: CIImage) -> UIImage {
		if let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) {
			return UIImage(cgImage: cgImage)
		} else {
			return UIImage(ciImage: ciImage, scale: 1.0, orientation: .up)
		}
	}
	
	func applyingPortraitOrientation() -> UIImage {
		switch imageOrientation {
		case .up:
			return rotated(by: Measurement(value: Double.pi, unit: .radians), options: []) ?? self
		case .down:
			return rotated(by: Measurement(value: Double.pi, unit: .radians), options: [.flipOnVerticalAxis, .flipOnHorizontalAxis]) ?? self
		case .left:
			return self
		case .right:
			return rotated(by: Measurement(value: Double.pi / 2.0, unit: .radians), options: []) ?? self
		default:
			return self
		}
	}
	
	func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }
		
		let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
		let transform = CGAffineTransform(rotationAngle: rotationInRadians)
		let cgImageSize = CGSize(width: cgImage.width, height: cgImage.height)
		var rect = CGRect(origin: .zero, size: cgImageSize).applying(transform)
		rect.origin = .zero
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		
		let renderer = UIGraphicsImageRenderer(size: rect.size, format: format)
		
		let image = renderer.image { renderContext in
			renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
			renderContext.cgContext.rotate(by: rotationInRadians)
			
			let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
			let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
			renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
			
			let drawRect = CGRect(origin: CGPoint(x: -cgImageSize.width / 2.0, y: -cgImageSize.height / 2.0), size: cgImageSize)
			renderContext.cgContext.draw(cgImage, in: drawRect)
		}
		
		return image
	}
	
}
