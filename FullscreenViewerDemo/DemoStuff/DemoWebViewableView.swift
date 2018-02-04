//
//  DemoWebViewableView.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 1/18/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import UIKit

class DemoWebViewable: ScrollingViewable {
	
	let webView = UIWebView()
	
	override func loadScrollView() {
		scrollView = webView.scrollView
		
		view.applyLayout(.horizontal(align: .fill, .view(webView)))
		
		webView.loadRequest(URLRequest(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Large_Scaled_Forest_Lizard.jpg")!))
		
		webView.scrollView.bounces = false
		view.clipsToBounds = true
	}
}
