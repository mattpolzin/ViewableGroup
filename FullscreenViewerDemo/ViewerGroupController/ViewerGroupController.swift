//
//  File.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

public protocol ViewerGroupContainer {
	var viewableContainer: UIView { get }
}

public protocol ViewerGroupViewable: class {
	var view: UIView! { get }
	
	weak var delegate: ViewerGroupViewableDelegate? { get set }
}

public protocol ViewerGroupViewableDelegate: class {
	func requestFullscreen(for viewable: ViewerGroupViewable)
	
	func requestMinimize(for viewable: ViewerGroupViewable)
}

public class EmptyViewable: UIView, ViewerGroupViewable {
	public var view: UIView! { return self }
	public weak var delegate: ViewerGroupViewableDelegate?
}

public class ViewerGroupController<ContainerViewType: UIView>: UIViewController, UIGestureRecognizerDelegate, ViewerGroupViewableDelegate where ContainerViewType: ViewerGroupContainer {
	private typealias Viewable = ViewerGroupViewable
	
	let containerView = ContainerViewType()
	
	private let viewableGroup: [Viewable]
	private var proxies: [UIView: UIView] = [:] // viewable.view -> proxy view
	
	var currentViewIndex: Int = 0
	
	public init(viewableGroup: [ViewerGroupViewable]) {
		self.viewableGroup = viewableGroup
		
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}
	
	func commonInit() {
		view.clipsToBounds = true
		
		viewableGroup.forEach { $0.delegate = self }
	}
	
	public override func viewDidLoad() {
		
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
		
		showViewable(at: currentViewIndex)
	}
	
	public override func loadView() {
		view = containerView
	}
	
	private func showViewable(at viewableIndex: Int, animated: Bool = true) {
		guard viewableGroup.count > viewableIndex,
			viewableIndex >= 0 else { return }
		
		layout(index: viewableIndex, animated: animated)
		
		currentViewIndex = viewableIndex
	}
	
	private func layout(index: Int, animated: Bool = true) {
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
		
		containerView.viewableContainer.applyLayout(layout)
		
		let animateIfNeeded: (@escaping () -> Void) -> Void = animated ? { action in UIView.animate(withDuration: 0.3, animations: action) } : { action in action() }
		
		animateIfNeeded(self.containerView.viewableContainer.layoutIfNeeded)
	}
	
	private func viewable(at index: Int) -> ViewerGroupViewable {
		guard viewableGroup.count > index,
			index >= 0 else { return EmptyViewable() }
		
		return viewableGroup[index]
	}
	
	// MARK: - ViewerGroupViewableDelegate
	
	public func requestFullscreen(for viewable: ViewerGroupViewable) {
		let fullscreenWindow = UIApplication.shared.keyWindow!
		
		let currentFrame = fullscreenWindow.convert(viewable.view.frame, from: viewable.view)
		
		let proxyView = UIView()
//		proxyView.backgroundColor = .black
		proxyView.alpha = 0
		proxyView.frame = currentFrame
		fullscreenWindow.addSubview(proxyView)
		proxies[viewable.view] = proxyView
		
		viewable.view.translatesAutoresizingMaskIntoConstraints = true
		fullscreenWindow.addSubview(viewable.view)
		viewable.view.didMoveToSuperview()
		
		viewable.view.frame = currentFrame
		
		UIView.animate(withDuration: 0.3) {
			viewable.view.frame = fullscreenWindow.frame
		}
	}
	
	public func requestMinimize(for viewable: ViewerGroupViewable) {
		guard let proxyView = proxies[viewable.view] else {
			return
		}
		
		UIView.animate(withDuration: 0.3, animations: {
			viewable.view.frame = proxyView.frame
		}) { [weak self] _ in
			guard let strongSelf = self else { return }
			strongSelf.showViewable(at: strongSelf.currentViewIndex, animated: false)
			viewable.view.didMoveToSuperview()
			
			strongSelf.proxies.removeValue(forKey: proxyView)
		}
	}
	
	// MARK: - Gestures
	
	@objc func userSwipedLeft(_ sender: UIGestureRecognizer) {
		
		showViewable(at: currentViewIndex + 1)
	}
	
	@objc func userSwipedRight(_ sender: UIGestureRecognizer) {
		showViewable(at: currentViewIndex - 1)
	}
	
	// MARK: - NSCodable
	
	public required init?(coder aDecoder: NSCoder) {
		viewableGroup = aDecoder.decodeObject(forKey: viewableGroupKey) as! [Viewable]
		
		super.init(coder: aDecoder)
	}
	
	public override func encode(with aCoder: NSCoder) {
		super.encode(with: aCoder)
		
		aCoder.encode(viewableGroup, forKey: viewableGroupKey)
	}
	
	private let viewableGroupKey = "viewable_group"
}
