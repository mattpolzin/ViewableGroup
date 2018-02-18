//
//  ViewableGroupTests.swift
//  ViewableGroupTests
//
//  Created by Mathew Polzin on 2/17/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import XCTest
@testable import ViewableGroup

class ViewableGroupTests: XCTestCase {
    
	func test_count() {
		let viewables: [ViewGroupViewable] = [BasicViewable(), BasicViewable(), BasicViewable()]
		let viewGroup = ViewGroup<BasicViewGroupContainer>(viewables: viewables)
		
		XCTAssertEqual(viewGroup.count, viewables.count)
	}
}
