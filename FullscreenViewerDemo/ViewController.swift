//
//  ViewController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit
import ViewableGroup

class ViewController: UIViewController, UIScrollViewDelegate {
	
	let viewables: [ViewGroupViewable] = [DemoViewableView(color: .blue), DemoFullscreenViewable(color: .purple), DemoWebViewable(), ImageViewable(image: UIImage(named: "DemoImage")!), DemoViewableView(color: .yellow)]
	
	lazy var viewGroup: ViewGroup<DemoViewGroupContainer> = .init(viewables: self.viewables)
	
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
	
	let tmp2 = UIImageView(frame: .zero)
	let tmp = UIScrollView(frame: .zero)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewGroup.viewableSpacing = 10
		
		self.addChildViewController(viewGroup)
		
		view.applyLayout(
			.horizontal(align: .center,
				.vertical(align: .center, size: .breadthEqualTo(ratio: 0.5),
					.sizedView(viewGroup.view, .breadthEqualTo(ratio: 1.0))
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
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return tmp2
	}

}

