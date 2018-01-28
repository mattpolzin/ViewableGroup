//
//  ViewGroupViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

public protocol ViewGroupViewable: class {
	
	/// The Viewable must expose a view to be displayed in the view group.
	var view: UIView! { get }
	
	/// Set by the controller to allow the viewable
	/// to delegate to the controller.
	weak var delegate: ViewGroupViewableDelegate? { get set }
	
	/// True if the viewable is fullscreen
	var fullscreen: Bool { get set }
	
	/// True if the viewable has focus
	var active: Bool { get set }
}

public protocol ViewGroupViewableDelegate: class {
	func requestFullscreen(for viewable: ViewGroupViewable)
	
	func requestUnfullscreen(for viewable: ViewGroupViewable)
	
	var browsingEnabled: Bool { get set }
}
