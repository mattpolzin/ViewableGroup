//
//  DemoFullscreenViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/13/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

class DemoFullscreenViewableView: DemoViewableView {
	
}

class DemoFullscreenViewable: UIViewController, ViewerGroupViewable {
	
	weak var delegate: ViewerGroupViewableDelegate?
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		commonInit()
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	func commonInit() {
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped))
		view.addGestureRecognizer(tapRecognizer)
	}
	
	override func loadView() {
		view = DemoFullscreenViewableView(color: .purple)
	}
	
	@objc func userTapped() {
		
		if view.superview == UIApplication.shared.keyWindow! {
			delegate?.requestMinimize(for: self)
			return
		}
		
		delegate?.requestFullscreen(for: self)
	}
}
