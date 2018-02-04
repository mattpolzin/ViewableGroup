//
//  DemoFullscreenViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/13/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

class DemoFullscreenViewableView: DemoViewableView { }

class DemoFullscreenViewable: FullscreenViewable {
	
	let backgroundColor: UIColor
	
	init(color: UIColor) {
		backgroundColor = color
		super.init(nibName: nil, bundle: nil)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		backgroundColor = .purple
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	override func loadView() {
		view = DemoFullscreenViewableView(color: backgroundColor)
	}
}
