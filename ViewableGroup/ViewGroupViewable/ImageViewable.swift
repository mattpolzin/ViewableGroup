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
	
	private var imageView: UIImageView = UIImageView(frame: .zero)
	
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
	
	override open func loadView() {
		view = imageView
	}
	
	/// Loads the scroll view for this viewable. Do not call this method directly.
	/// Override this method to provide a non-default scroll view in a subclass.
	override open func loadScrollView() {
		super.loadScrollView()
		
		scrollView.addSubview(imageView)
		
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bouncesZoom = true
		scrollView.decelerationRate = UIScrollViewDecelerationRateFast
		scrollView.minimumZoomScale=0.5
		scrollView.maximumZoomScale=6.0
		updateViewForNewImage()
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
	private func updateViewForNewImage() {
//		scrollView.contentSize=image?.size ?? CGSize(width: 0, height: 0)
	}
}
