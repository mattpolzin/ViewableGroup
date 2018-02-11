//
//  ViewGroupContainer.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A container for the entire group of viewables. Types of this protocol are responsible
/// for the appearance of the container where the current viewable is displayed. In
/// practice, ViewerGroupController also requires its ViewerGroupContainer to be
/// a UIView itself and to have its viewable container set up within its bounds.
///
/// The goal is to leave the layout within its superview and the appearance of the
/// "viewing window" (viewableContainer) to the coder while the
/// ViewerGroupController displays one viewable at a time within the viewableContainer.
///
/// |-------------| <- Viewer group container (UIVIew).
/// |    |==|     | <- viewable container (UIView) constrained within groupe container.
/// |-------------|
///
public protocol ViewGroupContainer {
	var viewableContainer: UIView { get }
}
