//
//  DemoWebViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/18/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

class DemoWebViewableView: DemoFullscreenViewableView {
	
	var webView: UIWebView!
	
	override init(color: UIColor) {
		super.init(color: color)
		
		webView = UIWebView()
		self.applyLayout(.horizontal(align: .fill, .view(webView)))
		
		webView.loadRequest(URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Large_Scaled_Forest_Lizard.jpg")!))
		
		webView.scrollView.bounces = false
		clipsToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}

class DemoWebViewable: DemoFullscreenViewable, UIScrollViewDelegate {
	
	lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userPanned(_:)))
	
	let webViewable = DemoWebViewableView(color: .white)
	
	var scrolling: Bool = false
	
	init() {
		super.init(color: .black)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func loadView() {
		view = webViewable
		webViewable.webView.scrollView.delegate = self
		panGestureRecognizer.delegate = self
		view.addGestureRecognizer(panGestureRecognizer)
	}
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc func userPanned(_ sender: UIPanGestureRecognizer) {
		
		let velocity = sender.velocity(in: view)
		
		let scrollView = webViewable.webView.scrollView
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
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if active {
			delegate?.browsingEnabled = true
		}
	}
	
	func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
		scrolling = false
		if active {
			delegate?.browsingEnabled = true
		}
	}
}
