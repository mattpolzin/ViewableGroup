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
		didSet {
			imageView.image = image
			// TODO: update view when this is set.
		}
	}
	
	public var allowsZooming: Bool = true {
		didSet {
			// TODO: enable/disable zooming on scroll view. if disabled, also
			// return scroll view to showing the entire image.
		}
	}
	
	private var imageView: UIImageView = UIImageView()
	
	/// Loads the scroll view for this viewable. Do not call this method directly.
	/// Override this method to provide a non-default scroll view in a subclass.
	override open func loadScrollView() {
		scrollView = UIScrollView()
		view.applyLayout(.horizontal(align: .fill, .view(scrollView)))
	}
	
	public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
