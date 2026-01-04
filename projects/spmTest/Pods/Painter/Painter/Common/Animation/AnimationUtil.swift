//
//  AnimationUtil.swift
//  Painter
//
//  Created by Pravin Palaniappan on 01/07/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import Foundation

public struct CoreAnimData {
	public var keypath: AnimKeyPath
	public var duration: Float
	public var delay: Float
	public var values: [Float]
	public var keyTime: [Float]

	public init(
		keypath: AnimKeyPath,
		duration: Float,
		delay: Float,
		values: [Float],
		keyTime: [Float]) {
		self.keypath = keypath
		self.duration = duration
		self.delay = delay
		self.values = values
		self.keyTime = keyTime
	}
}

public enum AnimKeyPath {
	case position
	case postionX
	case postionY
	case scale
	case scaleX
	case scaleY
	case opacity
	case rotation
	case rotationX
	case rotationY
}
