//
//  ControlledViewable.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// A ControlledViewable is a UIViewController viewable that has no special features built
/// in. It does not even know how to enter/exist fullscreen. It can be viewed
/// inline in a view group and that is it.
/// What it does get you for free, is a viewable that knows what viewort it is
/// in and whether it is active or not.
open class ControlledViewable: UIViewController, ViewGroupViewable {
	
	public weak var delegate: ViewGroupController?
	
	/// Set by methods listening to the controller so that this variable always
	/// accurately represents whether the viewable is active (i.e. `.central`)
	/// or not (i.e. `.background`).
	open var active: Bool = false
	
	/// Set by methods listening to the controller so that this variable always
	/// accurately represents whether the viewable is fullscreen or not.
	open var fullscreen: Bool = false
	
	public func controlled(by controller: ViewGroupController) {
		self.delegate = controller
		
		controller.onBrowse { [weak self] (viewable, index) in
			guard let strongSelf = self else { return }
			
			strongSelf.positioning(is: viewable.view == strongSelf.view ? .central : .background)
		}
		
		controller.onViewportChanged { [weak self] (viewable, viewport, _) in
			guard let strongSelf = self, viewable.view == strongSelf.view else { return }
			
			strongSelf.moved(to: viewport)
		}
	}
	
	private func moved(to viewport: ViewableViewport) {
		switch viewport {
		case .fullscreen:
			fullscreen = true
		case .container:
			fullscreen = false
		}
	}
	
	private func positioning(is positioning: ViewablePositioning) {
		switch positioning {
		case .background:
			active = false
		case .central:
			active = true
		}
	}
}
