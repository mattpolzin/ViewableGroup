//
//  ViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//

import UIKit

class BasicViewGroupContainer: UIView, ViewGroupContainer {
	
	let viewableContainer = UIView(frame: .zero)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	func commonInit() {
		layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		insetsLayoutMarginsFromSafeArea = true
		
		applyLayout(.horizontal(align: .fill, marginEdges: .allLayout, .view(viewableContainer)))
	}
}