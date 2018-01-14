//
//  ViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//

import UIKit

class BasicViewGroupContainer: UIView, ViewerGroupContainer {
	
	let viewableContainerView = UIView(frame: .zero)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	func commonInit() {
		layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
		insetsLayoutMarginsFromSafeArea = true
		
		applyLayout(.horizontal(align: .fill, marginEdges: .allLayout, .view(viewableContainerView)))
		
		backgroundColor = .red
		
		viewableContainerView.backgroundColor = .gray
	}
}
