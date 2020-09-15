//
//  CameraScannerScan.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public struct CameraScannerScan {
	public enum CameraScannerError: Error {
		case failedToGeneratePDF
	}
	
	public var image: UIImage
	
	public func generatePDFData(completion: @escaping (Result<Data, CameraScannerError>) -> Void) {
		DispatchQueue.global(qos: .userInteractive).async {
			if let pdfData = self.image.pdfData() {
				completion(.success(pdfData))
			} else {
				completion(.failure(.failedToGeneratePDF))
			}
		}
	}
	
	mutating func rotate(by rotationAngle: Measurement<UnitAngle>) {
		guard rotationAngle.value != 0, rotationAngle.value != 360 else { return }
		image = image.rotated(by: rotationAngle) ?? image
	}
}
