//
//  Math.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation

// https://stackoverflow.com/a/2198368/5756174
public func getAngle(_ origin: CGPoint, _ other: CGPoint) -> CGFloat {
	let dy = other.y - origin.y
	let dx = other.x - origin.x
	var angle: CGFloat
	if dx == 0 { // special case
		if dy >= 0 {
			angle = .pi / 2.0
		} else {
			angle = .pi / -2.0
		}
	} else {
		angle = atan(dy / dx)
		if dx < 0 { // hemisphere correction
			angle += .pi
		}
	}
	// all between 0 and 2PI
	if angle < 0 { // between -PI/2 and 0
		angle += (2.0 * .pi)
	}
	// radian to degree
	let deg = (angle * 180) / .pi
	return deg
}

// https://math.stackexchange.com/a/1630886
func pointPerpendicularToVertexInEdgeOppositeToTheVertex(vertexOfInterest A: CGPoint, otherVertex1 B: CGPoint, otherVertex2 C: CGPoint) -> CGPoint {
	let a = B.distance(from: C)
	let b = C.distance(from: A)
	let c = B.distance(from: A)
	let s = (a + b + c) / 2
	let h = sqrt(s * (s - a) * (s - b) * (s - c)) / a // Altitude formula
	let dt = sqrt((c * c) - (h * h))
	let t = dt / a
	var D = CGPoint()
	D.x = ((1 - t) * B.x) + (t * C.x)
	D.y = ((1 - t) * B.y) + (t * C.y)
	return D
}

/// Returns the control points for a cubic curve calculated using the details of the circle quadrant given.
/// Reference: https://stackoverflow.com/a/44829356
///
/// - Parameters:
///   - startPoint: The startPoint of the circle quadrant.
///   - endPoint: The endPoint of the circle quadrant.
///   - center: The center of the circle.
/// - Returns: The control points for a cubic curve.
func controlPointsForCubicCurveRepresentationOfCircleQuadrant(
	startPoint: CGPoint,
	endPoint: CGPoint,
	center: CGPoint) -> (control1: CGPoint, control2: CGPoint) {
	let ax = startPoint.x - center.x
	let ay = startPoint.y - center.y
	let bx = endPoint.x - center.x
	let by = endPoint.y - center.y
	let q1 = ax * ax + ay * ay
	let q2 = q1 + ax * bx + ay * by
	let k2 = 4 / 3 * (sqrt(2 * q1 * q2) - q2) / (ax * by - ay * bx)

	let c1x = center.x + ax - (k2 * ay)
	let c1y = center.y + ay + (k2 * ax)
	let c2x = center.x + bx + (k2 * by)
	let c2y = center.y + by - (k2 * bx)

	return (CGPoint(x: c1x, y: c1y), CGPoint(x: c2x, y: c2y))
}

/// Returns a point on a line which is at a distance from the startPoint of the line.
/// Reference https://math.stackexchange.com/a/1630886
///
/// - Parameters:
///   - dt: The distance of the point from the startPoint.
///   - startPoint: The startPoint of the line.
///   - endPoint: The endPoint of the line.
/// - Returns: The point.
public func pointOnLineAtDistanceFromStartPoint(distance dt: CGFloat, startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
	let d = sqrt(pow(endPoint.x - startPoint.x, 2) + pow(endPoint.y - startPoint.y, 2))
	let t = d != 0 ? dt / d : dt
	let xt = ((1 - t) * startPoint.x) + (t * endPoint.x)
	let yt = ((1 - t) * startPoint.y) + (t * endPoint.y)
	return CGPoint(x: xt, y: yt)
}

public func distanceBetweenPoints(_ from: CGPoint, _ to: CGPoint) -> CGFloat {
	let x = from.x - to.x
	let y = from.y - to.y
	let d = sqrt((x * x) + (y * y))
	return d
}

func midPoint(between point1: CGPoint, and point2: CGPoint) -> CGPoint {
	let x = (point1.x + point2.x) / 2
	let y = (point1.y + point2.y) / 2
	return CGPoint(x, y)
}

public func pointToPixel(_ point: CGFloat) -> CGFloat {
	return point * (4.0 / 3.0)
}

public func pixelToPoint(_ pixel: CGFloat) -> CGFloat {
	return pixel * (3.0 / 4.0)
}

public func getPositiveAngle(_ value: CGFloat) -> CGFloat {
	var rotation = value
	rotation += 360
	rotation = rotation.truncatingRemainder(dividingBy: 360)
	return rotation
}

// To get the shortest distance between a point and the line segment.
// The Point is considered to pass through the line perpendicular to the line segment.
// d = Ax1 + By1 + c/ sqrt(a^2 * b ^2);
// val1 - one end in the line segment
// val2 - other end of the line segment
// diffX - x position of the present point
// diffY - y position of the present point
public func distanceOf(val1: CGPoint, val2: CGPoint, diffX: CGFloat, diffY: CGFloat) -> CGFloat {
	let a = val2.y - val1.y
	let b = val1.x - val2.x
	let c = (((-1) * b) * val1.y) - a * val1.x
	let denom = sqrtf(powf(Float(a), 2) + powf(Float(b), 2))
	var dist: CGFloat = 0.0
	if denom != 0 {
		let temp = (a * diffX) + (b * diffY) + c
		dist = temp / CGFloat(denom)
	}
	return CGFloat(dist)
}

public func getAngleForPointOnEllipse(x: CGFloat, y: CGFloat, wR: CGFloat, hR: CGFloat) -> CGFloat {
	let rad1: CGFloat = 2 * .pi
	let n1 = (y - hR) * wR
	let n2 = (x - wR) * hR
	var angle = atan2(n1, n2)
	angle += rad1
	angle = angle.truncatingRemainder(dividingBy: rad1)
	return angle
}
