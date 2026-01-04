//
//  CGRect.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension CGRect {
	var center: CGPoint {
		get {
			return CGPoint(x: self.midX, y: self.midY)
		}
		set {
			let x = newValue.x - (size.width / 2.0)
			let y = newValue.y - (size.height / 2.0)
			origin = CGPoint(x: x, y: y)
		}
	}

	var area: CGFloat {
		return self.width * self.height
	}

	var vFlip: CGAffineTransform {
		var trans = CGAffineTransform.identity
		trans = trans.translatedBy(x: 0, y: size.height)
		trans = trans.scaledBy(x: 1, y: -1)
		trans = trans.translatedBy(x: 0, y: -(2 * origin.y))
		return trans
	}

	init(x: Float, y: Float, width: Float, height: Float) {
		self.init(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
	}

	func enlargeBy(dx: CGFloat, dy: CGFloat) -> CGRect {
		return self.insetBy(dx: -dx, dy: -dy)
	}

	func rotateAtCenter(byDegree degree: CGFloat) -> CGRect {
		if degree == 0 {
			return self
		}
		return self.rotate(byDegree: degree, at: self.center)
	}

	func rotate(byDegree degree: CGFloat, at anchor: CGPoint) -> CGRect {
		if degree == 0 {
			return self
		}
		let radians = degree * .pi / 180.0
		var xfrm = CGAffineTransform.identity
		xfrm = xfrm.translatedBy(x: anchor.x, y: anchor.y)
		xfrm = xfrm.rotated(by: radians)
		xfrm = xfrm.translatedBy(x: -anchor.x, y: -anchor.y)
		return self.applying(xfrm)
	}

	var lowerLeft: CGPoint {
		get {
			return CGPoint(x: self.minX, y: self.maxY)
		}
		set {
			let y = newValue.y - size.height
			origin = CGPoint(x: newValue.x, y: y)
		}
	}

	var lowerMiddle: CGPoint {
		get {
			return CGPoint(x: self.midX, y: self.maxY)
		}
		set {
			let x = newValue.x - (size.width / 2.0)
			let y = newValue.y - size.height
			origin = CGPoint(x: x, y: y)
		}
	}

	var lowerRight: CGPoint {
		get {
			return CGPoint(x: self.maxX, y: self.maxY)
		}
		set {
			let x = newValue.x - size.width
			let y = newValue.y - size.height
			origin = CGPoint(x: x, y: y)
		}
	}

	var middleLeft: CGPoint {
		get {
			return CGPoint(x: self.minX, y: self.midY)
		}
		set {
			let y = newValue.y - (size.height / 2.0)
			origin = CGPoint(x: newValue.x, y: y)
		}
	}

	var middleRight: CGPoint {
		get {
			return CGPoint(x: self.maxX, y: self.midY)
		}
		set {
			let x = newValue.x - size.width
			let y = newValue.y - (size.height / 2.0)
			origin = CGPoint(x: x, y: y)
		}
	}

	var upperLeft: CGPoint {
		get {
			return CGPoint(x: self.minX, y: self.minY)
		}
		set {
			origin = newValue
		}
	}

	var upperMiddle: CGPoint {
		get {
			return CGPoint(x: self.midX, y: self.minY)
		}
		set {
			let x = newValue.x - (size.width / 2.0)
			origin = CGPoint(x: x, y: newValue.y)
		}
	}

	var upperRight: CGPoint {
		get {
			return CGPoint(x: self.maxX, y: self.minY)
		}
		set {
			let x = newValue.x - size.width
			origin = CGPoint(x: x, y: newValue.y)
		}
	}

	var cgpath: CGPath {
		return CGPath(rect: self, transform: nil)
	}

	var transform: Transform {
		return Transform.with {
			$0.rect = self
		}
	}

	var isValid: Bool {
		return !(self.isNull || self.isEmpty || self.isInfinite)
	}
}
