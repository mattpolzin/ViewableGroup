//
//  DemoViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//

import UIKit
import ViewableGroup

class DemoViewGroupContainer: BasicViewGroupContainer {
	
	override var margins: MarginEdges { return .allLayout }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	required init(with controller: ViewGroupController) {
		super.init(with: controller)
		
		commonInit()
	}
	
	func commonInit() {
		layoutMargins = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
		
		backgroundColor = .red
		viewableContainer.backgroundColor = .gray
	}
}
