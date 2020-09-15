//
//  RectangleDetectionDelegateProtocol.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 13/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

protocol RectangleDetectionDelegateProtocol: NSObjectProtocol {
	
	func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager)
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize)
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?)
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error)
}
