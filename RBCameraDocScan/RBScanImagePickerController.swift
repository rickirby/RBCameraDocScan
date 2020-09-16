//
//  RBScanImagePickerController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 16/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

public class RBScanImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
	}
	
}
