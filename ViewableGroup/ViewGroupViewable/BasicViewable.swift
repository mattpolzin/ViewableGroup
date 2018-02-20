//
//  BasicViewable.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// A BasicViewable is just a UIView that conforms to ViewGroupViewable.
/// Depending on whether it seems helpful to ignore some of that conformance or
/// perhaps hurtful to hide it, this class may or may not be useful to you.
/// It does not get you anything by default, not even fullscreen support.
/// A BasicViewable can be viewed inline in a view group and that is it.
/// What you do get for free is a viewable that knows its own viewport and
/// whether it is active or not.
open class BasicViewable: UIView, ViewGroupViewable {
	
	public var view: UIView! { return self }
	weak public var delegate: ViewGroupController?
	
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
		
		controller.onViewportChange { [weak self] (viewable, viewport) in
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
