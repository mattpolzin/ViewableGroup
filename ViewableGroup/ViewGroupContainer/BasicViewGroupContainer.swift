//
//  ViewGroupContainer.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// A UIView that is set up to be a view group container. It has
/// one subview (the `viewableContainer`) that is lays out to
/// fill itself up to its layout margins.
/// If all you want is a ViewGroupContainer with margins or possibly
/// no insets at all, this will work just fine as-is.
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
