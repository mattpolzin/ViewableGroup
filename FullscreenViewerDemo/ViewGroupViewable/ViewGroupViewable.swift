//
//  ViewGroupViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A ViewGroupViewable is an object that can be viewed in a "view group."
public protocol ViewGroupViewable: class {
	
	/// The Viewable must expose a view to be displayed in the view group.
	var view: UIView! { get }
	
	/// Allows the viewable to delegate to the group controller.
	/// You do not need to set this property, it will get
	/// set by the group controller that the viewable gets added to.
	weak var delegate: ViewGroupViewableDelegate? { get set }
	
	/// True if the viewable is fullscreen
	var fullscreen: Bool { get set }
	
	/// True if the viewable has focus
	var active: Bool { get set }
}

/// The ViewGroupViewableDelegate allows a ViewGroupViewable to delegate
/// key operations to its group controller.
public protocol ViewGroupViewableDelegate: class {
	
	func requestFullscreen(for viewable: ViewGroupViewable)
	
	func requestUnfullscreen(for viewable: ViewGroupViewable)
	
	var browsingEnabled: Bool { get set }
}
