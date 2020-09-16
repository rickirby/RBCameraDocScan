//
//  ViewController.swift
//  RBCameraDocScanExample
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class ViewController: UIViewController {

	@IBOutlet weak var resultImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func openCameraButtonTapped(_ sender: UIButton) {
		let vc = RBCameraViewController()
		vc.delegate = self
		vc.modalPresentationStyle = .fullScreen
		self.present(vc, animated: true, completion: nil)
	}
	
}

extension ViewController: RBCameraViewControllerDelegate {
	func gotCapturedPicture(image: UIImage, quad: Quadrilateral?) {
		resultImageView.image = image
	}
	
	func didTapCancel() {
		print("Tap Cancel")
	}
	
	func didTapImagePick() {
		print("Tap Image Pick")
	}
}

