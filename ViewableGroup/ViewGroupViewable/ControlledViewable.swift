//
//  ControlledViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A ControlledViewable is a UIViewController viewable that has no special features built
/// in. It does not even know how to enter/exist fullscreen. It can be viewed
/// inline in a view group and that is it.
open class ControlledViewable: UIViewController, ViewGroupViewable {
	
	public weak var delegate: ViewGroupController?
	
	public var active: Bool = false
	
	public var fullscreen: Bool = false
	
	public func controllerAvailable(_ delegate: ViewGroupController) {
		self.delegate = delegate
	}
	
	public func moved(to viewport: ViewableViewport) {
		switch viewport {
		case .fullscreen:
			fullscreen = true
		case .container:
			fullscreen = false
		}
	}
	
	public func positioning(is positioning: ViewablePositioning) {
		switch positioning {
		case .background:
			active = false
		case .central:
			active = true
		}
	}
}
