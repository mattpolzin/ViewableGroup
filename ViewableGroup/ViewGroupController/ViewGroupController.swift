//
//  ViewGroupController.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/17/18.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// The ViewGroupViewableDelegate allows a ViewGroupViewable to delegate
/// key operations to its group controller.
public protocol ViewGroupController: class {
	typealias ViewableIndex = Int
	
	/// - parameters:
	///		- viewable: The viewable that changed viewports.
	///		- viewport: The viewable's new viewport.
	typealias ViewportChangeHandler = (_ viewable: ViewGroupViewable, _ viewport: ViewableViewport) -> Void
	
	///	- parameters:
	///		- viewable: The viewable that is now `ViewablePositioning.central`
	/// 	- index: The index of the viewable that is now `.central`
	typealias BrowseHandler = (_ viewable: ViewGroupViewable, _ index: ViewableIndex) -> Void
	
	/// Call to request a particular viewable goes fullscreen. Note that
	/// a viewable cannot be in `ViewablePositioning.background` when it is
	/// fullscreen, so requesting fullscreen also will result in becoming
	/// `central`.
	func request(viewport: ViewableViewport, for viewable: ViewGroupViewable)
	
	/// Set this to enable or disable browsing of the viewable group by the user.
	var browsingEnabled: Bool { get set }
	
	/// The number of viewables in this controller's group.
	var count: Int { get }
	
	/// Set a callback for when any viewable in the view group changes its
	/// viewport.
	///
	/// - parameters:
	///		- callback: A function called when a viewable's viewport changes.
	func onViewportChange(_ callback: @escaping ViewportChangeHandler)
	
	/// Set a callback for when the "Central" viewable changes.
	///
	/// - SeeAlso: ViewablePositioning
	///
	/// - parameters:
	///		- callback: A function to be called when the current viewable changes.
	func onBrowse(_ callback: @escaping BrowseHandler)
}
