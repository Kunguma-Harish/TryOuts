//
//  CGPath+Extras.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif

private typealias CGPathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> Void
// Note: You must declare MyPathApplier as @convention(block), because
// if you don't, you get "fatal error: can't unsafeBitCast between
// types of different sizes" at runtime, on Mac OS X at least.

private func myPathApply(_ path: CGPath!, block: @escaping CGPathApplier) {
	let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { info, element in
		let block = unsafeBitCast(info, to: CGPathApplier.self)
		block(element)
	}

	path.apply(info: unsafeBitCast(block, to: UnsafeMutableRawPointer.self), function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
}

extension Array where Element == CGPath {
	var cgpath: CGPath {
		let path = CGMutablePath()
		for element in self {
			path.addPath(element)
		}
		return path
	}
}

extension Collection where Iterator.Element == CustomGeometry.Path {
	var cgpaths: [CGPath] {
		return compactMap { $0.cgpath }
	}

	var patternCgpaths: [CGPath] {
		return compactMap { $0.patternCgPath }
	}
}

public extension CGPath {
	var isNan: Bool {
		let bBox = self.boundingBoxOfPath
		return bBox.origin.x.isNaN || bBox.origin.y.isNaN || bBox.width.isNaN || bBox.height.isNaN
	}

	var isValid: Bool {
		let bBox = self.boundingBoxOfPath
		return !(bBox.isEmpty || bBox.isNull || bBox.isInfinite)
	}

	var nonZeroBoundingBoxOfPath: CGRect {
		if self.isEmpty {
			return CGRect(x: 0, y: 0, width: 1, height: 1)
		} else {
			return self.boundingBoxOfPath
		}
	}

	var custom: CustomGeometry {
		var pathObjects: [PathObject] = []
		self.forEach { element in
			pathObjects.append(element.toPathObject)
		}

		//		if pathObjects.isEmpty || (pathObjects.filter { $0.type == .m }).count > 1 {
		//			assert(false, "not a proper path")
		//			return nil
		//		}
		let size = boundingBoxOfPath.size

		return CustomGeometry.with { custgeom in
			custgeom.pathList = [
				CustomGeometry.Path.with { path in
					path.width = Float(size.width)
					path.height = Float(size.height)
					path.path = pathObjects
				}
			]
		}
	}

#if os(macOS)
	var bezierpath: NSBezierPath {
		let nspath = NSBezierPath()
		myPathApply(self) { element in
			let points = element.pointee.points

			switch element.pointee.type {
			case CGPathElementType.moveToPoint:
				nspath.move(to: points[0])

			case .addLineToPoint:
				nspath.line(to: points[0])

			case .addQuadCurveToPoint:
				let start = nspath.currentPoint
				let end = points[1]
				let control = points[0]

				// https://stackoverflow.com/questions/9485788/
				let control1X = start.x + ((2.0 / 3.0) * (control.x - start.x))
				let control1Y = start.y + ((2.0 / 3.0) * (control.y - start.y))
				let control2X = end.x + ((2.0 / 3.0) * (control.x - end.x))
				let control2Y = end.y + ((2.0 / 3.0) * (control.y - end.y))

				let control1 = CGPoint(x: control1X, y: control1Y)
				let control2 = CGPoint(x: control2X, y: control2Y)
				nspath.curve(to: end, controlPoint1: control1, controlPoint2: control2)

			case .addCurveToPoint:
				nspath.curve(to: points[2], controlPoint1: points[0], controlPoint2: points[1])

			case .closeSubpath:
				nspath.close()
			@unknown default:
				assertionFailure("unknown type")
			}
		}
		return nspath
	}

#elseif os(iOS) || os(tvOS)
	var bezierpath: UIBezierPath {
		let nspath = UIBezierPath()
		myPathApply(self) { element in
			let points = element.pointee.points

			switch element.pointee.type {
			case CGPathElementType.moveToPoint:
				nspath.move(to: points[0])

			case .addLineToPoint:
				nspath.addLine(to: points[0])

			case .addQuadCurveToPoint:
				nspath.addQuadCurve(to: points[1], controlPoint: points[0])

			case .addCurveToPoint:
				nspath.addCurve(to: points[2], controlPoint1: points[0], controlPoint2: points[1])

			case .closeSubpath:
				nspath.close()
			@unknown default:
				assertionFailure("unknown type")
			}
		}
		return nspath
	}
#endif

	func verticalFlip(in frame: CGRect) -> CGPath {
		var trans = CGAffineTransform.identity
		var box = frame
		if box.isNull {
			box.origin = .zero
		}
		trans = trans.translatedBy(x: 0, y: box.size.height)
		trans = trans.scaledBy(x: 1, y: -1)
		trans = trans.translatedBy(x: 0, y: -(2 * box.origin.y))
		guard let path = copy(using: &trans) else {
			assertionFailure("CGPath vflip error")
			return self
		}
		return path
	}

	func horizontalFlip(in frame: CGRect) -> CGPath {
		var trans = CGAffineTransform.identity
		var box = frame
		if box.isNull {
			box.origin = .zero
		}
		trans = trans.translatedBy(x: box.size.width, y: 0)
		trans = trans.scaledBy(x: -1, y: 1)
		trans = trans.translatedBy(x: -(2 * box.origin.x), y: 0)
		guard let path = copy(using: &trans) else {
			assertionFailure("CGPath vflip error")
			return self
		}
		return path
	}

	func rotate(byDegree degree: CGFloat) -> CGPath {
		if degree == 0.0 {
			return self
		}
		let center = boundingBoxOfPath.center

		var trans = CGAffineTransform.identity
		trans = trans.translatedBy(x: center.x, y: center.y)
		trans = trans.rotated(by: degree * CGFloat(Double.pi) / 180.0)
		trans = trans.translatedBy(x: -center.x, y: -center.y)
		guard let path = copy(using: &trans) else {
			assertionFailure("CGPath rotate error")
			return self
		}
		return path
	}

	func enlargeBy(dx: CGFloat, dy: CGFloat) -> CGPath {
		let xOffset = (dx == 0) ? 1 : dx
		let yOffset = (dy == 0) ? 1 : dy
		return self.transform(to: boundingBoxOfPath.enlargeBy(dx: xOffset, dy: yOffset))
	}

	// swiftlint:disable large_tuple
	func affineTransform(
		to targetRect: CGRect,
		from sourceRect: CGRect? = nil) -> (scalingTrans: CGAffineTransform, translationTrans: CGAffineTransform, finalPath: CGPath) {
		if targetRect.isNull || targetRect.isInfinite {
			Debugger.debug("Invalid rect(\(targetRect)) passed for Function: \(#function)")
			return (CGAffineTransform.identity, CGAffineTransform.identity, self)
		}

		var box = sourceRect ?? boundingBoxOfPath
		if box.isNull || box.isInfinite {
			Debugger.debug("Invalid path boundingBox(\(box)) passed for Function: \(#function)")
			return (CGAffineTransform.identity, CGAffineTransform.identity, self)
		}

		var scaleX = targetRect.size.width / box.size.width
		if box.size.width == 0 {
			scaleX = 1
		}

		var scaleY = targetRect.size.height / box.size.height
		if box.size.height == 0 {
			scaleY = 1
		}

		var trans = CGAffineTransform.identity
		trans = trans.scaledBy(x: scaleX, y: scaleY)
		let scalingTrans = trans

		guard let path = copy(using: &trans) else {
			assertionFailure("CGPath scale error")
			return (CGAffineTransform.identity, CGAffineTransform.identity, self)
		}

		box = box.applying(scalingTrans)
		let abox = box
		let transX = targetRect.origin.x - abox.origin.x
		let transY = targetRect.origin.y - abox.origin.y
		trans = CGAffineTransform.identity
		trans = trans.translatedBy(x: transX, y: transY)

		guard let fpath = path.copy(using: &trans) else {
			assertionFailure("CGPath translate error")
			return (CGAffineTransform.identity, CGAffineTransform.identity, self)
		}

		return (scalingTrans, trans, fpath)
	}

	// swiftlint:enable large_tuple

	func transform(to targetRect: CGRect) -> CGPath {
		return self.affineTransform(to: targetRect).finalPath
	}

	func transform(to targetRect: CGRect, from sourceRect: CGRect) -> CGPath {
		return self.affineTransform(to: targetRect, from: sourceRect).finalPath
	}

	typealias Body = @convention(block) (CGPathElement) -> Void

	func forEach(body: @escaping @convention(block) (CGPathElement) -> Void) {
		let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { info, element in
			let body = unsafeBitCast(info, to: Body.self)
			body(element.pointee)
		}
		let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
		self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
	}
}

private extension CGPath {
	static func isSimplePath(_ elements: [PathObject]) -> Bool {
		if elements[0].type != .m {
			return false
		}
		return elements.filter { $0.type == .m }.count == 1
	}
}

public extension CGPathElement {
	var toPathObject: PathObject {
		var pathObject = PathObject()
		switch self.type {
		case .moveToPoint:
			pathObject.m = self.points[0].point
			pathObject.type = .m
		case .addLineToPoint:
			pathObject.l = self.points[0].point
			pathObject.type = .l
		case .addQuadCurveToPoint:
			pathObject.qc = [self.points[0].point, self.points[1].point]
			pathObject.type = .qc
		case .addCurveToPoint:
			pathObject.cc = [self.points[0].point, self.points[1].point, self.points[2].point]
			pathObject.type = .cc
		case .closeSubpath:
			pathObject.c = true
			pathObject.type = .c
		@unknown default:
			assertionFailure("unknown type")
		}
		return pathObject
	}
}
