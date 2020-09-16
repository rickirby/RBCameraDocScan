//
//  RBScanImagePickerController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 16/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public protocol RBScanImagePickerControllerDelegate {
	func gotPicture(image: UIImage, quad: Quadrilateral?)
}

public class RBScanImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	public var scanDelegate: RBScanImagePickerControllerDelegate?
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
	}
	
	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		
		DispatchQueue.global(qos: .userInitiated).async {
			guard let image = info[.originalImage] as? UIImage else { return }
			var detectedQuad: Quadrilateral?
			
			guard let ciImage = CIImage(image: image) else { return }
			let orientation = CGImagePropertyOrientation(image.imageOrientation)
			let orientedImage = ciImage.oriented(forExifOrientation: Int32(orientation.rawValue))
			if #available(iOS 11.0, *) {
				VisionRectangleDetector.rectangle(forImage: ciImage, orientation: orientation) { (quad) in
					detectedQuad = quad?.toCartesian(withHeight: orientedImage.extent.height)
					DispatchQueue.main.async {
						self.scanDelegate?.gotPicture(image: image, quad: detectedQuad)
					}
				}
			}
			else {
				detectedQuad = CIRectangleDetector.rectangle(forImage: ciImage)?.toCartesian(withHeight: orientedImage.extent.height)
				DispatchQueue.main.async {
					self.scanDelegate?.gotPicture(image: image, quad: detectedQuad)
				}
			}
		}
	}
}
