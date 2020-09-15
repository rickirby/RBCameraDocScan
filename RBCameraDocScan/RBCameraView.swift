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
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
