//
//  ViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A container for the entire group of viewables. Types of this protocol are responsible
/// for the appearance of the container where the current viewable is displayed.
///
/// The goal is to leave the layout within its superview and the appearance of the
/// "viewing window" (viewableContainer) to the ViewGroupContainer while the
/// ViewGroupController displays one viewable at a time within the viewableContainer.
///
/// |-------------| <- groupContainer (UIVIew).
/// |    |==|     | <- viewableContainer (UIView) constrained within groupContainer.
/// |-------------|
///
public protocol ViewGroupContainer {
	/// The view that viewables should get displayed within. The `.central` viewable
	/// will take up the entire `viewableContainer` and the `.background` viewabels
	/// will be layed out to the right and left of the `viewableContainer`.
	var viewableContainer: UIView { get }
	
	/// A view that contains the viewableContainer. It is required that viewableContainer
	/// be a subview of groupContainer, but you can make viewableContainer fill
	/// groupContainer if you wish. This view hierarchy allows you to define the
	/// negative space around the viewableContainer and control the appearance of
	/// those margins.
	var groupContainer: UIView { get }
	
	/// Create an instance of this container type with the given controller
	/// as its owner/delegate.
	init(with controller: ViewGroupController)
}
