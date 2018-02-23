//
//  ImageViewable.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/3/18.
//  Copyright © 2018 Mathew Polzin. MIT License.
//

import UIKit

/// An ImageViewable shows an image and allows zooming.
/// By default, a ImageViewable will also allow the user to enter/exit
/// fullscreen to get a larger view of its content. Fullscreen can be disallowed
/// by setting `allowsFullscreen` to false.
/// Zooming can be disabled by setting `allowsZooming` to false.
open class ImageViewable: ScrollingViewable {
	
	public var image: UIImage? {
		set(value) {
			imageView.image = value

			updateZoomScales(reset: true)
		}
		get {
			return imageView.image
		}
	}
	
	public var allowsZooming: Bool = true {
		didSet {
			updateView()
		}
	}
	
	override open var active: Bool {
		didSet {
			guard active else { return }
			updateView(reset: true)
		}
	}
	
	override public var delegate: ViewGroupController? {
		didSet {
			delegate?.onViewportWillChange({ [weak self] (viewable, viewport, newFrame) in
				return self?.updateViewBlock(for: newFrame)
			})
		}
	}
	
	private let imageView: UIImageView = UIImageView(frame: .zero)
	
	override public init() {
		super.init()
		commonInit()
	}
	
	public init(image: UIImage) {
		super.init()
		self.image = image
		commonInit()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		allowsFullscreen = true
		view.backgroundColor = .black
	}
	
	/// Loads the scroll view for this viewable. Do not call this method directly.
	/// Override this method to provide a non-default scroll view in a subclass.
	override open func loadScrollView() {
		super.loadScrollView()

        scrollView.applyLayout(
            .horizontal(align: .fill, marginEdges: .none,
                .view(imageView)
            )
        )

		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bounces = false
		scrollView.decelerationRate = UIScrollViewDecelerationRateFast
		
		updateView()
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		scrollView.bouncesZoom = scrollView.zoomScale >= scrollView.maximumZoomScale
		centerContent()
	}
	
	private func updateZoomScales(for proxyFrame: CGRect? = nil, reset: Bool = false) {
		guard let strongImage = image else {
			scrollView.contentSize = CGSize(width: 0, height: 0)
			return
		}
		
		let viewSize = proxyFrame?.size ?? scrollView.bounds.size
		
		// set zoom scales
		let scaleWidth = viewSize.width / strongImage.size.width
		let scaleHeight = viewSize.height / strongImage.size.height
		let minScale = min(scaleWidth, scaleHeight)
		
		// set max/min
		// TODO: make logic that the min zoom scale cannot be larger than 1.0?
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = allowsZooming ? max(minScale, 6.0) : 1.0
		
		guard !reset else {
			scrollView.zoomScale = scrollView.minimumZoomScale
			return
		}
		
		// make sure we are within the acceptable min and max
		scrollView.zoomScale = max(scrollView.zoomScale, scrollView.minimumZoomScale)
		scrollView.zoomScale = min(scrollView.zoomScale, scrollView.maximumZoomScale)
	}
	
	private func centerContent(for proxyFrame: CGRect? = nil) {
		// TODO: this breaks down when the view's frame changes, like for device rotation.
		let viewSize = proxyFrame?.size ?? scrollView.bounds.size
		
		// center content
		var horizontalInset: CGFloat = 0
		var verticalInset: CGFloat = 0
		
		if (scrollView.contentSize.width < viewSize.width) {
			horizontalInset = (viewSize.width - scrollView.contentSize.width) * 0.5
		}
		
		if (scrollView.contentSize.height < viewSize.height) {
			verticalInset = (viewSize.height - scrollView.contentSize.height) * 0.5
		}
		
		if let scale = scrollView.window?.screen.scale, scale < 2.0 {
			horizontalInset = floor(horizontalInset);
			verticalInset = floor(verticalInset);
		}
		
		scrollView.contentInset = UIEdgeInsets(top: verticalInset,
											   left: horizontalInset,
											   bottom: verticalInset,
											   right: horizontalInset)
	}
	
	private func updateViewBlock(for proxyFrame: CGRect? = nil, reset: Bool = false) -> () -> Void {
		return { [weak self] in
			guard let strongSelf = self else { return }
			
			strongSelf.updateZoomScales(for: proxyFrame, reset: reset)
			
			strongSelf.centerContent(for: proxyFrame)
		}
	}
	
	private func updateView(for proxyFrame: CGRect? = nil, animated: Bool = true, reset: Bool = false) {
		guard animated else {
			updateViewBlock(for: proxyFrame, reset: reset)()
			return
		}
		
		UIView.animate(withDuration: 0.3, animations: updateViewBlock(for: proxyFrame, reset: reset))
	}
}
