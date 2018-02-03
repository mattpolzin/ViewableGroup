//
//  ViewGroupController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit

/// A controller that manages a group of viewables.
public class ViewGroupController<ContainerViewType: UIView>: UIViewController, UIGestureRecognizerDelegate, ViewGroupViewableDelegate where ContainerViewType: ViewGroupContainer {
	private typealias Viewable = ViewGroupViewable
	
	let containerView = ContainerViewType()
	public var browsingEnabled: Bool = true
	
	private let viewableGroup: [Viewable]
	private var proxies: [UIView: UIView] = [:] // viewable.view -> proxy view
	
	private var leftSwipeRecognizer: UISwipeGestureRecognizer?
	private var rightSwipeRecognizer: UISwipeGestureRecognizer?
	
	private var currentViewIndex: Int = 0
	
	public init(viewableGroup: [ViewGroupViewable]) {
		self.viewableGroup = viewableGroup
		
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}
	
	private func commonInit() {
		view.clipsToBounds = true
		
		let offscreenRight = CGRect(x: UIScreen.main.bounds.width, y: 0, width: 10, height: 10)
		viewableGroup.forEach { viewable in
			viewable.delegate = self
			viewable.view.frame = offscreenRight
		}
	}
	
	public override func viewDidLoad() {
		let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedLeft(_:)))
		leftSwipeRecognizer = leftRecognizer
		leftRecognizer.direction = .left
		leftRecognizer.delegate = self
		view.addGestureRecognizer(leftRecognizer)
		
		let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(userSwipedRight(_:)))
		rightSwipeRecognizer = rightRecognizer
		rightRecognizer.direction = .right
		rightRecognizer.delegate = self
		view.addGestureRecognizer(rightRecognizer)
		
		showViewable(at: currentViewIndex)
	}
	
	public override func loadView() {
		view = containerView
	}
	
	/// Show the viewable at the given index. All other viewables will be
	/// laid out to the right and left of the viewable at the given index.
	/// - properties:
	///		- viewableIndex: The index of the viewable to show.
	///		- animated: true to animate the viewables from their current location to the new one.
	private func showViewable(at viewableIndex: Int, animated: Bool = true) {
		guard viewableGroup.count > viewableIndex,
			viewableIndex >= 0 else { return }
		
		// update viewable focus before laying out views
		var idx = 0
		for viewable in viewableGroup {
			
			viewable.active = idx == viewableIndex
			
			idx = idx + 1
		}
		
		layout(around: .viewable(at: viewableIndex), animated: animated)
		
		currentViewIndex = viewableIndex
	}
	
	/// The current viewable can either be the viewable at a given index or it
	/// can be a proxy view for the viewable at a certain index.
	private enum CurrentViewable {
		case viewable(at: Int)
		case proxy(view: UIView, at: Int)
	}
	
	/// Layout all of the viewables.
	/// - properties:
	///		- viewable: The viewable to layout as "current" (i.e. filling the viewableContainer).
	///		- animated: true to animate the views from their current layout to the new one.
	private func layout(around viewable: CurrentViewable, animated: Bool = true) {
		let index: Int
		let currentView: UIView
		
		switch viewable {
		case .viewable(at: let idx):
			index = idx
			currentView = self.viewable(at: idx).view
			
		case .proxy(view: let view, at: let idx):
			index = idx
			currentView = view
		}
		
		guard viewableGroup.count > index,
			index >= 0 else { return }
		
		var views = [index - 2, index - 1, index + 1, index + 2].map(viewable(at:)).flatMap { $0.view }
		views.insert(currentView, at: 2)
		
		guard let leftView: LayoutEntity = views.first.map({ .sizedView($0, .lengthEqualTo(ratio: 1 / CGFloat(views.count))) }) else { return }
		
		let otherViews: [(independent: LayoutEntity, same: LayoutEntity)] = views.dropFirst().map { (independent: .space(0), same: .view($0)) }
		
		let layout: Layout = .vertical(align: .center, marginEdges: .none,
			.horizontal(align: .fill, size: .breadthEqualTo(ratio: CGFloat(views.count)),
						.matched(leftView, otherViews, priority: .required)
				)
		)
		
		containerView.viewableContainer.applyLayout(layout)
		
		let animateIfNeeded: (@escaping () -> Void) -> Void = animated ? { action in UIView.animate(withDuration: 0.3, animations: action) } : { action in action() }
		
		animateIfNeeded(self.containerView.viewableContainer.layoutIfNeeded)
	}
	
	/// Retrieve the viewable at the given index or an empty viewable if the
	/// index specified is outside the filled indices.
	/// - property index: The index of the viewable to retrieve
	private func viewable(at index: Int) -> ViewGroupViewable {
		guard viewableGroup.count > index,
			index >= 0 else { return EmptyViewable() }
		
		return viewableGroup[index]
	}
	
	// MARK: - ViewerGroupViewableDelegate
	
	public func requestFullscreen(for viewable: ViewGroupViewable) {
		let fullscreenWindow = UIApplication.shared.keyWindow!
		
		let currentFrame = fullscreenWindow.convert(viewable.view.frame, from: viewable.view)
		
		let proxyView = UIView(frame: currentFrame)
		proxyView.alpha = 0
		fullscreenWindow.addSubview(proxyView)
		proxies[viewable.view] = proxyView
		
		viewable.view.translatesAutoresizingMaskIntoConstraints = true
		fullscreenWindow.addSubview(viewable.view)
		viewable.view.didMoveToSuperview()
		
		viewable.view.frame = currentFrame
		
		viewable.fullscreen = true
		UIView.animate(withDuration: 0.3, animations: {
			viewable.view.frame = fullscreenWindow.bounds
		}) { [weak self] _ in
			guard let strongSelf = self else { return }
			
			strongSelf.layout(around: .proxy(view: proxyView, at: strongSelf.currentViewIndex), animated: false)
			
			fullscreenWindow.applyLayout(.horizontal(align: .fill, .view(viewable.view)))
		}
	}
	
	public func requestUnfullscreen(for viewable: ViewGroupViewable) {
		guard let proxyView = proxies[viewable.view] else {
			return
		}
		
		let fullscreenWindow = UIApplication.shared.keyWindow!
		
		let proxyFrame = fullscreenWindow.convert(proxyView.frame, from: proxyView)
		
		viewable.fullscreen = false
		UIView.animate(withDuration: 0.3, animations: {
			viewable.view.frame = proxyFrame
		}) { [weak self] _ in
			guard let strongSelf = self else { return }
			
			strongSelf.showViewable(at: strongSelf.currentViewIndex, animated: false)
			viewable.view.didMoveToSuperview()
			
			strongSelf.proxies.removeValue(forKey: viewable.view)
		}
	}
	
	// MARK: - Gestures
	
	@objc func userSwipedLeft(_ sender: UIGestureRecognizer) {
		guard browsingEnabled else { return }
		
		showViewable(at: currentViewIndex + 1)
	}
	
	@objc func userSwipedRight(_ sender: UIGestureRecognizer) {
		guard browsingEnabled else { return }
		
		showViewable(at: currentViewIndex - 1)
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return gestureRecognizer == leftSwipeRecognizer || gestureRecognizer == rightSwipeRecognizer
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
	
	// MARK: - NSCodable
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}
