//
//  ViewController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let viewables: [ViewGroupViewable] = [DemoViewableView(color: .blue), DemoFullscreenViewable(color: .purple), DemoWebViewable(), DemoViewableView(color: .green), DemoViewableView(color: .yellow)]
	
	lazy var viewGroupController: ViewGroupController<DemoViewGroupContainer> = .init(viewableGroup: self.viewables)
	
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
		
		viewGroupController.viewableSpacing = 10
		
		self.addChildViewController(viewGroupController)
		
		view.applyLayout(
			.horizontal(align: .center,
				.vertical(align: .center, size: .breadthEqualTo(ratio: 0.5),
					.sizedView(viewGroupController.view, .breadthEqualTo(ratio: 1.0))
				)
			)
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

