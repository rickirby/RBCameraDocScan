//
//  RBCameraViewController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public class RBCameraViewController: UIViewController {
	
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
				print("Tap Cancel")
			case .didTapImagePick:
				print("Tap Image Pick")
			case .setFlash(let state):
				CaptureSession.current.setFlash(into: state)
			case .toggleAutomatic:
				CaptureSession.current.isAutoScanEnabled.toggle()
			}
		}
	}
}
