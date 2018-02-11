//
//  FullscreenViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

/// A FullscreenViewable is a UIViewController that supports taking itself into
/// and out of fullscreen when it is part of a viewable group.
/// It can be told to disallow the user entering/exiting fullscreen on tap by
/// setting `allowsFullscreen` to false.
public class FullscreenViewable: ControlledViewable, UIGestureRecognizerDelegate {
	
	/// Set to false to disallow entering/existing fullscreen by tapping on the
	/// view. Default is true.
	public var allowsFullscreen: Bool = true
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		
		commonInit()
	}
	
	override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		commonInit()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	private func commonInit() {
		let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTapped))
		tapRecognizer.delegate = self
		view.addGestureRecognizer(tapRecognizer)
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc private func userTapped() {
		
		guard allowsFullscreen else { return }
		
		if fullscreen {
			delegate?.request(viewport: .container, for: self)
			return
		}
		
		delegate?.request(viewport: .fullscreen, for: self)
	}
}
