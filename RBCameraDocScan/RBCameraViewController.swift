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
	
	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.setNavigationBarHidden(false, animated: animated)
		UIApplication.shared.isIdleTimerDisabled = false
		captureSessionManager?.stop()
		
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - Private Methods
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (event: RBCameraView.ViewEvent) in
			switch event {
				
			case .capture:
				self?.captureSessionManager?.capturePhoto()
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

extension RBCameraViewController {
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard  let touch = touches.first else { return }
		let touchPoint = touch.location(in: screenView)
		
		if touchPoint.y > screenView.topMaskView.frame.height && touchPoint.y < screenView.bottomMaskView.frame.origin.y {
			let convertedTouchPoint: CGPoint = screenView.videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
			
			CaptureSession.current.removeFocusRectangleIfNeeded(screenView.focusRectangle, animated: false)
			
			screenView.focusRectangle = FocusRectangleView(touchPoint: touchPoint)
			screenView.addSubview(screenView.focusRectangle)
			
			do {
				try CaptureSession.current.setFocusPointToTapPoint(convertedTouchPoint)
			} catch {
				let error = CameraScannerControllerError.inputDevice
				guard let captureSessionManager = captureSessionManager else { return }
				captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
				return
			}
		}
	}
}

extension RBCameraViewController: RectangleDetectionDelegateProtocol {
	func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
		captureSessionManager.stop()
		screenView.captureButton.isUserInteractionEnabled = false
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
		guard let quad = quad else {
			screenView.quadView.removeQuadrilateral()
			return
		}
		let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
		let scaleTransform = CGAffineTransform.scaleTransform(forSize: portraitImageSize, aspectFillInSize: screenView.quadView.bounds.size)
		let scaledImageSize = imageSize.applying(scaleTransform)
		let rotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
		let imageBounds = CGRect(origin: .zero, size: scaledImageSize).applying(rotationTransform)
		let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: imageBounds, toCenterOfRect: screenView.quadView.bounds)
		let transforms = [scaleTransform, rotationTransform, translationTransform]
		let transformedQuad = quad.applyTransforms(transforms)
		screenView.quadView.drawQuadrilateral(quad: transformedQuad, animated: true)
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
		screenView.activityIndicator.stopAnimating()
		screenView.captureButton.isUserInteractionEnabled = true
		
		if screenView.currentFlashState == .on {
			CaptureSession.current.setFlash(into: .off)
		}
		
		delegate?.gotCapturedPicture(image: picture, quad: quad)
	}
	
	func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {
		screenView.activityIndicator.stopAnimating()
		screenView.captureButton.isUserInteractionEnabled = true
	}
}
