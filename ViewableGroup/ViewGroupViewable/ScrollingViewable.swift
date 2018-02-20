//
//  ScrollingViewable.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// A ScrollingViewable supports content larger than the viewable container.
/// By default, a ScrollingViewable will also allow the user to enter/exit
/// fullscreen to get a larger view of its content. Fullscreen can be disallowed
/// by setting `allowsFullscreen` to false.
open class ScrollingViewable: FullscreenViewable, UIScrollViewDelegate {
	
	private var _scrollView: UIScrollView?
	
	/// The scroll view you should add your viewable content to.
	/// Subclasses can override loadScrollView() to provide a non-default
	/// scroll view.
	public var scrollView: UIScrollView! {
		get {
			if _scrollView == nil {
				loadScrollView()
			}
			return _scrollView
		}
		set(view) {
			if let oldScrollView =  _scrollView {
				oldScrollView.removeFromSuperview()
			}
			
			_scrollView = view
			
			setupScrollView()
		}
	}
	
	private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userPanned(_:)))
	
	private var scrolling: Bool = false
	
	/// Creates a UIVIew and stores in the `view` property of the View Controller.
	/// If you subclass `ScrollingViewable`
	/// and you override `loadView()` then you should first set the `view` property
	/// and then call `super.configureView()` to let the `ScrollingViewable` set up
	/// its gesture recognizers on your custom view.
	override open func loadView() {
		view = UIView()
		
		configureView()
	}
	
	/// This should be called by any subclass implementation of `loadView()` in
	/// order to set up the gesture recognizers required for the `ScrollingViewable`
	/// to function.
	public func configureView() {
		panGestureRecognizer.delegate = self
		view.addGestureRecognizer(panGestureRecognizer)
		
		setupScrollView()
	}
	
	private func setupScrollView() {
		scrollView.delegate = self
	}
	
	/// Loads the scroll view for this viewable. Do not call this method directly.
	/// Override this method to provide a non-default scroll view in a subclass.
	/// You can also override this method to perform logic immediately after
	/// calling `super.loadScrollView()` in much the same way as you would with
	/// `loadView()` to perform some actions immediatley after the view and
	/// scroll view have been set up.
	open func loadScrollView() {
		scrollView = UIScrollView()
		view.applyLayout(.horizontal(align: .fill, .view(scrollView)))
	}
	
	@objc private func userPanned(_ sender: UIPanGestureRecognizer) {
		// TODO: logic appears to be wrong here when zoomed in -- can't swipe right
		// to advance but can swipe left to go back, which makes sense because origin
		// is always (0,0).
		let velocity = sender.velocity(in: view)
		
		let viewSize = scrollView.frame
		let scrollPos = scrollView.contentOffset
		let contentSize = scrollView.contentSize
		
		let atMin = (x: scrollPos.x == 0, y: scrollPos.y == 0)
		let atMax = (x: scrollPos.x + viewSize.width == contentSize.width,
					 y: scrollPos.y + viewSize.height == contentSize.height)
		
		let isNeutral = (x: velocity.x == 0 ||
			(velocity.x <= 75 && abs(velocity.y) > abs(velocity.x)) ||
			(atMin.x && velocity.x > 0) ||
			(atMax.x && velocity.x < 0),
						 y: velocity.y == 0 ||
							(velocity.y <= 75 && abs(velocity.x) > abs(velocity.y)) ||
							(atMin.y && velocity.y > 0) ||
							(atMax.y && velocity.y < 0))
		
		scrolling = !(isNeutral.x && isNeutral.y)
		
		if active {
			delegate?.browsingEnabled = !scrolling
		}
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if active {
			delegate?.browsingEnabled = true
		}
	}
	
	public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		scrolling = false
		if active {
			delegate?.browsingEnabled = true
		}
	}
}
