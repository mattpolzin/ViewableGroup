//
//  ViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//

import UIKit

open class BasicViewGroupContainer: UIView, ViewGroupContainer {
	
	public let viewableContainer = UIView(frame: .zero)
	public var groupContainer: UIView { return self }
	
	open var margins: MarginEdges { return .none }
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	required public init(with controller: ViewGroupController) {
		super.init(frame: .zero)
		
		commonInit()
	}
	
	private func commonInit() {
		layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		insetsLayoutMarginsFromSafeArea = true
		
		applyLayout(.horizontal(align: .fill, marginEdges: margins, .view(viewableContainer)))
	}
}
