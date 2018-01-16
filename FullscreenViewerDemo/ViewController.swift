//
//  ViewController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let viewables: [ViewerGroupViewable] = [DemoViewableView(color: .blue), DemoFullscreenViewable(), DemoViewableView(color: .green), DemoViewableView(color: .yellow)]
	
	lazy var viewerGroupController: ViewerGroupController<BasicViewGroupContainer> = .init(viewableGroup: self.viewables)
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	func commonInit() {
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.addChildViewController(viewerGroupController)
		
		view.applyLayout(
			.horizontal(align: .center,
				.vertical(align: .center, size: .breadthEqualTo(ratio: 0.5),
					.sizedView(viewerGroupController.view, .breadthEqualTo(ratio: 1.0))
				)
			)
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
//		present(viewerGroupController, animated: true) {
//
//		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

