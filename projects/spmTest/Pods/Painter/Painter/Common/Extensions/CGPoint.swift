//
//  CGPoint.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public struct LineSegment {
	var start: CGPoint
	var end: CGPoint

	init(_ start: CGPoint, _ end: CGPoint) {
		self.start = start
		self.end = end
	}

	var midpoint: CGPoint {
		return self.point(at: 0.5) // CGPoint(x: (start.x + end.x) / 1.5, y: (start.y + end.y) / 1.5)
	}

	/// Computes a point that is at a ratio of t distance from the start of the line segment to it end.
	///
	/// - Parameter t: Ratio of distance of the intended point to the total distance of the line segment. Ranges between 0 to 1.
	/// - Returns: CGPoint that is a ratio of t distance from the starting point
	func point(at t: Float) -> CGPoint {
		let x = self.start.x + ((self.end.x - self.start.x) * CGFloat(t))
		let y = self.start.y + ((self.end.y - self.start.y) * CGFloat(t))
		return CGPoint(x: x, y: y)
	}
}

public extension CGPoint {
	var point: PathObject.Point {
		var point = PathObject.Point()
		point.x = Float(x)
		point.y = Float(y)
		return point
	}

	init(_ x: CGFloat, _ y: CGFloat) {
		self.init(x: x, y: y)
	}

	init(_ x: Int, _ y: Int) {
		self.init(x: x, y: y)
	}

	init(_ x: Double, _ y: Double) {
		self.init(x: x, y: y)
	}

	init(_ x: Float, _ y: Float) {
		self.init(x: CGFloat(x), y: CGFloat(y))
	}

	func rotate(around point: CGPoint, byDegree degree: CGFloat) -> CGPoint {
		var xfrm = CGAffineTransform.identity
		xfrm = xfrm.translatedBy(x: point.x, y: point.y)
		xfrm = xfrm.rotated(by: degree * .pi / 180.0)
		xfrm = xfrm.translatedBy(x: -point.x, y: -point.y)
		return self.applying(xfrm)
	}

	func mirror(from midpoint: CGPoint) -> CGPoint {
		return CGPoint(x: (2 * midpoint.x) - self.x, y: (2 * midpoint.y) - self.y)
	}

	func distance(from point: CGPoint) -> CGFloat {
		let x = self.x - point.x
		let y = self.y - point.y
		let d = sqrt((x * x) + (y * y))
		return d
	}

	static func + (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}

	static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
		return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}

	static func -= (_ lhs: inout CGPoint, _ rhs: CGPoint) {
		lhs.x -= rhs.x
		lhs.y -= rhs.y
	}

	static func += (_ lhs: inout CGPoint, _ rhs: CGPoint) {
		lhs.x += rhs.x
		lhs.y += rhs.y
	}
}
