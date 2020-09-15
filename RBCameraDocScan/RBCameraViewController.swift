//
//  RBCameraViewController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public protocol RBCameraViewControllerDelegate {
	func gotCapturedPicture(image: UIImage, quad: Quadrilateral?)
	func didTapCancel()
	func didTapImagePick()
}

public class RBCameraViewController: UIViewController {
	
	public var delegate: RBCameraViewControllerDelegate?
	
	var screenView: RBCameraView {
		return view as! RBCameraView
	}
	
	public override func loadView() {
		super.loadView()
		view = RBCameraView()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		screenView.onViewDidLayoutSubviews()
	}
	
	func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (event: RBCameraView.ViewEvent) in
			switch event {
				
			case .capture:
//				self.captureSessionManager?.capturePhoto()
				print("Tap Capture")
			case .didTapCancel:
				self?.delegate?.didTapCancel()
			case .didTapImagePick:
				self?.delegate?.didTapImagePick()
			case .setFlash(let state):
				CaptureSession.current.setFlash(into: state)
			case .toggleAutomatic:
				CaptureSession.current.isAutoScanEnabled.toggle()
			}
		}
	}
}
