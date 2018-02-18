//
//  ViewGroupController.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/17/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// The ViewGroupViewableDelegate allows a ViewGroupViewable to delegate
/// key operations to its group controller.
public protocol ViewGroupController: class {
	
	/// Call to request a particular viewable goes fullscreen. Note that
	/// a viewable cannot be in `ViewablePositioning.background` when it is
	/// fullscreen, so requesting fullscreen also will result in becoming
	/// `central`.
	func request(viewport: ViewableViewport, for viewable: ViewGroupViewable)
	
	/// Set this to enable or disable browsing of the viewable group by the user.
	var browsingEnabled: Bool { get set }
}
