//
//  BasicViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A BasicViewable is just a UIView that conforms to ViewGroupViewable.
/// Depending on whether it seems helpful to ignore some of that conformance or
/// perhaps hurtful to hide it, this class may or may not be useful to you.
/// It does not get you anything by default, not even fullscreen support.
/// A BasicViewable can be viewed inline in a view group and that is it.
open class BasicViewable: UIView, ViewGroupViewable {
	
	public var view: UIView! { return self }
	weak public var delegate: ViewGroupViewableDelegate?
	
	public var active: Bool = false
	public var fullscreen: Bool = false
	
	public func delegateAvailable(_ delegate: ViewGroupViewableDelegate) {
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
