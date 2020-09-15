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
	
	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		screenView.onViewDidLayoutSubviews()
	}
}
