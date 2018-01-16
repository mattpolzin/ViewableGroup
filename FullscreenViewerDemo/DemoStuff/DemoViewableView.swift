//
//  DemoViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

class DemoViewableView: UIView, ViewerGroupViewable {
	
	var view: UIView! { return self }
	weak var delegate: ViewerGroupViewableDelegate?
	
	init(color: UIColor) {
		super.init(frame: .zero)
		
		backgroundColor = color
		
		commonInit()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .blue
		
		commonInit()
	}
	
	func commonInit() {
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}

extension DemoViewableView {
	override var description: String {
		let colorName: String = {
			switch backgroundColor {
			case .blue?:
				return "blue"
			case .red?:
				return "red"
			case .yellow?:
				return "yellow"
			case .green?:
				return "green"
				
			default:
				return "\(backgroundColor)"
			}
		}()
		return "\(colorName) DemoViewController [\(super.description)]"
	}
}
