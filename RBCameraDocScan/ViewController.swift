//
//  ViewController.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ViewController<V: View>: UIViewController {
	
	var screenView: V {
		return view as! V
	}
	
	override func loadView() {
		view = V()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		screenView.onViewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		screenView.onViewWillAppear()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		screenView.onViewDidAppear()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		screenView.onViewWillDisappear()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		screenView.onViewDidDisappear()
	}
	
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		screenView.onViewWillLayoutSubviews()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		screenView.onViewDidLayoutSubviews()
	}
	
}
