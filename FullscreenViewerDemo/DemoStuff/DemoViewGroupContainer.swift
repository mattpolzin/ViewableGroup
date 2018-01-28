//
//  DemoViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//

import UIKit

class DemoViewGroupContainer: BasicViewGroupContainer {
	
	override func commonInit() {
		super.commonInit()
		layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
		insetsLayoutMarginsFromSafeArea = true
		
		backgroundColor = .red
		viewableContainer.backgroundColor = .gray
	}
}
