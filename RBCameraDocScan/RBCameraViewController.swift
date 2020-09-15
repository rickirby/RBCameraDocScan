//
//  RBCameraViewController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import AVFoundation

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
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		screenView.onViewWillAppear()
		
		navigationController?.setNavigationBarHidden(true, animated: animated)
		navigationController?.setToolbarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		
		CaptureSession.current.isEditing = false
		captureSessionManager?.start()
		UIApplication.shared.isIdleTimerDisabled = true
		
		NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: Notification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
		if screenView.currentFlashState == .torch && device.torchMode == .off {
			CaptureSession.current.setFlash(into: .on)
		}
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
		captureSessionManager?.delegate = self
	}
	
	@objc func onDidBecomeActive() {
		guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
		if screenView.currentFlashState == .torch && device.torchMode == .off {
			CaptureSession.current.setFlash(into: .on)
		}
	}
	
	@objc private func subjectAreaDidChange() {
		do {
			try CaptureSession.current.resetFocusToAuto()
		} catch {
			let error = CameraScannerControllerError.inputDevice
			guard let captureSessionManager = captureSessionManager else { return }
			captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
			return
		}
		
		CaptureSession.current.removeFocusRectangleIfNeeded(screenView.focusRectangle, animated: true)
	}
}

extension RBCameraViewController: RectangleDetectionDelegateProtocol {
	func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
		
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
		
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
		
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {
		
	}
}
