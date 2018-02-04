//
//  FullscreenViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

public class FullscreenViewable: UIViewController, ViewGroupViewable, UIGestureRecognizerDelegate {
	
	public weak var delegate: ViewGroupViewableDelegate?
	
	public var active: Bool = false
	
	public var fullscreen: Bool = false
	
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
	
	@objc func userTapped() {
		
		guard allowsFullscreen else { return }
		
		if fullscreen {
			delegate?.requestUnfullscreen(for: self)
			return
		}
		
		delegate?.requestFullscreen(for: self)
	}
}
