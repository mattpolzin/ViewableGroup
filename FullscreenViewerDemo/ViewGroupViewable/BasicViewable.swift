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
class BasicViewable: UIView, ViewGroupViewable {
	
	var view: UIView! { return self }
	weak var delegate: ViewGroupViewableDelegate?
	
	var active: Bool = false
	var fullscreen: Bool = false
}
