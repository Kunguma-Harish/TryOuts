//
//  ShowMath.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation

// MARK: Public functions

public func maxOf(_ s1: CGSize, _ s2: CGSize) -> CGSize {
	return CGSize(width: max(s1.width, s2.width), height: max(s1.height, s2.height))
}

public func limit<T>(value: T, minValue: T, maxValue: T) -> T where T: Comparable {
	return Swift.max(Swift.min(value, maxValue), minValue)
}

// MARK: Internal functions

func degreesToRadians(angle: Int) -> Float {
	return Float(angle) * (Float.pi / 180)
}

func radiansToDegrees(angle: CGFloat) -> Float {
	return Float(angle) * (180 / Float.pi)
}

func ifElse(First xx: CGFloat, Second yy: CGFloat, Third z: CGFloat) -> CGFloat {
	if xx > 0 {
		return yy
	}
	return z
}

func cosTan(x: CGFloat, Second y: CGFloat, Third z: CGFloat) -> CGFloat {
	return x * CGFloat(cosf(atan2f(Float(z), Float(y))))
}

func sinTan(x: CGFloat, Second y: CGFloat, Third z: CGFloat) -> CGFloat {
	return x * CGFloat(sinf(atan2f(Float(z), Float(y))))
}
