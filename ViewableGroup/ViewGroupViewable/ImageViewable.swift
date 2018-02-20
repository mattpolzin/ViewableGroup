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
			updateViewForNewImage()
			// TODO: update view when this is set.
		}
		get {
			return imageView.image
		}
	}
	
	public var allowsZooming: Bool = true {
		didSet {
			// TODO: enable/disable zooming on scroll view. if disabled, also
			// return scroll view to showing the entire image.
		}
	}
	
	// TODO: make active `open` rather than public
	override public var active: Bool {
		didSet {
			guard active else { return }
			updateViewForNewImage()
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
		allowsFullscreen = false
	}
	
	/// Loads the scroll view for this viewable. Do not call this method directly.
	/// Override this method to provide a non-default scroll view in a subclass.
	override open func loadScrollView() {
		super.loadScrollView()
		
		scrollView.addSubview(imageView)
		
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bouncesZoom = true
		scrollView.bounces = false
		scrollView.decelerationRate = UIScrollViewDecelerationRateFast
		scrollView.maximumZoomScale = 6.0
		
		updateViewForNewImage()
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	private func updateViewForNewImage() {
		guard let strongImage = image else {
			scrollView.contentSize = CGSize(width: 0, height: 0)
			return
		}
		
		scrollView.zoomScale = 1.0
		scrollView.contentOffset = CGPoint(x: 0, y: 0)
		
		// set content size
		var newFrame = imageView.frame
		newFrame.size = strongImage.size
		imageView.frame = newFrame
		scrollView.contentSize = strongImage.size
		
		// set zoom scales
		let scaleWidth = scrollView.bounds.width / strongImage.size.width
		let scaleHeight = scrollView.bounds.height / strongImage.size.height
		let minScale = min(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = max(minScale, scrollView.maximumZoomScale)
		
		// center content
		var horizontalInset: CGFloat = 0
		var verticalInset: CGFloat = 0

		if (scrollView.contentSize.width * minScale < scrollView.bounds.width) {
			horizontalInset = (scrollView.bounds.width - scrollView.contentSize.width * minScale) * 0.5
		}

		if (scrollView.contentSize.height * minScale < scrollView.bounds.height) {
			verticalInset = (scrollView.bounds.height - scrollView.contentSize.height * minScale) * 0.5
		}

		if let scale = scrollView.window?.screen.scale, scale < 2.0 {
			horizontalInset = floor(horizontalInset);
			verticalInset = floor(verticalInset);
		}

		scrollView.contentInset = UIEdgeInsets(top: verticalInset,
											   left: horizontalInset,
											   bottom: verticalInset,
											   right: horizontalInset)
		
		// zoom all the way out
		scrollView.zoomScale = scrollView.minimumZoomScale
	}
}
