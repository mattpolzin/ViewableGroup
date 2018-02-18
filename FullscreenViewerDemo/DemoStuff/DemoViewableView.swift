//
//  DemoViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit
import ViewableGroup

class DemoViewableView: BasicViewable {
	
	init(color: UIColor) {
		super.init(frame: .zero)
		
		backgroundColor = color
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .blue
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
				return "\(String(describing: backgroundColor))"
			}
		}()
		return "\(colorName) DemoViewController [\(super.description)]"
	}
}
