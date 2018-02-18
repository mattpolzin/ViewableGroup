//
//  DemoWebViewable.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/18/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit
import ViewableGroup

class DemoWebViewable: ScrollingViewable {
	
	let webView = UIWebView()
	
	override func loadView() {
		view = webView
		
		configureView()
	}
	
	override func loadScrollView() {
		webView.scrollView.contentInsetAdjustmentBehavior = .never
		
		scrollView = webView.scrollView
		
		webView.loadRequest(URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Large_Scaled_Forest_Lizard.jpg")!))
		
		webView.scrollView.bounces = false
		webView.insetsLayoutMarginsFromSafeArea = false
		webView.clipsToBounds = true
	}
}
