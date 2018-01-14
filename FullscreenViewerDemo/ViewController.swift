//
//  ViewController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let viewables: [ViewerGroupViewable] = [DemoViewableView(color: .blue), DemoViewableView(color: .green), DemoViewableView(color: .yellow)]
	
	lazy var viewerGroupController: ViewerGroupController<BasicViewGroupContainer> = .init(viewableGroup: self.viewables)
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		present(viewerGroupController, animated: true) {
			
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

