//
//  Preset+SmartElements.swift
//  Painter
//
//  Created by Meenatchi Ramanathan on 24/10/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// swiftlint:disable file_length
extension Preset {
	func meterNeedle(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midY = h * 0.5
		let midX = w * 0.5
		let angle1: CGFloat = modifiers[0]
		let angle2: CGFloat = angle1 - .pi / 2
		let angle3 = angle1 + .pi / 2
		let rx1 = w * 0.5
		let ry1 = h * 0.5
		let rx2 = 0.05 * rx1
		let ry2 = 0.05 * ry1
		let h1 = getEllipseCoordinates(angle1: angle1, angle2: -1_000, rx: rx1, ry: ry1, mid: CGPoint(midX, midY))
		let i1 = getEllipseCoordinates(angle1: angle2, angle2: angle3, rx: rx2, ry: ry2, mid: CGPoint(midX, midY))
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + h1[0], y: y + h1[1]))
		path.addLine(to: CGPoint(x: x + i1[2], y: y + i1[3]))

		let topY = ((i1[1] + i1[3]) / 2) - ry2
		let topX = ((i1[0] + i1[2]) / 2) - rx2
		let ny1 = i1[3] - topY
		let ny2 = i1[1] - topY
		let nx1 = i1[2] - topX
		let nx2 = i1[0] - topX
		self.addEllipseCurve(x1: nx1, y1: ny1, x2: nx2, y2: ny2, rx: rx2, ry: ry2, path: path, frame: frame)

		path.addLine(to: CGPoint(x: x + i1[0], y: y + i1[1]))
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func clockNeedle(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var modifiersInRadians: [Float] = []
		for modifier in modifiers {
			modifiersInRadians.append(Float(modifier) * (Float.pi / 180))
		}
		let midY = h * 0.5
		let midX = w * 0.5
		let ry = midY
		let rx = midX

		let angle1 = CGFloat(modifiersInRadians[0])
		let angle1a: CGFloat = angle1 - .pi / 2
		let angle1b: CGFloat = angle1 + .pi / 2
		let angle2 = CGFloat(modifiersInRadians[1])
		let angle2a: CGFloat = angle2 - .pi / 2
		let angle2b: CGFloat = angle2 + .pi / 2
		let angle3 = CGFloat(modifiersInRadians[2])

		let angle1Ext = CGFloat(modifiersInRadians[0] + .pi)
		let angle1Exta: CGFloat = angle1 - .pi / 2
		let angle1Extb: CGFloat = angle1 + .pi / 2
		let angle2Ext = CGFloat(modifiersInRadians[1] + .pi)
		let angle2Exta: CGFloat = angle2 - .pi / 2
		let angle2Extb: CGFloat = angle2 + .pi / 2
		let angle3Ext = CGFloat(modifiersInRadians[2] + .pi)
		let angle3Exta: CGFloat = angle3 - .pi / 2
		let angle3Extb: CGFloat = angle3 + .pi / 2

		let rxM = 0.9 * rx
		let ryM = 0.9 * ry

		let rxH = 0.5 * rx
		let ryH = 0.5 * ry

		let rxWid = 0.006 * rx
		let ryWid = 0.006 * ry

		let rxExt = 0.2 * rx
		let ryExt = 0.2 * ry

		let rxS = 0.95 * rx
		let ryS = 0.95 * ry

		let mnt = getEllipseCoordinates(angle1: angle1, angle2: -1_000, rx: rxM, ry: ryM, mid: CGPoint(midX, midY))
		let hr = getEllipseCoordinates(angle1: angle2, angle2: -1_000, rx: rxH, ry: ryH, mid: CGPoint(midX, midY))
		let sec = getEllipseCoordinates(angle1: angle3, angle2: -1_000, rx: rxS, ry: ryS, mid: CGPoint(midX, midY))
		let mnta = getEllipseCoordinates(angle1: angle1a, angle2: angle1b, rx: rxWid, ry: ryWid, mid: CGPoint(mnt[0], mnt[1]))
		let hra = getEllipseCoordinates(angle1: angle2a, angle2: angle2b, rx: rxWid, ry: ryWid, mid: CGPoint(hr[0], hr[1]))
		let mntExt = getEllipseCoordinates(angle1: angle1Ext, angle2: -1_000, rx: rxExt, ry: ryExt, mid: CGPoint(midX, midY))
		let hrExt = getEllipseCoordinates(angle1: angle2Ext, angle2: -1_000, rx: rxExt, ry: ryExt, mid: CGPoint(midX, midY))
		let secExt = getEllipseCoordinates(angle1: angle3Ext, angle2: -1_000, rx: rxExt, ry: ryExt, mid: CGPoint(midX, midY))

		let mntExta = getEllipseCoordinates(angle1: angle1Exta, angle2: angle1Extb, rx: rxWid, ry: ryWid, mid: CGPoint(mntExt[0], mntExt[1]))
		_ = getEllipseCoordinates(angle1: angle1Exta, angle2: angle1Extb, rx: rxWid, ry: ryWid, mid: CGPoint(midX, midY))

		let hrExta = getEllipseCoordinates(angle1: angle2Exta, angle2: angle2Extb, rx: rxWid, ry: ryWid, mid: CGPoint(hrExt[0], hrExt[1]))
		_ = getEllipseCoordinates(angle1: angle2Exta, angle2: angle2Extb, rx: rxWid, ry: ryWid, mid: CGPoint(midX, midY))

		let secExta = getEllipseCoordinates(angle1: angle3Exta, angle2: angle3Extb, rx: rxWid, ry: ryWid, mid: CGPoint(secExt[0], secExt[1]))
		_ = getEllipseCoordinates(angle1: angle3Exta, angle2: angle3Extb, rx: rxWid, ry: ryWid, mid: CGPoint(midX, midY))

		let path = CGMutablePath()
		path.addLines(between: [CGPoint(x: x + mnta[0], y: y + mnta[1]), CGPoint(x: x + mnta[2], y: y + mnta[3]), CGPoint(x: x + mntExta[2], y: y + mntExta[3]), CGPoint(x: x + mntExta[0], y: y + mntExta[1])])
		path.closeSubpath()

		let path1 = CGMutablePath()
		path1.addLines(between: [CGPoint(x: x + hra[0], y: y + hra[1]), CGPoint(x: x + hra[2], y: y + hra[3]), CGPoint(x: x + hrExta[2], y: y + hrExta[3]), CGPoint(x: x + hrExta[0], y: y + hrExta[1])])
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.addLines(between: [CGPoint(x: x + sec[0], y: y + sec[1]), CGPoint(x: x + secExta[0], y: y + secExta[1]), CGPoint(x: x + secExta[2], y: y + secExta[3])])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.addLines(between: [CGPoint(x: x + mnta[0], y: y + mnta[1]), CGPoint(x: x + mnta[2], y: y + mnta[3]), CGPoint(x: x + mntExta[2], y: y + mntExta[3]), CGPoint(x: x + mntExta[0], y: y + mntExta[1])])
		path3.closeSubpath()

		let path3_1 = CGMutablePath()
		path3_1.addLines(between: [CGPoint(x: x + hra[0], y: y + hra[1]), CGPoint(x: x + hra[2], y: y + hra[3]), CGPoint(x: x + hrExta[2], y: y + hrExta[3]), CGPoint(x: x + hrExta[0], y: y + hrExta[1])])
		path3_1.closeSubpath()

		let path3_2 = CGMutablePath()
		path3_2.addLines(between: [CGPoint(x: x + sec[0], y: y + sec[1]), CGPoint(x: x + secExta[0], y: y + secExta[1]), CGPoint(x: x + secExta[2], y: y + secExta[3])])
		path3_2.closeSubpath()

		let pathArray = [path, path1, path2, path3, path3_1, path3_2]
		let pathProps = [1, 2, 3, 4, 4, 4]
		let textFrame = CGRect(x: x + w * 0.7, y: y + h * 0.3, width: w * 0.1, height: h * 0.1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps, connectors: connector)
	}

	func timerScale(frame: CGRect) -> PresetPathInfo {
		let path = CGMutablePath()
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let modifiers = presetModifiers
		if modifiers.isEmpty == false {
			let midX = w * 0.5
			let midY = h * 0.5
			let rx = midX
			let ry = midY
			let rx2 = 0.9 * rx
			let ry2 = 0.9 * ry
			let rx3 = 0.8 * rx
			let ry3 = 0.8 * ry

			var n = floor(modifiers[0] * (180.0 / .pi))
			let t = floor(modifiers[1] * (180.0 / .pi))
			while n <= t {
				let rad1 = (n * .pi / 180.0)
				let a = getEllipseCoordinates(angle1: rad1, angle2: -1_000, rx: rx, ry: ry, mid: CGPoint(midX, midY))
				var a1: [CGFloat] = []
				if Int(n.truncatingRemainder(dividingBy: 30)) == 0 {
					a1 = getEllipseCoordinates(angle1: rad1, angle2: -1_000, rx: rx3, ry: ry3, mid: CGPoint(midX, midY))
				} else {
					a1 = getEllipseCoordinates(angle1: rad1, angle2: -1_000, rx: rx2, ry: ry2, mid: CGPoint(midX, midY))
				}
				path.move(to: CGPoint(x: x + a[0], y: y + a[1]))
				path.addLine(to: CGPoint(x: x + a1[0], y: y + a1[1]))
				n += 6
			}
		} else {
			var n: Double = 0
			while n <= 100 {
				if Int(n.truncatingRemainder(dividingBy: 10)) == 0 {
					path.move(to: CGPoint(x: x, y: y + CGFloat(n) / 100 * h))
					path.addLine(to: CGPoint(x: x + w, y: y + (CGFloat(n) / 100 * h)))
				} else {
					path.move(to: CGPoint(x: x, y: y + CGFloat(n) / 100 * h))
					path.addLine(to: CGPoint(x: x + 0.75 * w, y: y + (CGFloat(n) / 100 * h)))
				}
				n += 5
			}
		}
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func horizontalSlider(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height

		let xlen = w * modifiers[1]
		let ylen = h
		let sx = xlen / 2
		let ex = w - xlen / 2
		let sliderLen = ex - sx

		let rx = xlen * 0.5
		let ry = ylen * 0.5
		let midX = rx
		let midY = ry
		let posX = modifiers[0] * sliderLen

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + posX, y: y + midY))
		path.addEllipse(in: CGRect(x: x + posX + midX - rx, y: y + midY - ry, width: 2 * rx, height: 2 * ry))
		path.closeSubpath()

		let textFrame = CGRect(x: x + posX, y: y, width: posX + xlen - posX, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func verticalSlider(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let xlen = w
		let ylen = h * 0.1
		let sliderHeight = h
		let mod = (1 - modifiers[0])
		let posY = mod * sliderHeight

		let midX = xlen * 0.5
		let midY = posY
		let rx = midX
		let ry = ylen / 2
		let angle = (45 * .pi / 180.0)
		let dx = rx * CGFloat(cos(angle))
		let dy = ry * CGFloat(sin(angle))

		let x1 = midX + dx
		let y1 = midY - dy

		let x2 = midX + dx
		let y2 = midY + dy

		let path = CGMutablePath()

		path.move(to: CGPoint(x: x + x2, y: y + y2))
		let topY = ((y1 + y2) / 2) - ry
		let ny1 = y1 - topY
		let ny2 = y2 - topY
		self.addEllipseCurve(x1: x2, y1: ny2, x2: x1, y2: ny1, rx: rx, ry: ry, path: path, frame: frame)

		var c = toCubicControlPoints(p1: CGPoint(x1, y1), cx1: x1 + dx / 2, cy1: y1 + dy / 2, p2: CGPoint(x1 + dx, y1 + dy))
		path.addCurve(to: CGPoint(x: x + x1 + dx, y: y + y1 + dy), control1: CGPoint(x: x + c[0], y: y + c[1]), control2: CGPoint(x: x + c[2], y: y + c[3]))
		c = toCubicControlPoints(p1: CGPoint(x1 + dx, y1 + dy), cx1: x1 + dx / 2, cy1: y2 - dy / 2, p2: CGPoint(x2, y2))
		path.addCurve(to: CGPoint(x: x + x2, y: y + y2), control1: CGPoint(x: x + c[0], y: y + c[1]), control2: CGPoint(x: x + c[2], y: y + c[3]))
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y + posY - ylen / 2, width: xlen, height: ylen)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func modRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let mMaxX = modifiers[0] * w
		let mMaxY = h - (modifiers[1] * h)

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y + h))
		path.addLine(to: CGPoint(x: x + mMaxX, y: y + h))
		path.addLine(to: CGPoint(x: x + mMaxX, y: y + mMaxY))
		path.addLine(to: CGPoint(x: x, y: y + mMaxY))
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func modCan(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f0 = 0.25 * w
		let y1 = f0 * 0.5
		let y3 = h - y1
		let mMaxY = modifiers[0] * (h - 2 * y1)
		let y4 = h - y1 - mMaxY
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y + y4))
		path.addLine(to: CGPoint(x: x, y: y + y3))

		var controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + h), framePoint2: CGPoint(x: x, y: y + y3), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path.addCurve(to: CGPoint(x: x + midX, y: y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + y3), framePoint2: CGPoint(x: x + midX, y: y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path.addCurve(to: CGPoint(x: x + w, y: y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path.addLine(to: CGPoint(x: x + w, y: y + y4))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + y4), framePoint2: CGPoint(x: x + midX, y: y + y4 + y1), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path.addCurve(to: CGPoint(x: x + midX, y: y + y4 + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + y4 + y1), framePoint2: CGPoint(x: x, y: y + y4), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path.addCurve(to: CGPoint(x: x, y: y + y4), control1: controlPoint[0], control2: controlPoint[1])

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x, y: y + y4))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x, y: y + y4), framePoint2: CGPoint(x: x + midX, y: y + y4 - y1), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x: x + midX, y: y + y4 - y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + y4 - y1), framePoint2: CGPoint(x: x + w, y: y + y4), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x: x + w, y: y + y4), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + y4), framePoint2: CGPoint(x: x + midX, y: y + y4 + y1), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x: x + midX, y: y + y4 + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + y4 + y1), framePoint2: CGPoint(x: x, y: y + y4), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x: x, y: y + y4), control1: controlPoint[0], control2: controlPoint[1])

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x, y: y + y4))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x, y: y + y4), framePoint2: CGPoint(x: x + midX, y: y + y4 - y1), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x + midX, y: y + y4 - y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + y4 - y1), framePoint2: CGPoint(x: x + w, y: y + y4), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x + w, y: y + y4), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + y4), framePoint2: CGPoint(x: x + midX, y: y + y4 + y1), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x + midX, y: y + y4 + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + y4 + y1), framePoint2: CGPoint(x: x, y: y + y4), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x, y: y + y4), control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x: x, y: y + y3))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + midX, y: y + h), framePoint2: CGPoint(x: x, y: y + y3), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x + midX, y: y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + y3), framePoint2: CGPoint(x: x + midX, y: y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x: x + w, y: y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path2.addLine(to: CGPoint(x: x + w, y: y + y4))

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let pathProps = [1, 2, 3]
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path, path1, path2], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps, connectors: connector)
	}

	func modParallelogram(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = modifiers[0]
		let f1 = a * w * 0.5
		let f0 = w - f1
		let f2 = w * 0.5 - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + f0, y: y))
		path.addLine(to: CGPoint(x: x + w, y: y))
		path.addLine(to: CGPoint(x: x + (w * 0.5), y: y + h))
		path.addLine(to: CGPoint(x: x + f2, y: y + h))
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func man(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var pathArray: [Any] = ["M", 73.0, 19.0, "C", 73.0, 24.6, 69.0, 30.1, 64.0, 30.1, "S", 55.0, 24.6, 55.0, 19.0, "S", 59.0, 8.9, 64.0, 8.9, "S", 73.0, 13.4, 73.0, 19.0, "z", "M", 96.3, 59.3, "L", 78.0, 27.0, "L", 78.0, 27.0, "L", 78.0, 27.0, "L", 73.3, 27.0, "C", 71.1, 30.0, 67.7, 32.0, 64.0, 32.0, "S", 56.9, 30.0, 54.7, 27.0, "L", 50.0, 27.0, "L", 50.0, 27.0, "L", 31.8, 59.3, "C", 30.6, 61.8, 31.7, 64.8, 34.2, 65.899_999_999_999_99, "C", 36.7, 67.1, 39.7, 65.999_999_999_999_99, 40.800_000_000_000_004, 63.499_999_999_999_99, "L", 49.0, 49.4, "L", 48.0, 73.0, "L", 80.0, 73.0, "L", 79.0, 49.3, "L", 87.2, 63.5, "C", 88.4, 66.0, 91.3, 67.1, 93.8, 65.9, "C", 96.4, 64.8, 97.4, 61.8, 96.3, 59.3, "z", "M", 57.0, 119.0, "L", 57.0, 119.0, "C", 59.8, 119.0, 62.0, 116.8, 62.0, 114.0, "L", 63.0, 75.0, "L", 51.0, 75.0, "L", 52.0, 114.0, "C", 52.0, 116.8, 54.2, 119.0, 57.0, 119.0, "z", "M", 71.0, 119.0, "L", 71.0, 119.0, "C", 73.8, 119.0, 76.0, 116.8, 76.0, 114.0, "L", 77.0, 75.0, "L", 65.0, 75.0, "L", 66.0, 114.0, "C", 66.0, 116.8, 68.2, 119.0, 71.0, 119.0, "z"]
		let finalPaths = self.pathForSize(pathArray: &pathArray, reqX: w, reqY: h, actX: 128, actY: 128, xOrigin: x, yOrigin: y)
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let pathProps = [1, 1, 1, 1]
		return PresetPathInfo(paths: finalPaths, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps)
	}

	func woman(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var pathArray: [Any] = ["M", 72.0, 20.6, "C", 72.0, 25.6, 68.4, 30.5, 64.0, 30.5, "S", 56.0, 25.6, 56.0, 20.6, "S", 59.6, 11.600_000_000_000_001, 64.0, 11.600_000_000_000_001, "S", 72.0, 15.6, 72.0, 20.6, "z", "M", 94.8, 53.9, "L", 76.0, 27.1, "L", 76.0, 27.1, "L", 76.0, 27.0, "L", 72.3, 27.0, "C", 70.1, 30.0, 67.7, 32.0, 64.0, 32.0, "S", 57.9, 30.0, 55.7, 27.0, "L", 52.0, 27.0, "L", 52.0, 27.0, "L", 33.7, 54.3, "C", 32.1, 56.5, 32.6, 59.699_999_999_999_996, 34.800_000_000_000_004, 61.3, "C", 37.000_000_000_000_01, 62.9, 40.2, 62.4, 41.800_000_000_000_004, 60.199_999_999_999_996, "L", 52.0, 46.4, "L", 52.0, 51.0, "L", 40.0, 80.0, "L", 88.0, 80.0, "L", 76.0, 51.0, "L", 76.0, 45.9, "L", 86.8, 59.9, "C", 88.5, 62.1, 91.6, 62.5, 93.8, 60.9, "C", 96.0, 59.2, 96.4, 56.1, 94.8, 53.9, "z", "M", 57.0, 116.0, "L", 57.0, 116.0, "C", 59.8, 116.0, 62.0, 113.8, 62.0, 111.0, "L", 63.0, 82.0, "L", 51.0, 82.0, "L", 52.0, 111.0, "C", 52.0, 113.8, 54.2, 116.0, 57.0, 116.0, "z", "M", 71.0, 116.0, "L", 71.0, 116.0, "C", 73.8, 116.0, 76.0, 113.8, 76.0, 111.0, "L", 77.0, 82.0, "L", 65.0, 82.0, "L", 66.0, 111.0, "C", 66.0, 113.8, 68.2, 116.0, 71.0, 116.0, "z"]
		let finalPaths = self.pathForSize(pathArray: &pathArray, reqX: w, reqY: h, actX: 128, actY: 128, xOrigin: x, yOrigin: y)
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let pathProps = [1, 1, 1, 1]
		return PresetPathInfo(paths: finalPaths, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps)
	}

	func modRoundRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height

		let xlen = w
		let ylen = h
		let start = modifiers.count > 1 ? modifiers[1] : 0
		let end = modifiers.count > 2 ? modifiers[2] : 1
		let mod = start + (end - start) * modifiers[0]
		var percentage = (mod > 0.1 ? 0.1 : mod) * 5
		let angle1 = .pi * (1 - percentage)
		let angle2 = .pi * (1 + percentage)
		var rx = xlen * 0.1
		var ry = ylen * 0.5
		let midX = xlen * 0.1
		let midY = ylen * 0.5
		let a = getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
		var x1 = a[0]
		var y1 = a[1]
		var x2 = a[2]
		var y2 = a[3]

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + x1, y: y + y1))
		path.addLine(to: CGPoint(x: x + x1, y: y + y1))

		var controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + x1, y: y + y1), framePoint2: CGPoint(x: x, y: y + ry), startAngle: 0.5 * .pi, endAngle: .pi, rx: x1, ry: y1 - ry)
		path.addCurve(to: CGPoint(x: x, y: y + ry), control1: controlPoint[0], control2: controlPoint[1])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x, y: y + ry), framePoint2: CGPoint(x: x + x2, y: y + y2), startAngle: .pi, endAngle: 1.5 * .pi, rx: x2, ry: ry - y2)
		path.addCurve(to: CGPoint(x: x + x2, y: y + y2), control1: controlPoint[0], control2: controlPoint[1])

		let x3 = (mod >= 0.9) ? 0.9 * xlen : mod * xlen
		let y3 = 0

		if mod > 0.1 {
			path.addLine(to: CGPoint(x: x + x3, y: y + CGFloat(y3)))
		}
		if mod > 0.9 {
			percentage = (mod - 0.9) * 10
			rx = xlen * 0.1 * percentage
			ry = ylen * 0.5
			x1 = 0.9 * xlen
			y1 = 0
			x2 = 0.9 * xlen
			y2 = ylen

			var m1 = atan2((y1 - ry) * (rx / ry), x1 - rx)
			if m1 < 0 {
				m1 += 2 * .pi
			}
			var m2 = atan2((y2 - ry) * (rx / ry), x2 - rx)
			if m2 < 0 {
				m2 += 2 * .pi
			}
			controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + x1, y: y + y1), framePoint2: CGPoint(x: x + w, y: y + ry), startAngle: 1.5 * .pi, endAngle: 0, rx: rx, ry: ry)
			path.addCurve(to: CGPoint(x: x + w, y: y + ry), control1: controlPoint[0], control2: controlPoint[1])
			controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + w, y: y + ry), framePoint2: CGPoint(x: x + x2, y: y + y2), startAngle: 0, endAngle: 0.5 * .pi, rx: rx, ry: ry)
			path.addCurve(to: CGPoint(x: x + x2, y: y + y2), control1: controlPoint[0], control2: controlPoint[1])
		} else if mod > 0.1 {
			path.addLine(to: CGPoint(x: x + x3, y: y + ylen))
		}
		path.closeSubpath()
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func ellipseFiller(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let xlen = w * 0.3
		let ylen = h * 0.03
		let sliderHeight = h
		let posY = sliderHeight * (1 - modifiers[0])
		let posX = w * 0.5
		let x1 = posX
		let y1 = posY - ylen * 0.5
		let x2 = posX + xlen
		let y2 = posY
		let x3 = posX
		let y3 = posY + ylen * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x + x1, y: y + y1))
		path.addLine(to: CGPoint(x: x + x2, y: y + y2))
		path.addLine(to: CGPoint(x: x + x3, y: y + y3))
		path.closeSubpath()

		let x4 = w * 0.3
		let textFrame = CGRect(x: x, y: y + y1, width: x4, height: y3 - y1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func circleFiller(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let percentage = modifiers[0]
		let angle1 = .pi * (1 - percentage) + (percentage == 0 ? -0.000_01 : (percentage == 1 ? 0.000_01 : 0))
		let angle2 = .pi * (1 + percentage) + (percentage == 0 ? 0.000_01 : (percentage == 1 ? -0.000_01 : 0))

		let midX = w * 0.5
		let midY = h * 0.5
		let a = getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]

		let path = CGMutablePath()
		// addfiller
		path.move(to: CGPoint(x: x + x1, y: y + y1))
		path.addLine(to: CGPoint(x: x + x1, y: y + y1))
		self.addEllipseCurve(x1: x1, y1: y1, x2: x2, y2: y2, rx: midX, ry: midY, path: path, frame: frame)
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func pathForSize(pathArray: inout [Any], reqX: CGFloat, reqY: CGFloat, actX: CGFloat, actY: CGFloat, xOrigin: CGFloat, yOrigin: CGFloat) -> [CGPath] {
		var finalPaths: [CGMutablePath] = []
		var lastControlPoint = CGPoint.zero
		var reflectionPoint = CGPoint.zero
		var path = CGMutablePath()
		var i = 0
		while i < pathArray.count {
			if let pathType = pathArray[i] as? String, pathType == "M" {
				if let point1 = (pathArray[i + 1] as? Double), let point2 = pathArray[i + 2] as? Double {
					let p1 = CGFloat(point1) * reqX / actX
					let p2 = CGFloat(point2) * reqY / actY
					path.move(to: CGPoint(x: xOrigin + p1, y: yOrigin + p2))
					i += 3
				}
			} else if let pathType = pathArray[i] as? String, pathType == "C" {
				var ellipsePoints = [CGFloat](repeating: 0, count: 6)
				for j in 1..<7 {
					if let point = pathArray[i + j] as? Double {
						if j.isMultiple(of: 2) {
							ellipsePoints[j - 1] = CGFloat(point) * reqY / actY
						} else {
							ellipsePoints[j - 1] = CGFloat(point) * reqX / actX
						}
					}
				}
				path.addCurve(to: CGPoint(xOrigin + ellipsePoints[4], yOrigin + ellipsePoints[5]), control1: CGPoint(xOrigin + ellipsePoints[0], yOrigin + ellipsePoints[1]), control2: CGPoint(xOrigin + ellipsePoints[2], yOrigin + ellipsePoints[3]))
				lastControlPoint = CGPoint(xOrigin + ellipsePoints[2], yOrigin + ellipsePoints[3])
				reflectionPoint = self.findReflectionPointFor(origPoint: lastControlPoint, aboutPoint: CGPoint(xOrigin + ellipsePoints[4], yOrigin + ellipsePoints[5]))
				i += 7
			} else if let pathType = pathArray[i] as? String, pathType == "S" {
				var ellipsePoints = [CGFloat](repeating: 0, count: 4)
				for j in 1..<5 {
					if let point = pathArray[i + j] as? Double {
						if j.isMultiple(of: 2) {
							ellipsePoints[j - 1] = CGFloat(point) * reqY / actY
						} else {
							ellipsePoints[j - 1] = CGFloat(point) * reqX / actX
						}
					}
				}
				path.addCurve(to: CGPoint(xOrigin + ellipsePoints[2], yOrigin + ellipsePoints[3]), control1: reflectionPoint, control2: CGPoint(xOrigin + ellipsePoints[0], yOrigin + ellipsePoints[1]))
				lastControlPoint = CGPoint(xOrigin + ellipsePoints[0], yOrigin + ellipsePoints[1])
				reflectionPoint = self.findReflectionPointFor(origPoint: lastControlPoint, aboutPoint: CGPoint(xOrigin + ellipsePoints[2], yOrigin + ellipsePoints[3]))
				i += 5
			} else if let pathType = pathArray[i] as? String, pathType == "A" {
				var ellipsePoints = [CGFloat](repeating: 0, count: 6)
				for j in 1..<7 {
					if let point = pathArray[i + j] as? Double {
						if j.isMultiple(of: 2) {
							ellipsePoints[j - 1] = CGFloat(point) * reqY / actY
						} else {
							ellipsePoints[j - 1] = CGFloat(point) * reqX / actX
						}
					}
				}
				self.addEllipseCurve(x1: xOrigin + ellipsePoints[2], y1: yOrigin + ellipsePoints[3], x2: xOrigin + ellipsePoints[4], y2: yOrigin + ellipsePoints[5], rx: ellipsePoints[0], ry: ellipsePoints[1], path: path, frame: CGRect(x: xOrigin, y: yOrigin, width: ellipsePoints[0], height: ellipsePoints[1]))

				i += 7
			} else if let pathType = pathArray[i] as? String, pathType == "L" {
				if let point1 = pathArray[i + 1] as? Double, let point2 = pathArray[i + 2] as? Double {
					let p1 = CGFloat(point1) * reqX / actX
					let p2 = CGFloat(point2) * reqY / actY
					path.addLine(to: CGPoint(x: xOrigin + p1, y: yOrigin + p2))
					i += 3
				}
			} else if let pathType = pathArray[i] as? String, pathType == "z" {
				path.closeSubpath()
				finalPaths.append(path)
				path = CGMutablePath()
				i += 1
			} else {
				i += 1
			}
		}
		return finalPaths
	}

	func addEllipseCurve(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, rx: CGFloat, ry: CGFloat, path: CGMutablePath, frame: CGRect) {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var m1 = atan2((y1 - ry) * (rx / ry), x1 - rx)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		var m2 = atan2((y2 - ry) * (rx / ry), x2 - rx)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		let sweepAngle = m2 - m1
		var startAngle = m1, endAngle = m2
		var framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)
		var quadrantNumber: CGFloat, fullQuadrant: CGFloat, endQuadrantNumber: CGFloat, startQuadrantNumber: CGFloat
		var controlPoint: [CGPoint]

		if m1 >= 0, m1 < .pi / 2 {
			startQuadrantNumber = 1
		} else if m1 >= .pi / 2, m1 < .pi {
			startQuadrantNumber = 2
		} else if m1 >= .pi, m1 < 3 * .pi / 2 {
			startQuadrantNumber = 3
		} else {
			startQuadrantNumber = 4
		}

		if m2 >= 0, m2 < .pi / 2 {
			endQuadrantNumber = 1
		} else if m2 >= .pi / 2, m2 < .pi {
			endQuadrantNumber = 2
		} else if m2 >= .pi, m2 < 3 * .pi / 2 {
			endQuadrantNumber = 3
		} else {
			endQuadrantNumber = 4
		}

		if sweepAngle >= 0 {
			fullQuadrant = endQuadrantNumber - startQuadrantNumber - 1
		} else {
			fullQuadrant = 4 - startQuadrantNumber + endQuadrantNumber - 1
		}
		quadrantNumber = startQuadrantNumber

		// first incomplete quadrant
		if endQuadrantNumber != quadrantNumber, sweepAngle >= 0 {
			endAngle = quadrantNumber * .pi / 2

			framePoint1.x = x + w * 0.5 + rx * cos(m1)
			framePoint1.y = y + h * 0.5 + ry * sin(m1)

			framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
			framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			framePoint1.x = x + w * 0.5 + rx * cos(m1)
			framePoint1.y = y + h * 0.5 + ry * sin(m1)

			framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
			framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		// full quadrants
		quadrantNumber += 1

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)

			framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
			framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

			fullQuadrant -= 1
			quadrantNumber += 1
		}

		// last quadrant
		if sweepAngle >= 0 {
			if endQuadrantNumber != startQuadrantNumber {
				framePoint1 = framePoint2
				startAngle = endAngle
				endAngle = m2
			} else {
				startAngle = m1
				framePoint1.x = x + w * 0.5 + rx * cos(m1)
				framePoint1.y = y + h * 0.5 + ry * sin(m1)
				endAngle = m2
			}
			framePoint2.x = x + w * 0.5 + rx * cos(m2)
			framePoint2.y = y + h * 0.5 + ry * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		} else {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = m2

			framePoint2.x = x + w * 0.5 + rx * cos(m2)
			framePoint2.y = y + h * 0.5 + ry * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}
	}

	func findReflectionPointFor(origPoint: CGPoint, aboutPoint: CGPoint) -> CGPoint {
		var reflectionPoint = CGPoint.zero
		if aboutPoint.x == origPoint.x {
			reflectionPoint.x = aboutPoint.x
		} else if aboutPoint.x < origPoint.x {
			reflectionPoint.x = aboutPoint.x - (origPoint.x - aboutPoint.x)
		} else {
			reflectionPoint.x = aboutPoint.x + (aboutPoint.x - origPoint.x)
		}
		if aboutPoint.y == origPoint.y {
			reflectionPoint.y = aboutPoint.y
		} else if aboutPoint.y < origPoint.y {
			reflectionPoint.y = aboutPoint.y - (origPoint.y - aboutPoint.y)
		} else {
			reflectionPoint.y = aboutPoint.y + (aboutPoint.y - origPoint.y)
		}
		return reflectionPoint
	}
}

// swiftlint:enable file_length
