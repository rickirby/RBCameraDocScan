//
//  RBCameraView.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import AVFoundation

class RBCameraView: UIView {
	
	enum ViewEvent {
		case didTapCapture
		case didTapCancel
		case didTapImagePick
		case didTapFlash
		case didTapAutomatic
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	let videoPreviewLayer = AVCaptureVideoPreviewLayer()
	var focusRectangle: FocusRectangleView!
	
	var previewView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .gray
		
		return view
	}()
	
	var quadView: QuadrilateralView = {
		let view = QuadrilateralView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.editable = false
		
		return view
	}()
	
	lazy var topMaskView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .black
		
		return view
	}()
	
	lazy var bottomMaskView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .black
		
		return view
	}()
	
	lazy var flashView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .black
		view.isHidden = true
		view.alpha = 0
		
		return view
	}()
	
	lazy var captureButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "CaptureButton"), for: .normal)
		button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "CancelButton"), for: .normal)
		button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	lazy var imagePickButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "ImagePickButton"), for: .normal)
		button.addTarget(self, action: #selector(imagePickButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	lazy var flashButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "FlashOffButton"), for: .normal)
		button.imageView?.contentMode = .scaleAspectFit
		button.addTarget(self, action: #selector(flashButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	lazy var automaticButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setImage(UIImage(named: "AutomaticButton")?.withRenderingMode(.alwaysTemplate), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(automaticButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	lazy var currentFlashView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 10/255, alpha: 1)
		view.isHidden = true
		view.layer.masksToBounds = true
		view.layer.cornerRadius = CGFloat(3).makeDynamicW()
		
		return view
	}()
	
	lazy var currentAutomaticView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = UIColor(red: 255/255, green: 214/255, blue: 10/255, alpha: 1)
		view.isHidden = true
		view.layer.masksToBounds = true
		view.layer.cornerRadius = CGFloat(3).makeDynamicW()
		
		return view
	}()
	
	lazy var currentFlashImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "FlashOnButton")?.withRenderingMode(.alwaysTemplate)
		imageView.tintColor = .black
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var currentAutomaticLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textColor = .black
		label.font = .preferredFont(forTextStyle: .caption1)
		label.text = "AUTOMATIC MODE"
		
		return label
	}()
	
	lazy var hStack: HStack = {
		let stack = HStack()
		stack.spacing = CGFloat(10).makeDynamicW()
		stack.distribution = .equalCentering
		
		return stack
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.color = .white
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setViews() {
		previewView.layer.addSublayer(videoPreviewLayer)
		
		addAllSubviews(views: [topMaskView, bottomMaskView, previewView, quadView, flashView, captureButton, cancelButton, imagePickButton, flashButton, automaticButton, hStack, activityIndicator])
		currentFlashView.addSubview(currentFlashImageView)
		currentAutomaticView.addSubview(currentAutomaticLabel)
		hStack.makeHStack([currentFlashView, currentAutomaticView])
		
		NSLayoutConstraint.activate([
			topMaskView.topAnchor.constraint(equalTo: self.topAnchor),
			topMaskView.leftAnchor.constraint(equalTo: self.leftAnchor),
			topMaskView.rightAnchor.constraint(equalTo: self.rightAnchor),
			topMaskView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: CGFloat(68).makeDynamicH()),
			
			bottomMaskView.leftAnchor.constraint(equalTo: self.leftAnchor),
			bottomMaskView.rightAnchor.constraint(equalTo: self.rightAnchor),
			bottomMaskView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			bottomMaskView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: CGFloat(-135).makeDynamicH()),
			
			previewView.topAnchor.constraint(equalTo: topMaskView.bottomAnchor),
			previewView.leftAnchor.constraint(equalTo: self.leftAnchor),
			previewView.rightAnchor.constraint(equalTo: self.rightAnchor),
			previewView.bottomAnchor.constraint(equalTo: bottomMaskView.topAnchor),
			
			quadView.topAnchor.constraint(equalTo: previewView.topAnchor),
			quadView.leftAnchor.constraint(equalTo: previewView.leftAnchor),
			quadView.rightAnchor.constraint(equalTo: previewView.rightAnchor),
			quadView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor),
			
			flashView.topAnchor.constraint(equalTo: self.topAnchor),
			flashView.leftAnchor.constraint(equalTo: self.leftAnchor),
			flashView.rightAnchor.constraint(equalTo: self.rightAnchor),
			flashView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			captureButton.centerXAnchor.constraint(equalTo: bottomMaskView.centerXAnchor),
			captureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: CGFloat(-40).makeDynamicH()),
			captureButton.widthAnchor.constraint(equalToConstant: CGFloat(72).makeDynamicW()),
			captureButton.heightAnchor.constraint(equalToConstant: CGFloat(72).makeDynamicW()),
			
			cancelButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
			cancelButton.leftAnchor.constraint(equalTo: bottomMaskView.leftAnchor, constant: CGFloat(55).makeDynamicW()),
			cancelButton.widthAnchor.constraint(equalToConstant: CGFloat(21).makeDynamicW()),
			cancelButton.heightAnchor.constraint(equalToConstant: CGFloat(21).makeDynamicW()),
			
			imagePickButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
			imagePickButton.rightAnchor.constraint(equalTo: bottomMaskView.rightAnchor, constant: CGFloat(-52).makeDynamicW()),
			imagePickButton.widthAnchor.constraint(equalToConstant: CGFloat(34).makeDynamicW()),
			imagePickButton.heightAnchor.constraint(equalToConstant: CGFloat(29).makeDynamicW()),
			
			flashButton.centerYAnchor.constraint(equalTo: topMaskView.centerYAnchor),
			flashButton.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
			flashButton.widthAnchor.constraint(equalToConstant: CGFloat(16).makeDynamicW()),
			flashButton.heightAnchor.constraint(equalToConstant: CGFloat(20).makeDynamicW()),
			
			automaticButton.centerYAnchor.constraint(equalTo: topMaskView.centerYAnchor),
			automaticButton.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
			automaticButton.widthAnchor.constraint(equalToConstant: CGFloat(18).makeDynamicW()),
			automaticButton.heightAnchor.constraint(equalToConstant: CGFloat(21.75).makeDynamicW()),
			
			currentAutomaticLabel.leftAnchor.constraint(equalTo: currentAutomaticView.leftAnchor, constant: 10),
			currentAutomaticView.rightAnchor.constraint(equalTo: currentAutomaticLabel.rightAnchor, constant: 10),
			currentAutomaticLabel.topAnchor.constraint(equalTo: currentAutomaticView.topAnchor, constant: 3),
			currentAutomaticLabel.bottomAnchor.constraint(equalTo: currentAutomaticView.bottomAnchor, constant: -3),
			
			currentFlashView.heightAnchor.constraint(equalTo: currentAutomaticView.heightAnchor),
			
			currentFlashImageView.topAnchor.constraint(equalTo: currentFlashView.topAnchor, constant: CGFloat(5).makeDynamicH()),
			currentFlashImageView.bottomAnchor.constraint(equalTo: currentFlashView.bottomAnchor, constant: CGFloat(-5).makeDynamicH()),
			currentFlashImageView.leftAnchor.constraint(equalTo: currentFlashView.leftAnchor, constant: CGFloat(10).makeDynamicW()),
			currentFlashImageView.rightAnchor.constraint(equalTo: currentFlashView.rightAnchor, constant: CGFloat(-10).makeDynamicW()),
			currentFlashImageView.widthAnchor.constraint(equalToConstant: 35),
			
			hStack.centerXAnchor.constraint(equalTo: topMaskView.centerXAnchor),
			hStack.bottomAnchor.constraint(equalTo: topMaskView.bottomAnchor, constant: CGFloat(-12).makeDynamicW()),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
	
	func onViewDidLayoutSubviews() {
		videoPreviewLayer.frame = previewView.layer.bounds
	}
}

extension RBCameraView {
	@objc func captureButtonTapped() {
		onViewEvent?(.didTapCapture)
	}
	
	@objc func cancelButtonTapped() {
		onViewEvent?(.didTapCancel)
	}
	
	@objc func imagePickButtonTapped() {
		onViewEvent?(.didTapImagePick)
	}
	
	@objc func flashButtonTapped() {
		onViewEvent?(.didTapFlash)
	}
	
	@objc func automaticButtonTapped() {
		onViewEvent?(.didTapAutomatic)
	}
}
