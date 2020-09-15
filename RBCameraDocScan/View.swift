//
//  View.swift
//  RBCameraDocScan
//
//  Created by Ricki Private on 15/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class View: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setViews() {} // Run on loadView()
	func onViewDidLoad() {}
	func onViewWillAppear() {}
	func onViewDidAppear() {}
	func onViewWillDisappear() {}
	func onViewDidDisappear() {}
	func onViewWillLayoutSubviews() {}
	func onViewDidLayoutSubviews() {}
}
