//
//  Array+Execute.swift
//  ViewableGroup
//
//  Created by Mathew Polzin on 2/22/18.
//  Copyright © 2018 Mathew Polzin. All rights reserved.
//

import Foundation

internal typealias Closure = () -> Void

internal extension Array where Element == Closure {
	func execute() {
		forEach { $0() }
	}
}
