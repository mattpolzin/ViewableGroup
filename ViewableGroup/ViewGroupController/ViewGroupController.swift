//
//  ViewGroupController.swift
//  FullscreenViewerDemo
//
//  Created by Mathew Polzin on 12/3/17.
//  Copyright © 2017 Mathew Polzin. All rights reserved.
//

import UIKit
import BrightFutures
import Result

private enum ViewGroupError: Error {
	case error
}

/// A controller that manages a group of viewables.
public class ViewGroupController<ContainerViewType: UIView>: UIViewController, UIGestureRecognizerDelegate where ContainerViewType: ViewGroupContainer {
	private typealias Viewable = ViewGroupViewable
	
	/// If true, the user is allowed to swipe left and right to browse the
	/// viewables. Default is true.
	public var browsingEnabled: Bool = true
	
	/// The horizontal space between the current viewable and the viewables to its
	/// left or right. Default is 0.
	public var viewableSpacing: CGFloat = 0 {
		didSet {
			guard view.superview != nil else { return }
			
			showViewable(at: currentViewableIndex)
		}
	}
	
	private let containerView = ContainerViewType()
	
	private let viewableGroup: [Viewable]
	private var proxies: [UIView: UIView] = [:] // viewable.view -> proxy view
	
	private var leftSwipeRecognizer: UISwipeGestureRecognizer?
	private var rightSwipeRecognizer: UISwipeGestureRecognizer?
	
	private var currentViewableIndex: Int = 0
	
	public init(viewableGroup: [ViewGroupViewable]) {
		self.viewableGroup = viewableGroup
		
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}
	
	private func commonInit() {
		view.clipsToBounds = true
		
		// start all viewables offscreen to the right because we will begin
		// with the farthest left viewable as currently active
		let offscreenRight = CGRect(x: UIScreen.main.bounds.width, y: 0, width: 10, height: 10)
		viewableGroup.forEach { viewable in
			viewable.delegateAvailable(self)
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
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		showViewable(at: currentViewableIndex, animated: animated)
	}
	
	public override func loadView() {
		view = containerView
	}
	
	/// A bit less efficient than showing the viewable at a particular index,
	/// but this method will find the viewable and show it.
	/// - parameters:
	/// 	- viewable: The viewable to show.
	///		- animated: True to animate the viewables from their current location
	///			to the new one. Default is true.
	///		- completion: Function to call once the viewable has been shown. It
	///			will be passed one argument: `found`.
	///		- found: `true` if the viewable was shown, `false` if it was not found in
	///			the view group.
	private func showViewable(_ viewable: Viewable, animated: Bool = true, completion: @escaping (_ found: Bool) -> Void = { _ in }) {
		for idx in (0..<viewableGroup.count) {
			if viewableGroup[idx].view == viewable.view {
				guard idx != currentViewableIndex else {
					completion(true)
					return
				}
				
				showViewable(at: idx, animated: animated, completion: { completion(true) } )
				return
			}
		}
		completion(false)
	}
	
	/// Show the viewable at the given index. All other viewables will be
	/// laid out to the right and left of the viewable at the given index.
	/// - parameters:
	///		- viewableIndex: The index of the viewable to show.
	///		- animated: true to animate the viewables from their current location to the new one.
	private func showViewable(at viewableIndex: Int, animated: Bool = true, completion: @escaping () -> Void = {}) {
		guard viewableGroup.count > viewableIndex,
			viewableIndex >= 0 else { return }
		
		// update viewable focus before laying out views
		var idx = 0
		for viewable in viewableGroup {
			
			viewable.positioning(is: idx == viewableIndex ? .central : .background)
			
			idx = idx + 1
		}
		
		layout(around: .viewable(at: viewableIndex), animated: animated, completion: completion)
		
		currentViewableIndex = viewableIndex
	}
	
	/// The current viewable can either be the viewable at a given index or it
	/// can be a proxy view for the viewable at a certain index.
	private enum CurrentViewable {
		case viewable(at: Int)
		case proxy(view: UIView, at: Int)
	}
	
	/// Layout all of the viewables.
	/// - parameters:
	///		- viewable: The viewable to layout as "current" (i.e. filling the viewableContainer).
	///		- animated: true to animate the views from their current layout to the new one.
	private func layout(around viewable: CurrentViewable, animated: Bool = true, completion: @escaping () -> Void = {}) {
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
		
		// lay out 2 viewables to the left and 2 views to the right so that at the
		// end of animating all viewables one spot to the left or right the next
		// view over animates into view at the end correctly.
		var views = [index - 2, index - 1, index + 1, index + 2].map(viewable(at:)).flatMap { $0.view }
		views.insert(currentView, at: 2)
		
		let viewableGroupWidthRatio = CGFloat(views.count)
		let viewableGroupAdditionalWidth = CGFloat(views.count - 1) * viewableSpacing
		let viewableWidthRatio = 1 / viewableGroupWidthRatio
		let viewableAdditionalWidth = -1 * viewableWidthRatio * viewableGroupAdditionalWidth
		
		// The viewable group's total width will be the viewable container's width
		// multiplied by the viewableGroupWidthRatio added to the viewableGroupAdditionalWidth.
		
		// Each viewable' width will be the viewable group's total width multiplied by
		// the viewableWidthRatio added to the viewableAdditionalWidth.
		
		// The end result is that each viewable is the same width as the viewable container
		// and the viewable group's width is large enough to fit all the viewables being
		// laid out AND the space between each viewable.
		
		let spacing: LayoutEntity = .space(LayoutDimension(constant: viewableSpacing))
		
		guard let leftView: LayoutEntity = views.first.map({ .sizedView($0, .lengthEqualTo(ratio: viewableWidthRatio, constant: viewableAdditionalWidth)) }) else {
			return
		}
		
		let otherViews: [(independent: LayoutEntity, same: LayoutEntity)] = views.dropFirst().map { (independent: spacing, same: .view($0)) }
		
		let layout: Layout = .vertical(align: .center, marginEdges: .none,
		.horizontal(align: .fill, size: .breadthEqualTo(ratio: viewableGroupWidthRatio, constant: viewableGroupAdditionalWidth, priority: .defaultHigh),
						.matched(leftView, otherViews, priority: .required)
				)
		)
		
		containerView.viewableContainer.applyLayout(layout)
		
		let animateIfNeeded: (@escaping () -> Void) -> Void = animated ? { action in
			UIView.animate(withDuration: 0.3,
						   animations: action,
						   completion: { _ in completion() })
		} : { action in
			action()
			completion()
		}
		
		animateIfNeeded(self.containerView.viewableContainer.layoutIfNeeded)
	}
	
	/// Retrieve the viewable at the given index or an empty viewable if the
	/// index specified is outside the filled indices.
	/// - parameter index: The index of the viewable to retrieve
	private func viewable(at index: Int) -> ViewGroupViewable {
		guard viewableGroup.count > index,
			index >= 0 else { return EmptyViewable() }
		
		return viewableGroup[index]
	}
	
	// MARK: - Gestures
	
	@objc func userSwipedLeft(_ sender: UIGestureRecognizer) {
		guard browsingEnabled else { return }
		
		showViewable(at: currentViewableIndex + 1)
	}
	
	@objc func userSwipedRight(_ sender: UIGestureRecognizer) {
		guard browsingEnabled else { return }
		
		showViewable(at: currentViewableIndex - 1)
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

// MARK: - ViewerGroupViewableDelegate

extension ViewGroupController: ViewGroupViewableDelegate {
	
	public func request(viewport: ViewableViewport, for viewable: ViewGroupViewable) {
		// TODO: make these actions synchronous and allow them to be queued up so that
		//		things don't get wonky if, for example, fullscreen is requested and
		//		then contained is requested immediately before the fullscreen animations
		// 		have completed.
		
		// TODO: allow animated to be specified for these requests so that code can
		//		start a particular viewable in fullscreen without needing to animate
		//		into that state.
		switch viewport {
		case .fullscreen:
			requestFullscreen(for: viewable)
		case .container:
			requestUnfullscreen(for: viewable)
		}
	}
	
	private func requestFullscreen(for viewable: ViewGroupViewable) {
		// strategy: Put a proxy view in place of viewable that wants fullscreen,
		//		turn on frame-based constraints, add viewable as subview of
		//		 window and animate its frame to the full size of that window.
		//		The proxy view will be used to animate the viewable back from
		//		fullscreen.
		
		// we will execute all this fullscreen goodness below after making sure
		// the viewable requesting fullscreen is the only viewable that will be
		// in fullscreen and also that it is `central` rather than `background`.
		let unsafeFullscreen = { [weak self] in
			guard let strongSelf = self else {
				return
			}
			
			print("fullscreening \(viewable.view)")
			
			let fullscreenWindow = UIApplication.shared.keyWindow!
			
			let currentFrame = fullscreenWindow.convert(viewable.view.frame, from: viewable.view)
			
			let proxyView = UIView(frame: currentFrame)
			proxyView.alpha = 0
			fullscreenWindow.addSubview(proxyView)
			strongSelf.proxies[viewable.view] = proxyView
			
			viewable.view.translatesAutoresizingMaskIntoConstraints = true
			fullscreenWindow.addSubview(viewable.view)
			viewable.view.didMoveToSuperview()
			
			viewable.view.frame = currentFrame
			
			viewable.moved(to: .fullscreen)
			
			UIView.animate(withDuration: 0.3, animations: {
				viewable.view.frame = fullscreenWindow.safeAreaLayoutGuide.layoutFrame
			}) { [weak strongSelf] _ in
				guard let strongSelf = strongSelf else { return }
				
				strongSelf.layout(around: .proxy(view: proxyView, at: strongSelf.currentViewableIndex), animated: false)
				
				fullscreenWindow.applyLayout(.horizontal(align: .fill, marginEdges: .allSafeArea, .view(viewable.view)))
			}
		}
		
		let futures = viewableGroup.traverse { viewable in
			Future<Void, ViewGroupError> { complete in
				requestUnfullscreen(for: viewable, completion: { success in
					complete(.success(()))
				})
			}
		}
		
		futures.onComplete { [weak self] _ in
			guard let strongSelf = self else { return }
			
			// A fullscreen viewable must be "current"
			strongSelf.showViewable(viewable, animated: true) { found in
				
				guard found == true else {
					assertionFailure("A viewable requesting fullscreen MUST be a part of the viewable group that provided the delegate being asked for fullscreen")
					return
				}
				
				unsafeFullscreen()
			}
		}
	}
	
	private func requestUnfullscreen(for viewable: ViewGroupViewable, completion: @escaping (_ success: Bool) -> Void = { _ in }) {
		// strategy: Retrieve the frame of the proxy for the viewable that wants
		//		to leave fullscreen, animate the viewables frame to equal the proxy
		//		views frame, lay the viewable out in the group layout,
		//		and remove the proxy view.
		
		guard let proxyView = proxies[viewable.view] else {
			print("don't need to unfullscreen \(viewable.view)")
			completion(false)
			return
		}
		
		let fullscreenWindow = UIApplication.shared.keyWindow!
		
		let proxyFrame = fullscreenWindow.convert(proxyView.frame, from: proxyView)
		
		viewable.moved(to: .container)
		
		UIView.animate(withDuration: 0.3, animations: {
			viewable.view.frame = proxyFrame
		}) { [weak self] _ in
			guard let strongSelf = self else { return }
			
			strongSelf.showViewable(at: strongSelf.currentViewableIndex, animated: false)
			viewable.view.didMoveToSuperview()
			
			strongSelf.proxies.removeValue(forKey: viewable.view)
			
			print("done unfullscreening \(viewable.view)")
			completion(true)
		}
	}
}