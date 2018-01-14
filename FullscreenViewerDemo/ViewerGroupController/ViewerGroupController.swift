//
//  File.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

protocol ViewerGroupContainer {
	var viewableContainerView: UIView { get }
}

protocol ViewerGroupViewable {
	var view: UIView { get }
}

class EmptyViewable: UIView, ViewerGroupViewable {
	var view: UIView { return self }
}

class ViewerGroupController<ContainerViewType: UIView>: UIViewController, UIGestureRecognizerDelegate where ContainerViewType: ViewerGroupContainer {
	
	let containerView = ContainerViewType()
	
	let viewableGroup: [ViewerGroupViewable]
	
	var currentViewIndex: Int?
	
	init(viewableGroup: [ViewerGroupViewable]) {
		self.viewableGroup = viewableGroup
		
		super.init(nibName: nil, bundle: nil)
	}
	
	func commonInit() {
		
	}
	
	override func viewDidLoad() {
		
		guard viewableGroup.count > 0 else {
			return
		}
		
		let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedLeft(_:)))
		leftSwipeRecognizer.direction = .left
		leftSwipeRecognizer.delegate = self
		view.addGestureRecognizer(leftSwipeRecognizer)
		let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedRight(_:)))
		rightSwipeRecognizer.direction = .right
		rightSwipeRecognizer.delegate = self
		view.addGestureRecognizer(rightSwipeRecognizer)
		
		showViewable(at: 0)
	}
	
	override func loadView() {
		view = containerView
	}
	
	private func showViewable(at viewableIndex: Int) {
		guard viewableGroup.count > viewableIndex,
			viewableIndex >= 0 else { return }
		
		layout(index: viewableIndex)
		
		currentViewIndex = viewableIndex
	}
	
	private func layout(index: Int) {
		guard viewableGroup.count > index,
			index >= 0 else { return }
		
		let viewables = [index - 2, index - 1, index, index + 1, index + 2].map(viewable(at:))
		
		guard let leftView: LayoutEntity = viewables.first.map({ .sizedView($0.view, .lengthEqualTo(ratio: 1 / CGFloat(viewables.count))) }) else { return }
		
		let otherViews: [(independent: LayoutEntity, same: LayoutEntity)] = viewables.dropFirst().map { (independent: .space(0), same: .view($0.view)) }
		
		let layout: Layout = .vertical(align: .center, marginEdges: .none,
			.horizontal(align: .fill, size: .breadthEqualTo(ratio: CGFloat(viewables.count)),
						.matched(leftView, otherViews, priority: .required)
				)
		)
		
		UIView.animate(withDuration: 0.3) {
			self.containerView.viewableContainerView.applyLayout(layout)
			self.containerView.viewableContainerView.layoutIfNeeded()
		}
	}
	
	private func viewable(at index: Int) -> ViewerGroupViewable {
		guard viewableGroup.count > index,
			index >= 0 else { return EmptyViewable() }
		
		return viewableGroup[index]
	}
	
	// MARK: - Gestures
	
	@objc func userSwipedLeft(_ sender: UIGestureRecognizer) {
		guard let currentIndex = currentViewIndex else { return }
		showViewable(at: currentIndex + 1)
	}
	
	@objc func userSwipedRight(_ sender: UIGestureRecognizer) {
		guard let currentIndex = currentViewIndex else { return }
		showViewable(at: currentIndex - 1)
	}
	
	// MARK: - NSCodable
	
	required init?(coder aDecoder: NSCoder) {
		viewableGroup = aDecoder.decodeObject(forKey: viewableGroupKey) as! [ViewerGroupViewable]
		
		super.init(coder: aDecoder)
	}
	
	override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		
		aCoder.encode(viewableGroup, forKey: viewableGroupKey)
	}
	
	private let viewableGroupKey = "viewable_group"
}
