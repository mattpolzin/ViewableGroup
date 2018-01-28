//
//  EmptyViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/28/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

public class EmptyViewable: UIView, ViewGroupViewable {
	public var view: UIView! { return self }
	public weak var delegate: ViewGroupViewableDelegate?
	public var active: Bool = false
	public var fullscreen: Bool = false
}
