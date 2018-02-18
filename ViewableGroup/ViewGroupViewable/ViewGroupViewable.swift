//
//  ViewGroupViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A Viewable's viewport is either `container`, meaning it is displayed
/// within the `ViewGroupContainer.viewableContainer`, or `fullscreen`,
/// meaning it is displayed over top of everything with the entire screen's
/// bounds.
public enum ViewableViewport {
	case fullscreen
	case container
}

/// A Viewable's positioning or "importance" indicates whether it is
/// `central` (i.e. the focal or relevant viewable) or `background`.
public enum ViewablePositioning {
	case central
	case background
}

/// A ViewGroupViewable is an object that can be viewed in a "view group."
public protocol ViewGroupViewable {
	/// The Viewable must expose a view to be displayed in the view group.
	/// This `UIView` should not be used by multiple viewables in the same view
	/// group.
	var view: UIView! { get }
	
	/// This will get called when the viewable is added to a group to give the
	/// viewable a delegate to the group.
	func controlled(by controller: ViewGroupController)
}
