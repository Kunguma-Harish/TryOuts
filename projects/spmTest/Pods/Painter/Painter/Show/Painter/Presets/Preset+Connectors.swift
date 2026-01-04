//
//  Preset+Connectors.swift
//  Painter
//
//  Created by Sarath Kumar G on 18/04/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// swiftlint:disable file_length
extension Preset {
	func zeroCheck(modifiers: [CGFloat], maxX: CGFloat, maxY: CGFloat) -> [String: Any] {
		var width = maxX
		var height = maxY
		var modifiers = modifiers
		if maxX < 1 {
			for i in 0..<modifiers.count where i.isMultiple(of: 2) {
				modifiers[i] *= maxX
			}
			width = 1
		}
		if maxY < 1 {
			for i in 0..<modifiers.count where !i.isMultiple(of: 2) {
				modifiers[i] *= maxY
			}
			height = 1
		}
		return ["width": width, "height": height, "modifiers": modifiers]
	}

	static func bezierPoint(start: CGFloat, controlPoint1 cp1: CGFloat, controlPoint2 cp2: CGFloat, end: CGFloat, interval t: CGFloat) -> CGFloat {
		let point = (pow(1 - t, 3) * start) + (3 * pow(1 - t, 2) * t * cp1) + (3 * (1 - t) * pow(t, 2) * cp2) + (pow(t, 3) * end)
		return point
	}

	static func getCorrespondingPoint(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat, distance: CGFloat) -> [CGPoint] {
		let vx = endX - startX
		let vy = (endY - startY)
		let len = CGFloat(sqrt(vx * vx + vy * vy))
		let ux = -vy / len
		let uy = vx / len
		return [CGPoint(x: startX + ux * distance, y: startY + uy * distance), CGPoint(x: startX - ux * distance, y: startY - uy * distance)]
	}

	static func anglesForRotation(point: ([CGPoint], [CGPathElementType]), header: Bool) -> CGFloat {
		var starting = 1
		var theta: CGFloat = 10_000.0
		if !header {
			starting = point.0.count - 1
		}
		//		var ending: Int {
		//			switch point.1[starting] {
		//			case .addCurveToPoint:
		//				return 3
		//			case .addLineToPoint:
		//				return 1
		//			case .addQuadCurveToPoint:
		//				return 2
		//			default:
		//				assert(false, "not a connector")
		//				// return 0
		//			}
		//		}
		if starting != 1 {
			if point.1[starting] == .addLineToPoint {
				theta = atan2(point.0[starting].y - point.0[starting - 1].y, point.0[starting].x - point.0[starting - 1].x)
				return theta
			}
			// the hard coded interval value is just an approximation so as
			// to get a relatively closer slope value
			let bx = Preset.bezierPoint(
				start: point.0[point.0.count - 4].x,
				controlPoint1: point.0[point.0.count - 3].x,
				controlPoint2: point.0[point.0.count - 2].x,
				end: point.0[point.0.count - 1].x,
				interval: 0.9)
			let by = Preset.bezierPoint(
				start: point.0[point.0.count - 4].y,
				controlPoint1: point.0[point.0.count - 3].y,
				controlPoint2: point.0[point.0.count - 2].y,
				end: point.0[point.0.count - 1].y,
				interval: 0.9)
			theta = atan2(point.0[starting].y - by, point.0[starting].x - bx)
			return theta
		} else {
			if point.1[starting] == .addLineToPoint {
				theta = atan2(point.0[starting].y - point.0[starting - 1].y, point.0[starting].x - point.0[starting - 1].x)
				return theta
			}
			// the hard coded interval value is just an approximation so as
			// to get a relatively closer slope value
			let bx = Preset.bezierPoint(start: point.0[0].x, controlPoint1: point.0[1].x, controlPoint2: point.0[2].x, end: point.0[3].x, interval: 0.1)
			let by = Preset.bezierPoint(start: point.0[0].y, controlPoint1: point.0[1].y, controlPoint2: point.0[2].y, end: point.0[3].y, interval: 0.1)
			theta = atan2(by - point.0[starting - 1].y, bx - point.0[starting - 1].x)
			return theta
		}
	}

	// swiftlint:disable cyclomatic_complexity
	func getValueToReduce(marker: Marker, strokeWidth: CGFloat, cap: Stroke) -> CGFloat {
		if marker.hasHeight, marker.hasWidth, marker.hasType {
			let markerHeight = Preset.getMarkerSize(marker.width)
			let markerWidth = Preset.getMarkerSize(marker.height)
			let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)

			switch marker.type {
			case .diamond, .oval:
				//                return strokeWidth
				if cap.captype == .flat {
					return strokeWidth * CGFloat(0.5 * markerWidth - 0.5)
				} else if cap.captype == .capround {
					return strokeWidth * (CGFloat(0.5) * markerWidth)
				} else {
					return strokeWidth * (CGFloat(0.70) * markerWidth)
				}
			case .open:
				if cap.captype == .square {
					return strokeWidth * (CGFloat(1.4) * miterLength)
				} else {
					return strokeWidth * miterLength
				}
			case .block:
				return strokeWidth * (markerWidth - CGFloat(0.3))
			case .classic:
				if cap.hasCaptype {
					if cap.captype == .flat {
						return strokeWidth * CGFloat(0.5 * markerWidth - 0.5)
					} else if cap.captype == .capround {
						return strokeWidth * (CGFloat(0.5) * markerWidth)
					} else {
						return strokeWidth * (CGFloat(0.70) * markerWidth)
					}
				}
			case .none, .defMarkerType:
				return 0
			}
		}
		return 0
	}

	// swiftlint:enable cyclomatic_complexity

	// currently not used, might be of use when a point on a curve has to be determined
	func pointOnCurve(t: CGFloat, startPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, endPoint: CGPoint) -> CGPoint {
		// x = (1-t)*(1-t)*(1-t)*p0x + 3*(1-t)*(1-t)*t*p1x + 3*(1-t)*t*t*p2x + t*t*t*p3x;
		var point = CGPoint()
		let tCube = t * t * t, tSquare = t * t, oneTCube = (1 - t) * (1 - t) * (1 - t), oneTSquare = (1 - t) * (1 - t)
		point.x = (oneTCube * startPoint.x) + (3 * oneTSquare * t * controlPoint1.x) + (3 * (1 - t) * tSquare * controlPoint2.x) + (tCube * endPoint.x)
		point.y = (oneTCube * startPoint.y) + (3 * oneTSquare * t * controlPoint1.y) + (3 * (1 - t) * tSquare * controlPoint2.y) + (tCube * endPoint.y)
		return point
	}

	static func oval(width: CGFloat, ry: CGFloat, rx: CGFloat, cx: CGFloat, cy: CGFloat) -> CGMutablePath {
		let path = CGMutablePath()
		let rectangle = CGRect(x: cx + (-width * rx / 2), y: cy + (-width * ry / 2), width: 2 * width * rx / 2, height: 2 * width * ry / 2)
		path.addEllipse(in: rectangle)
		return path
	}

	static func diamond(width: CGFloat, ry: CGFloat, rx: CGFloat, cx: CGFloat, cy: CGFloat) -> CGMutablePath {
		let path = CGMutablePath()
		path.move(to: CGPoint(x: cx, y: cy + -(width * ry / CGFloat(2.0))))
		path.addLine(to: CGPoint(x: cx + width * rx / 2.0, y: cy))
		path.addLine(to: CGPoint(x: cx, y: cy + width * ry / 2.0))
		path.addLine(to: CGPoint(x: cx + -(width * rx / 2.0), y: cy))
		path.closeSubpath()
		return path
	}

	static func headendOpenMarker(width: CGFloat, markerWidth: CGFloat, markerHeight: CGFloat, startX: CGFloat, startY: CGFloat) -> CGMutablePath {
		let endX = startX - (markerWidth * width)
		let endY = startY + (markerHeight * width)
		let cy = startY + ((endY - startY) / 2)
		let startPoint = self.getCorrespondingPoint(startX: startX, startY: startY, endX: endX, endY: cy, distance: width / 2)
		let endPoint = self.getCorrespondingPoint(startX: startX, startY: endY, endX: endX, endY: cy, distance: width / 2)
		let perpendicularCoordinates = self.getCorrespondingPoint(startX: endX, startY: cy, endX: startX, endY: startY, distance: width / 2)
		let slope = (perpendicularCoordinates[0].y - startPoint[1].y) / (perpendicularCoordinates[0].x - startPoint[1].x)
		let centerX = (cy - startPoint[1].y) / slope + startPoint[1].x

		let path = CGMutablePath()
		path.move(to: startPoint[1])
		path.addLine(to: CGPoint(x: centerX, y: cy))
		//        path.addLine(to: CGPoint(endX + width / 2, cy))
		path.addLine(to: endPoint[0])

		var controlPoint = self.getCorrespondingPoint(startX: startX, startY: endY, endX: endPoint[0].x, endY: endPoint[0].y, distance: width / 1.5)
		path.addQuadCurve(to: endPoint[1], control: controlPoint[0])
		path.addLine(to: CGPoint(x: endX - width / 2, y: cy))
		//        path.addLine(to: CGPoint(centerX, cy))
		path.addLine(to: startPoint[0])
		controlPoint = self.getCorrespondingPoint(startX: startX, startY: startY, endX: startPoint[0].x, endY: startPoint[0].y, distance: width / 1.5)
		path.addQuadCurve(to: startPoint[1], control: controlPoint[0])
		return path
		// return getOpenMarkerPath(startX: startX, startY: startY, endX: endX, endY: endY, cy: cy)
	}

	static func headendClassicMarker(width: CGFloat, markerWidth: CGFloat, markerHeight: CGFloat, startX: CGFloat, startY: CGFloat) -> CGMutablePath {
		let endX = startX - (markerWidth * width)
		let endY = startY + (markerHeight * width)
		let cy = startY + ((endY - startY) / 2)
		return self.getClassicMarkerPath(startX: startX, startY: startY, endX: endX, endY: endY, cy: cy, centerPoint: CGFloat(-0.4))
	}

	static func getClassicMarkerPath(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat, cy: CGFloat, centerPoint: CGFloat) -> CGMutablePath {
		var path = CGMutablePath()
		path = self.getOpenMarkerPath(startX: startX, startY: startY, endX: endX, endY: endY, cy: cy)
		path.addLine(to: CGPoint(x: startX + CGFloat(abs(startX - endX)) * centerPoint, y: cy))
		path.closeSubpath()
		return path
	}

	static func headendBlock(width: CGFloat, markerWidth: CGFloat, markerHeight: CGFloat, startX: CGFloat, startY: CGFloat, cap: CGLineCap = .butt) -> CGMutablePath {
		let endX = startX - (markerWidth * width)
		let endY = startY - (markerHeight * width)
		let cy = startY + ((endY - startY) / 2)
		let path = self.getOpenMarkerPath(startX: startX, startY: startY, endX: endX, endY: endY, cy: cy)
		path.closeSubpath()
		return path
	}

	static func getOpenMarkerPath(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat, cy: CGFloat) -> CGMutablePath {
		let path = CGMutablePath()
		path.move(to: CGPoint(x: startX, y: startY))
		path.addLine(to: CGPoint(x: endX, y: cy))
		path.addLine(to: CGPoint(x: startX, y: endY))
		return path
	}

	static func getMarkerSize(_ value: StrokeField.Size) -> CGFloat {
		switch value {
		case .medium:
			return CGFloat(3)
		case .narrow:
			return CGFloat(2)
		case .wide, .extraWide:
			return CGFloat(5)
		case .defMarkerSize:
			// not used as of now; handle appropriately in future
			return .zero
		}
	}

	static func getMiterLength(w: CGFloat, h: CGFloat) -> CGFloat {
		let theta = atan2(h * 0.5, w)
		let miterLenth = 1 / (2 * sin(theta))
		return miterLenth
	}

	func line(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		let path = CGMutablePath()
		if let stroke = stroke {
			let alpha = atan2(frame.height, frame.width)
			var headValueToBeReduced: CGFloat = 0
			var tailValueToBeReduced: CGFloat = 0
			if stroke.hasHeadend {
				headValueToBeReduced = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke)
			}
			if stroke.hasTailend {
				tailValueToBeReduced = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke)
			}
			path.move(to: CGPoint(x: frame.origin.x + headValueToBeReduced * cos(alpha), y: frame.origin.y + headValueToBeReduced * sin(alpha)))
			path.addLine(to: CGPoint(
				x: frame.origin.x + frame.size.width - tailValueToBeReduced * cos(alpha),
				y: frame.origin.y + frame.size.height - tailValueToBeReduced * sin(alpha)))
		}
		let textFrame = frame
		let animationFrame = frame
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func curveConnector2(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let distance = CGFloat(sqrt(w * w + h * h))

		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}
		//        if moveDistanceY > 1 {
		//            moveDistanceY = 1 / moveDistanceY * h
		//        }
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * w, y: y + moveDistance * h))
		path.addCurve(
			to: CGPoint(x: x + w - moveDistance * w, y: y + h - moveDistance * h),
			control1: CGPoint(x: x + midX, y: y + midY),
			control2: CGPoint(x: x + midX, y: y + midY))

		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func curveConnector3(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0

		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let width = (ch["width"] as? CGFloat) ?? 0.0

		// MARK: Unused

//		let height = (ch["height"] as? CGFloat) ?? 0.0
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []

		let x1 = _modifier[0] * width
		let x2 = x1 * 0.5
		let x3 = (x1 + w) * 0.5
		let h1 = h * 0.25
		let midY = h * 0.5
		let h2 = h * 0.75

		let distance = CGFloat(sqrt(x1 * x1))
		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}

		// MARK: Unused

//		var startPoint = CGPoint(x: x + moveDistance * x1, y: y)
//		var controlPoint1 = CGPoint(x: x + x2, y: y)
//		var controlPoint2 = CGPoint(x: x + x1, y: y + h1)
//		var endPoint = CGPoint(x: x + x1, y: y + midY)

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x1, y: y))
		//   path.move(to: CGPoint(x: x , y: y))
		// ***************************************************************************************************

		// MARK: Unused

//		let t = (moveDistance * x1) / sqrt(x2 * x2)

		// ***************************************************************************************************
		path.addCurve(to: CGPoint(x: x + x1, y: y + midY), control1: CGPoint(x: x + x2, y: y), control2: CGPoint(x: x + x1, y: y + h1))
		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}
		if modifiers[0] >= 0, modifiers[0] <= 1 {
			path.addCurve(
				to: CGPoint(x: x + w - moveDistance * x1, y: y + h),
				control1: CGPoint(x: x + x1, y: y + h2),
				control2: CGPoint(x: x + x3, y: y + h))
		} else {
			path.addCurve(
				to: CGPoint(x: x + w + moveDistance * x1, y: y + h),
				control1: CGPoint(x: x + x1, y: y + h2),
				control2: CGPoint(x: x + x3, y: y + h))
		}
		//    path.addCurve(to: CGPoint(x + w,y + h), control1: CGPoint(x + x1,y + h2), control2: CGPoint(x + x3,y + h))

		let handles = [CGPoint(x1, midY)]
		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func curveConnector4(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let width = (ch["width"] as? CGFloat) ?? 0.0
		let height = (ch["height"] as? CGFloat) ?? 0.0
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []
		let x2 = _modifier[0] * width
		let x1 = x2 * 0.5
		let x3 = (w + x2) * 0.5
		let x4 = (x2 + x3) * 0.5
		let x5 = (x3 + w) * 0.5
		let y4 = _modifier[1] * height
		let y1 = y4 * 0.5
		let y2 = y1 * 0.5
		let y3 = (y1 + y4) * 0.5
		let y5 = (h + y4) * 0.5
		var distance = CGFloat(sqrt(x2 * x2))
		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x2, y: y))
		//        path.move(to: CGPoint(x: x, y: y))
		path.addCurve(to: CGPoint(x: x + x2, y: y + y1), control1: CGPoint(x: x + x1, y: y), control2: CGPoint(x: x + x2, y: y + y2))
		path.addCurve(to: CGPoint(x: x + x3, y: y + y4), control1: CGPoint(x: x + x2, y: y + y3), control2: CGPoint(x: x + x4, y: y + y4))

		distance = CGFloat(sqrt(y4 * y4))
		if let stroke = stroke {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / CGFloat(sqrt(y4 * y4))
		}

		if modifiers[1] >= 0, modifiers[1] <= 1 {
			path.addCurve(
				to: CGPoint(x: x + w, y: y + h - moveDistance * y4),
				control1: CGPoint(x: x + x5, y: y + y4),
				control2: CGPoint(x: x + w, y: y + y5))
		} else {
			path.addCurve(
				to: CGPoint(x: x + w, y: y + h + moveDistance * y4),
				control1: CGPoint(x: x + x5, y: y + y4),
				control2: CGPoint(x: x + w, y: y + y5))
		}
		//        path.addCurve(to: CGPoint(x + w, y + h), control1: CGPoint(x + x5,y + y4), control2: CGPoint(x + w,y + y5))

		let handles = [CGPoint(x2, y1), CGPoint(x3, y4)]
		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func curveConnector5(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let (width, height) = ((ch["width"] as? CGFloat) ?? 0.0, (ch["height"] as? CGFloat) ?? 0.0)
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []
		let x3 = _modifier[0] * width
		let x6 = _modifier[2] * width
		let x1 = (x3 + x6) * 0.5
		let x2 = x3 * 0.5
		let x4 = (x3 + x1) * 0.5
		let x5 = (x6 + x1) * 0.5
		let x7 = (x6 + w) * 0.5
		let y4 = _modifier[1] * height
		let y1 = y4 * 0.5
		let y2 = y1 * 0.5
		let y3 = (y1 + y4) * 0.5
		let y5 = (h + y4) * 0.5
		let y6 = (y5 + y4) * 0.5
		let y7 = (y5 + h) * 0.5

		var distance = CGFloat(sqrt(x3 * x3))
		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x3, y: y))
		//        path.move(to: CGPoint(x: x , y: y))
		path.addCurve(to: CGPoint(x: x + x3, y: y + y1), control1: CGPoint(x: x + x2, y: y), control2: CGPoint(x: x + x3, y: y + y2))
		path.addCurve(to: CGPoint(x: x + x1, y: y + y4), control1: CGPoint(x: x + x3, y: y + y3), control2: CGPoint(x: x + x4, y: y + y4))
		path.addCurve(to: CGPoint(x: x + x6, y: y + y5), control1: CGPoint(x: x + x5, y: y + y4), control2: CGPoint(x: x + x6, y: y + y6))

		distance = CGFloat(sqrt(x6 * x6))
		if let stroke = stroke {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / CGFloat(sqrt(x6 * x6))
		}

		if modifiers[2] >= 0, modifiers[2] <= 1 {
			path.addCurve(
				to: CGPoint(x: x + w - moveDistance * x6, y: y + h),
				control1: CGPoint(x: x + x6, y: y + y7),
				control2: CGPoint(x: x + x7, y: y + h))
		} else {
			path.addCurve(
				to: CGPoint(x: x + w + moveDistance * x6, y: y + h),
				control1: CGPoint(x: x + x6, y: y + y7),
				control2: CGPoint(x: x + x7, y: y + h))
		}
		//        path.addCurve(to: CGPoint(x + w,y + h), control1: CGPoint(x + x6,y + y7), control2: CGPoint(x + x7,y + h))

		let handles = [CGPoint(x3, y1), CGPoint(x1, y4), CGPoint(x6, y5)]
		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func elbowConnector2(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		var moveDistanceY: CGFloat = 0.0
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let distance = CGFloat(sqrt(w * w))

		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
			moveDistanceY = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / CGFloat(sqrt(h * h))
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * w, y: y))
		path.addLine(to: CGPoint(x: x + w, y: y))
		path.addLine(to: CGPoint(x: x + w, y: y + h - moveDistanceY * h))

		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func elbowConnector3(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midY = h * 0.5
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let width = (ch["width"] as? CGFloat) ?? 0.0
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []
		let x1 = _modifier[0] * width
		let distance = CGFloat(sqrt(x1 * x1))

		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y + h))
		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}
		if modifiers[0] >= 0, modifiers[0] <= 1 {
			path.addLine(to: CGPoint(x: x + w - moveDistance * x1, y: y + h))
		} else {
			path.addLine(to: CGPoint(x: x + w + moveDistance * x1, y: y + h))
		}

		let handles = [CGPoint(x1, midY)]
		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func elbowConnector4(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let width = (ch["width"] as? CGFloat) ?? 0.0
		let height = (ch["height"] as? CGFloat) ?? 0.0
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []
		let x1 = _modifier[0] * width
		let y1 = _modifier[1] * height
		let distance = CGFloat(sqrt(x1 * x1))
		let y2 = y1 * 0.5
		let x2 = (x1 + w) * 0.5

		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y + y1))
		path.addLine(to: CGPoint(x: x + w, y: y + y1))
		if let stroke = stroke {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / CGFloat(sqrt(y1 * y1))
		}
		//        if modifier[0] >= 0 && modifier[0] <= 1 {
		//            path.addLine(to: CGPoint(x + w - moveDistance * (x1), y + y1))
		//        } else {
		//            path.addLine(to: CGPoint(x + w + moveDistance * (x1), y + y1))
		//        }
		if modifiers[1] >= 0, modifiers[1] <= 1 {
			path.addLine(to: CGPoint(x: x + w, y: y + h - moveDistance * y1))
		} else {
			path.addLine(to: CGPoint(x: x + w, y: y + h + moveDistance * y1))
		}

		let handles = [CGPoint(x1, y2), CGPoint(x2, y1)]
		let animationFrame = frame
		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}

	func elbowConnector5(frame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		var moveDistance: CGFloat = 0.0
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ch = self.zeroCheck(modifiers: modifiers, maxX: w, maxY: h)
		let width = (ch["width"] as? CGFloat) ?? 0.0
		let height = (ch["height"] as? CGFloat) ?? 0.0
		let _modifier = (ch["modifiers"] as? [CGFloat]) ?? []
		let x1 = _modifier[0] * width
		let y2 = _modifier[1] * height
		let x3 = _modifier[2] * width
		let x2 = (x1 + x3) * 0.5
		let y1 = y2 * 0.5
		let y3 = (h + y2) * 0.5

		// MARK: Unused

//		let x2 = (x1 + x3) * 0.5
//		let y1 = y2 * 0.5
//		let y3 = (h + y2) * 0.5
		var distance = CGFloat(sqrt(x1 * x1))

		if let stroke = stroke, distance != 0 {
			moveDistance = self.getValueToReduce(marker: stroke.headend, strokeWidth: CGFloat(stroke.width), cap: stroke) / distance
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + moveDistance * x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y))
		path.addLine(to: CGPoint(x: x + x1, y: y + y2))
		path.addLine(to: CGPoint(x: x + x3, y: y + y2))
		path.addLine(to: CGPoint(x: x + x3, y: y + h))
		distance = CGFloat(sqrt(x3 * x3))
		if let stroke = stroke {
			moveDistance = self.getValueToReduce(marker: stroke.tailend, strokeWidth: CGFloat(stroke.width), cap: stroke) / CGFloat(sqrt(x3 * x3))
		}

		if modifiers[2] >= 0, modifiers[2] <= 1 {
			path.addLine(to: CGPoint(x: x + w - moveDistance * x3, y: y + h))
		} else {
			path.addLine(to: CGPoint(x: x + w + moveDistance * x3, y: y + h))
		}

		let textContainerRect = CGRect(x: x, y: y, width: w, height: h)
		let handles = [CGPoint(x1, y1), CGPoint(x2, y2), CGPoint(x3, y3)]
		let animationFrame = frame
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textContainerRect, pathFrame: frame, animationFrame: animationFrame)
	}
}

// swiftlint:enable file_length
