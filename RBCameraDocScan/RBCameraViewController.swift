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
	
	// MARK: - Public Properties
	
	public var delegate: RBCameraViewControllerDelegate?
	
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	// MARK: - Private Properties
	
	private var screenView: RBCameraView {
		return view as! RBCameraView
	}
	
	private var captureSessionManager: CaptureSessionManager?
	
	// MARK: - Life Cycle
	
	public override func loadView() {
		super.loadView()
		view = RBCameraView()
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		modalPresentationStyle = .fullScreen
		configureViewEvent()
		configureCaptureSessionManager()
	}
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		screenView.onViewDidLayoutSubviews()
	}
	
	// MARK: - Private Methods
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (event: RBCameraView.ViewEvent) in
			switch event {
				
			case .capture:
				self?.captureSessionManager?.capturePhoto()
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
	
	private func configureCaptureSessionManager() {
		captureSessionManager = CaptureSessionManager(videoPreviewLayer: screenView.videoPreviewLayer)
//		captureSessionManager?.delegate = self
	}
}
