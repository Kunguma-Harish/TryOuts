//
//  Preset+BasicShapes.swift
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
	func checkBraceMax(width: CGFloat, height: CGFloat, modifiers: [CGFloat]) -> [CGFloat] {
		let yy = modifiers[1] * height
		let ty = height - yy
		var max: CGFloat
		if ty < yy {
			max = (ty * 0.5) / height
		} else {
			max = (yy * 0.5) / height
		}
		let y1 = getCoordinates(modifiers[0], Width: width, Height: height, Percent: max, Type: "y")
		return [yy, y1]
	}

	func getRectCoordinates(width: CGFloat, height: CGFloat, modifiers: [CGFloat]) -> [CGFloat] {
		var values = [CGFloat]()
		if !modifiers.isEmpty {
			let a = getCoordinates(modifiers[0], Width: width, Height: height, Percent: 0.5, Type: "z")
			values.append(a)
		}
		if modifiers.count > 1 {
			let b = getCoordinates(modifiers[1], Width: width, Height: height, Percent: 0.5, Type: "z")
			values.append(b)
		}
		return values
	}

	func getConnector(frame: CGRect, type: GeometryField.PresetShapeGeometry) -> [[CGFloat]] {
		let w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		var connector: [[CGFloat]] = []
		if type == .rect {
			connector = [[midX, 0, 270], [0, midY, 180], [midX, h, 90], [w, midY, 0]]
		} else if type == .oval {
			let a = self.getEllipseCoordinates(frame: frame)
			connector = [[midX, 0, 270], [a[0], a[1], 270], [0, midY, 180], [a[0], a[3], 90], [midX, h, 90], [a[2], a[3], 90], [w, midY, 0], [a[2], a[1], 270]]
		}
		return connector
	}

	func getEllipseCoordinates(frame: CGRect) -> [CGFloat] {
		let w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let angle1 = CGFloat(degreesToRadians(angle: 225))
		let angle2 = CGFloat(degreesToRadians(angle: 45))
		let a = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		return a
	}

	func rect(frame: CGRect) -> PresetPathInfo {
		let path = CGPath(rect: frame, transform: nil)
		let textFrame = frame
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func roundRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = !modifiers.isEmpty ? getCoordinates(CGFloat(modifiers[0]), Width: w, Height: h, Percent: 0.5, Type: "z") : 0
		let sX: CGFloat = w - f1
		let sY: CGFloat = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + sX, y))
		path.addArc(center: CGPoint(x + sX, y + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + sY))
		path.addArc(center: CGPoint(x + sX, y + sY), radius: w - sX, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path.addLine(to: CGPoint(x + f1, y + h))
		path.addArc(center: CGPoint(x + f1, y + sY), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x, y + f1))
		path.addArc(center: CGPoint(x + f1, y + f1), radius: f1, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path.closeSubpath()

		let t1 = 0.293 * f1
		let handles = [CGPoint(x: f1, y: 0)]
		let textFrame = CGRect(x: x + t1, y: y + t1, width: w - (2 * t1), height: h - t1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func snipSingleRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let a: CGFloat = recCoordinates[0]
		let f1: CGFloat = w - a
		let f2: CGFloat = a

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		path.addLine(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + w, y + f2))
		path.addLine(to: CGPoint(x + w, y + h))
		path.addLine(to: CGPoint(x, y + h))
		path.closeSubpath()

		let t1: CGFloat = a * 0.5
		let t2: CGFloat = (f1 + w) * 0.5

		let handles = [CGPoint(x: f1, y: 0)]
		let textFrame = CGRect(x: x, y: y + t1, width: t2, height: h - t1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func grid(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		if modifiers[0] > 0 {
			let gap = w / (modifiers[0] - 1)
			for i in 0...Int(modifiers[0] - 1) {
				path.move(to: CGPoint(x + (CGFloat(i) * gap), y))
				path.addLine(to: CGPoint(x + (CGFloat(i) * gap), y + h))
			}
		}
		if modifiers[1] > 0 {
			let gap = h / (modifiers[1] - 1)
			for i in 0...Int(modifiers[1] - 1) {
				path.move(to: CGPoint(x, y + (CGFloat(i) * gap)))
				path.addLine(to: CGPoint(x + w, y + (CGFloat(i) * gap)))
			}
		}

		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func snipSamesideRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)

		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]
		let f3: CGFloat = recCoordinates[1]

		let xx = w - f1
		let x1 = w - f3
		let y1 = h - f3

		path.move(to: CGPoint(x + xx, y))
		path.addLine(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + w, y + f2))
		path.addLine(to: CGPoint(x + w, y + y1))
		path.addLine(to: CGPoint(x + x1, y + h))
		path.addLine(to: CGPoint(x + f3, y + h))
		path.addLine(to: CGPoint(x, y + y1))
		path.addLine(to: CGPoint(x, y + f2))
		path.closeSubpath()

		let t1 = f2 - f3
		let tx = ifElse(First: t1, Second: f2, Third: f3)
		let l = tx * 0.5
		let r = w - l
		let t = f2 * 0.5
		let b = (y1 + h) * 0.5

		let handles = [CGPoint(f1, 0), CGPoint(f3, h)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func snipDiagonalRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]
		let f3: CGFloat = recCoordinates[1]
		let x1 = w - f3
		let y1 = h - f3
		let y2 = h - f2

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + w, y + f2))
		path.addLine(to: CGPoint(x + w, y + y1))
		path.addLine(to: CGPoint(x + x1, y + h))
		path.addLine(to: CGPoint(x + f2, y + h))
		path.addLine(to: CGPoint(x, y + y2))
		path.addLine(to: CGPoint(x, y + f3))
		path.addLine(to: CGPoint(x + f3, y))
		path.closeSubpath()

		let t1 = f3 - f2
		let tx = ifElse(First: t1, Second: f3, Third: f2)
		let l = tx * 0.5
		let r = w - l
		let b = h - l

		let handles = [CGPoint(f1, 0), CGPoint(f3, 0)]
		let textFrame = CGRect(x: x + l, y: y + l, width: r - l, height: b - l)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func snipRoundSingleRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]
		let f3: CGFloat = recCoordinates[1]

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + w, y + f2))
		path.addLine(to: CGPoint(x + w, y + h))
		path.addLine(to: CGPoint(x, y + h))
		path.addLine(to: CGPoint(x, y + f3))
		path.addArc(center: CGPoint(x + f3, y + f3), radius: f3, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path.closeSubpath()

		let l = f3 * 0.293
		let r = (f1 + w) * 0.5

		let handles = [CGPoint(f1, 0), CGPoint(f3, 0)]
		let textFrame = CGRect(x: x + l, y: y + l, width: r - l, height: h - l)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func roundSingleRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		path.addLine(to: CGPoint(x + f1, y))
		path.addArc(center: CGPoint(x + f1, y + f2), radius: f2, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + h))
		path.addLine(to: CGPoint(x, y + h))
		path.closeSubpath()

		let a = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let tx = a * 0.293
		let r = w - tx

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x, y: y, width: r, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func roundSamesideRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]
		let f3: CGFloat = recCoordinates[1]
		let xx = w - f1
		let x1 = w - f3
		let y1 = h - f3

		let path = CGMutablePath()
		path.move(to: CGPoint(x + xx, y))
		path.addLine(to: CGPoint(x + f1, y))
		path.addArc(center: CGPoint(x + f1, y + f2), radius: f2, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + y1))
		path.addArc(center: CGPoint(x + x1, y + y1), radius: w - x1, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + f3, y + h))
		path.addArc(center: CGPoint(x + f3, y + y1), radius: f3, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x, y + f2))
		path.addArc(center: CGPoint(x + xx, y + f2), radius: f2, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path.closeSubpath()

		let d = f2 - f3
		let d1 = f2 * 0.293
		let d2 = f3 * 0.293
		let l = ifElse(First: d, Second: d1, Third: d2)
		let t = d1
		let r = w - l
		let b = h - d2

		let handles = [CGPoint(f1, 0), CGPoint(f3, h)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func roundDiagonalRect(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let recCoordinates = self.getRectCoordinates(width: w, height: h, modifiers: modifiers)
		let f1: CGFloat = w - recCoordinates[0]
		let f2: CGFloat = recCoordinates[0]
		let f3: CGFloat = recCoordinates[1]
		let x1 = w - f3
		let y1 = h - f3
		let y2 = h - f2

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f3, y))
		path.addLine(to: CGPoint(x + f1, y))
		path.addArc(center: CGPoint(x + f1, y + f2), radius: f2, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + y1))
		path.addArc(center: CGPoint(x + x1, y + y1), radius: w - x1, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + f2, y + h))
		path.addArc(center: CGPoint(x + f2, y + y2), radius: f2, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x, y + f3))
		path.addArc(center: CGPoint(x + f3, y + f3), radius: f3, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path.closeSubpath()

		let tx1 = f3 * 0.293
		let tx2 = f2 * 0.293
		let d = tx1 - tx2
		let dx = ifElse(First: d, Second: tx1, Third: tx2)
		let r = w - dx
		let b = h - dx

		let handles = [CGPoint(f1, 0), CGPoint(f3, 0)]
		let textFrame = CGRect(x: x + dx, y: y + dx, width: r - dx, height: b - dx)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func oval(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))

		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func setTextBox(midX: CGFloat, midY: CGFloat, frame: CGRect) -> CGRect {
		let x = frame.origin.x
		let y = frame.origin.y
		let angle1 = CGFloat(225 * (.pi / 180.0))
		let angle2 = CGFloat(45 * (.pi / 180.0))
		let a = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		let frame = CGRect(x: x + a[0], y: y + a[1], width: a[2] - a[0], height: a[3] - a[1])
		return frame
	}

	func isoscelesTriangle(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = modifiers[0] * w

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + w, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		let midX = w * 0.5
		let midY = h * 0.5
		let tx1 = f1 * 0.5
		let tx2 = tx1 + midX

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + tx1, y: y + midY, width: tx2 - tx1, height: h - midY)
		let animationFrame = frame
		let connector = [[f1, 0, 270], [tx1, midY, 180], [0, h, 90], [f1, h, 90], [w, h, 90], [tx2, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func rightTriangle(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		path.addLines(between: [CGPoint(x, y), CGPoint(x + w, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		// MARK: Unused

//		let midX = (x + w) * 0.5
//		let midY = (y + h) * 0.5
		let c1: CGFloat = 7.0 / 12.0
		let l = w * (1.0 / 12.0)
		let t = h * c1
		let r = w * c1
		let b = h * (11.0 / 12.0)

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[0, 0, 270], [0, midY, 180], [0, h, 90], [midX, h, 90], [w, h, 90], [midX, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func trapezoid(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = modifiers[0]
		let f1 = getCoordinates(a, Width: w, Height: h, Percent: 0.5, Type: "x")
		let f0 = w - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + f0, y), CGPoint(x + w, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		let t1 = (a * w) / (0.5 * w)
		let l = (w * 1 / 3) * t1
		let t = (h * 1 / 3) * t1
		let r = w - l

		let midX = w * 0.5
		let midY = h * 0.5
		let f2 = f1 * 0.5
		let f3 = w - f2

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: h - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [f2, midY, 180], [midX, h, 90], [f3, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func pentagon(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let swd2 = midX * 1.05
		let shd2 = midY * 1.1
		let ang1 = CGFloat(degreesToRadians(angle: 18))
		let ang2 = CGFloat(degreesToRadians(angle: 306))
		let dx1 = swd2 * cos(ang1)
		let dx2 = swd2 * cos(ang2)
		let dy1 = shd2 * sin(ang1)
		let dy2 = shd2 * sin(ang2)
		let x1 = midX - dx1
		let x2 = midX - dx2
		let x3 = midX + dx2
		let x4 = midX + dx1
		let y1 = shd2 - dy1
		let y2 = shd2 - dy2
		let t = y1 * dx2 / dx1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLines(between: [CGPoint(x + x1, y + y1), CGPoint(x + midX, y), CGPoint(x + x4, y + y1), CGPoint(x + x3, y + y2), CGPoint(x + x2, y + y2)])
		path.closeSubpath()

		let textFrame = CGRect(x: x + x2, y: y + t, width: x3 - x2, height: y2 - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [x1, y1, 180], [x2, y2, 90], [midX, h, 90], [x3, y2, 90], [x4, y1, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func hexagon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = modifiers[0]
		let f1 = getCoordinates(a, Width: w, Height: h, Percent: 0.5, Type: "x")
		let sX = w - f1
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + sX, y), CGPoint(x + w, y + midY), CGPoint(x + sX, y + h), CGPoint(x + f1, y + h), CGPoint(x, y + midY)])
		path.closeSubpath()

		let midX = 0.5 * (x + w)
		let q1 = midX * -1 * 0.5
		let a1 = a * (x + w)
		let q2 = a1 + q1

		// MARK: Unused

//		ifElse(First: q2, Second: 4, Third: 2)
		let q3 = ifElse(First: q2, Second: 4, Third: 2)
		let q4 = ifElse(First: q2, Second: 3, Third: 2)
		let q5 = ifElse(First: q2, Second: q1, Third: 0)
		let q6 = (a1 + q5) / q1
		let q7 = (q6 * q4) / -1
		let q8 = q3 + q7
		let c = q8 / 24
		let l = w * c
		let t = h * c
		let r = w - l
		let b = h - t

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[w, midY, 0], [sX, h, 90], [f1, h, 90], [0, midY, 180], [f1, 0, 270], [sX, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func diamond(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x + w * 0.5, y))
		path.addLines(between: [CGPoint(x + w * 0.5, y), CGPoint(x + w, y + h * 0.5), CGPoint(x + w * 0.5, y + h), CGPoint(x, y + h * 0.5)])
		path.closeSubpath()

		let l = w * 0.25
		let t = h * 0.25
		let r = w - l
		let b = h - t
		let midX = w * 0.5
		let midY = h * 0.5

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, midY, 180], [midX, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func parallelogram(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let a = modifiers[0]
		let f1 = getCoordinates(a, Width: w, Height: h, Percent: 1, Type: "x")
		let f0 = w - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + w, y), CGPoint(x + f0, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		let q1 = 5 * ((a * w) / w)
		let q2 = (1 + q1) / 12
		let l = q2 * w
		let t = q2 * h
		let r = w - l
		let b = h - t

		// MARK: Unused

		let q3 = h * (w / f1)
		let y1 = ifElse(First: q3, Second: 0, Third: h)
		let f2 = f0 * 0.5
		let f3 = w - f2
		let f4 = f1 * 0.5
		let f5 = w - f4
		let y2 = h - y1

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[midX, y2, 270], [f3, 0, 270], [f5, midY, 0], [f2, h, 90], [midX, y1, 90], [f4, midY, 180]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func heptagon(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let y1 = (13_328.0 / 21_600.0) * h
		let y2 = (4_278.0 / 21_600.0) * h
		let x1 = (2_139.0 / 21_600.0) * w
		let x2 = (19_460.0 / 21_600.0) * w
		let x3 = (15_606.0 / 21_600.0) * w
		let x4 = (5_993.0 / 21_600.0) * w

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + y1))
		path.addLines(between: [CGPoint(x, y + y1), CGPoint(x + x1, y + y2), CGPoint(x + midX, y), CGPoint(x + x2, y + y2), CGPoint(x + w, y + y1), CGPoint(x + x3, y + h), CGPoint(x + x4, y + h)])
		path.closeSubpath()

		let b = h - y2
		let textFrame = CGRect(x: x + x1, y: y + y2, width: x2 - x1, height: b - y2)
		let animationFrame = frame
		let connector = [[x2, y2, 0], [w, y1, 0], [x3, h, 90], [x4, h, 90], [0, y1, 180], [x1, y2, 180], [midX, 0, 270]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func octagon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let f1 = a
		let sX = w - f1
		let sY = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + sX, y), CGPoint(x + w, y + f1), CGPoint(x + w, y + sY), CGPoint(x + sX, y + h), CGPoint(x + f1, y + h), CGPoint(x, y + sY), CGPoint(x, y + f1)])
		path.closeSubpath()

		let l = a * 0.5
		let r = w - l
		let b = h - l

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + l, width: r - l, height: b - l)
		let animationFrame = frame
		let connector = [[w, f1, 0], [w, sY, 0], [sX, h, 90], [f1, h, 90], [0, sY, 180], [0, f1, 180], [f1, 0, 270], [sX, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func decagon(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midY = h * 0.5
		let midX = w * 0.5

		let f0 = midY * 1.051_46
		let ang1 = CGFloat(degreesToRadians(angle: 36))
		let ang2 = CGFloat(degreesToRadians(angle: 72))
		let f1 = midX * cos(ang1)
		let f2 = midX * cos(ang2)

		let x1 = midX - f1
		let x2 = midX - f2
		let x3 = midX + f2
		let x4 = midX + f1

		let f3 = f0 * sin(ang2)
		let f4 = f0 * sin(ang1)

		let y1 = midY - f3
		let y2 = midY - f4
		let y3 = midY + f4
		let y4 = midY + f3

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + midY))
		path.addLines(between: [CGPoint(x, y + midY), CGPoint(x + x1, y + y2), CGPoint(x + x2, y + y1), CGPoint(x + x3, y + y1), CGPoint(x + x4, y + y2), CGPoint(x + w, y + midY), CGPoint(x + x4, y + y3), CGPoint(x + x3, y + y4), CGPoint(x + x2, y + y4), CGPoint(x + x1, y + y3)])
		path.closeSubpath()

		let textFrame = CGRect(x: x + x1, y: y + y2, width: x4 - x1, height: y3 - y2)
		let animationFrame = frame
		let connector = [[x4, y2, 0], [w, midY, 0], [x4, y3, 0], [x3, y4, 90], [x2, y4, 90], [x1, y3, 180], [0, midY, 180], [x1, y2, 180], [x2, y1, 270], [x3, y1, 270]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func pie(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let angle1 = modifiers[0]
		let angle2 = modifiers[1]
		let midX = w * 0.5
		let midY = h * 0.5
		let a: [CGFloat] = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]
		var m1: CGFloat, m2: CGFloat

		m1 = atan2((y1 - midY) * (midX / midY), x1 - midX)
		if m1 < 0 {
			m1 += 2 * .pi
		}

		m2 = atan2((y2 - midY) * (midX / midY), x2 - midX)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		let sweepAngle = m2 - m1
		var startAngle = m1, endAngle = m2
		var framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)
		var quadrantNumber: CGFloat, fullQuadrant: CGFloat, endQuadrantNumber: CGFloat, startQuadrantNumber: CGFloat
		var controlPoint: [CGPoint]

		let path = CGMutablePath()
		path.move(to: CGPoint(x + midX, y + midY))
		path.addLine(to: CGPoint(x + x1, y + y1))

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

			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		// full quadrants
		quadrantNumber += 1

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
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
				framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
				framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)
				endAngle = m2
			}
			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		} else {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = m2

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}
		path.closeSubpath()

		let handles = [CGPoint(x1, y1), CGPoint(x2, y2)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func chord(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let path = CGMutablePath()
		let angle1 = modifiers[0]
		let angle2 = modifiers[1]
		let midX = w * 0.5
		let midY = h * 0.5
		let a: [CGFloat] = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]
		var m1: CGFloat, m2: CGFloat

		m1 = atan2((y1 - midY) * (midX / midY), x1 - midX)
		if m1 < 0 {
			m1 += 2 * .pi
		}

		m2 = atan2((y2 - midY) * (midX / midY), x2 - midX)
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

			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			path.move(to: framePoint1)
			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			path.move(to: framePoint1)
			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		// full quadrants
		quadrantNumber += 1

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
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
				framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
				framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)
				endAngle = m2
			}
			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		} else {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = m2

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}
		path.closeSubpath()

		let x3 = (x1 + x2) * 0.5
		let y3 = (y1 + y2) * 0.5
		let sw1 = angle2 - angle1
		let sw2 = sw1 + 360

		let swAng = ifElse(First: sw1, Second: sw1, Third: sw2)
		let midAng0 = swAng * 0.5
		let angle3 = angle1 + midAng0 - 180

		let handles = [CGPoint(x1, y1), CGPoint(x2, y2)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = [[x1, y1, angle1], [x2, y2, angle2], [x3, y3, angle3]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func teardrop(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let path = CGMutablePath()
		var a = max(modifiers[0], 0.5)
		a -= 0.5
		a *= 2

		let f0 = a * w
		let f1 = a * h

		let midX = w * 0.5
		let midY = h * 0.5

		let n = CGFloat(sqrt(2.0))
		let tx = n * midX
		let ty = n * midY
		let aw = tx * f0 / w
		let ah = ty * f1 / h
		let angle = CGFloat(degreesToRadians(angle: 45))
		let dx1 = aw * cos(angle)
		let dy1 = ah * sin(angle)

		let x1 = midX + dx1
		let y1 = midY - dy1

		let x2 = (midX + x1) * 0.5
		let y2 = (midY + y1) * 0.5

		path.move(to: CGPoint(x + w, y + midY))
		var fullQuadrant = 3, quadrantNumber = 1
		var startAngle: CGFloat, endAngle: CGFloat = 0.0, alphaValue: CGFloat
		var tangent1 = CGPoint(0, 0), tangent2 = CGPoint(0, 0), controlPoint1 = CGPoint(0, 0), controlPoint2 = CGPoint(0, 0), framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)

		framePoint2.x = x + w * 0.5 + w * 0.5 * cos(0)
		framePoint2.y = y + h * 0.5 + h * 0.5 * sin(0)

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = CGFloat(CGFloat(quadrantNumber) * 0.5 * .pi)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)
			alphaValue = (sin(endAngle - startAngle) * (sqrt(4 + 3 * tan((endAngle - startAngle) / 2)) - 1)) / 3

			tangent1.x = -w * 0.5 * sin(startAngle)
			tangent1.y = h * 0.5 * cos(startAngle)

			tangent2.x = -w * 0.5 * sin(endAngle)
			tangent2.y = h * 0.5 * cos(endAngle)

			controlPoint1.x = framePoint1.x + alphaValue * tangent1.x
			controlPoint1.y = framePoint1.y + alphaValue * tangent1.y

			controlPoint2.x = framePoint2.x - alphaValue * tangent2.x
			controlPoint2.y = framePoint2.y - alphaValue * tangent2.y

			path.addCurve(to: framePoint2, control1: controlPoint1, control2: controlPoint2)

			fullQuadrant -= 1
			quadrantNumber += 1
		}

		path.addCurve(to: CGPoint(x + x1, y + y1), control1: CGPoint(x + w * 0.5, y), control2: CGPoint(x + x2, y))
		path.addCurve(to: CGPoint(x + w, y + h * 0.5), control1: CGPoint(x + x1, y + y1), control2: CGPoint(x + w, y + y2))
		path.closeSubpath()

		let handles = [CGPoint(x1, 0)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let a1 = self.getEllipseCoordinates(frame: frame)
		let connector = [[w, midY, 0], [a1[2], a1[3], 90], [midX, h, 90], [a1[0], a1[3], 90], [0, midY, 180], [a1[0], a1[1], 270], [midX, 0, 270], [x1, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func frame(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let xx = w - f1
		let yy = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		path.addLines(between: [CGPoint(x, y), CGPoint(x + w, y), CGPoint(x + w, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		path.move(to: CGPoint(x + xx, y + yy))
		path.addLines(between: [CGPoint(x + xx, y + yy), CGPoint(x + xx, y + f1), CGPoint(x + f1, y + f1), CGPoint(x + f1, y + yy)])
		path.closeSubpath()

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + f1, y: y + f1, width: xx - f1, height: yy - f1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func halfFrame(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let adj1 = modifiers[0]
		let adj2 = modifiers[1]
		let ss = min(w, h)
		let max2 = 1.0 * w / ss
		let a2 = max(min(adj2, max2), 0)
		let x1 = ss * a2 / 1.0
		let g1 = h * x1 / w
		let g2 = h - g1
		let max1 = 1.0 * g2 / ss
		let a1 = max(min(adj1, max1), 0)

		let y1 = ss * a1 / 1.0
		let dx2 = y1 * w / h
		let x2 = w - dx2
		let dy2 = x1 * h / w
		let y2 = h - dy2
		let cx1 = x1 * 0.5
		let cy1 = (y2 + h) * 0.5
		let cx2 = (x2 + w) * 0.5
		let cy2 = y1 * 0.5
		let midY = h * 0.5
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		path.addLines(between: [CGPoint(x, y), CGPoint(x + w, y), CGPoint(x + x2, y + y1), CGPoint(x + x1, y + y1), CGPoint(x + x1, y + y2), CGPoint(x, y + h)])
		path.closeSubpath()

		let handles = [CGPoint(0, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[cx2, cy2, 0], [cx1, cy1, 90], [0, midY, 180], [midX, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func lshape(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let y1 = h - getCoordinates(modifiers[0], Width: w, Height: h, Percent: 1, Type: "y")
		let x1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "x")

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y))
		path.addLines(between: [CGPoint(x + x1, y), CGPoint(x + x1, y + y1), CGPoint(x + w, y + y1), CGPoint(x + w, y + h), CGPoint(x, y + h), CGPoint(x, y)])
		path.closeSubpath()

		let cx1 = x1 * 0.5
		let cy1 = (y1 + h) * 0.5
		let midX = w * 0.5
		let midY = h * 0.5
		let d = w - h
		let t = ifElse(First: d, Second: y1, Third: 0)
		let r = ifElse(First: d, Second: w, Third: x1)

		let handles = [CGPoint(0, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x, y: y + t, width: r, height: h - t)
		let animationFrame = frame
		let connector = [[w, cy1, 0], [midX, h, 90], [0, midY, 180], [cx1, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func diagonalStripe(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = modifiers[0]
		let valy = a * h
		let valx = a * w

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + valy))
		path.addLines(between: [CGPoint(x, y + valy), CGPoint(x + valx, y), CGPoint(x + w, y), CGPoint(x, y + h)])
		path.closeSubpath()

		let x1 = valx * 0.5
		let x2 = (valx + w) * 0.5
		let y1 = valy * 0.5
		let y2 = (valy + h) * 0.5
		let midX = w * 0.5
		let midY = h * 0.5

		let handles = [CGPoint(0, valy)]
		let textFrame = CGRect(x: x, y: y, width: x2, height: y2)
		let animationFrame = frame
		let connector = [[midX, midY, 0], [0, y2, 180], [x1, y1, 180], [x2, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func cross(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let sY = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLines(between: [CGPoint(x + f1, y), CGPoint(x + sX, y), CGPoint(x + sX, y + f1), CGPoint(x + w, y + f1), CGPoint(x + w, y + sY), CGPoint(x + sX, y + sY), CGPoint(x + sX, y + h), CGPoint(x + f1, y + h), CGPoint(x + f1, y + sY), CGPoint(x, y + sY), CGPoint(x, y + f1), CGPoint(x + f1, y + f1)])
		path.closeSubpath()

		let d = w - h
		let l = ifElse(First: d, Second: 0, Third: f1)
		let r = ifElse(First: d, Second: w, Third: sX)
		let t = ifElse(First: d, Second: f1, Third: 0)
		let b = ifElse(First: d, Second: sY, Third: h)

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func plaque(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let sY = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + f1, y))
		path.addLine(to: CGPoint(x + sX, y))
		path.addArc(center: CGPoint(x + w, y), radius: f1, startAngle: .pi, endAngle: 0.5 * .pi, clockwise: true)
		path.addLine(to: CGPoint(x + w, y + sY))
		path.addArc(center: CGPoint(x + w, y + h), radius: w - sX, startAngle: 1.5 * .pi, endAngle: .pi, clockwise: true)
		path.addLine(to: CGPoint(x + f1, y + h))
		path.addArc(center: CGPoint(x, y + h), radius: f1, startAngle: 0, endAngle: 1.5 * .pi, clockwise: true)
		path.addLine(to: CGPoint(x, y + f1))
		path.addArc(center: CGPoint(x, y), radius: f1, startAngle: 0.5 * .pi, endAngle: 0, clockwise: true)
		path.closeSubpath()

		let l = f1 * 0.707
		let r = w - l
		let b = h - l

		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + l, y: y + l, width: r - l, height: b - l)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func can(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f0 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "y")
		let y1 = f0 * 0.5
		let y2 = y1 + y1
		let y3 = h - y1
		let midX = w * 0.5
		let midY = h * 0.5
		var controlPoint: [CGPoint]

		// path1
		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + y1))
		path1.addLine(to: CGPoint(x, y + y3))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + w, y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x + w, y + y1))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])
		path1.closeSubpath()

		// path 2
		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x, y + y1))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + y1), framePoint2: CGPoint(x + midX, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + midX, y), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y), framePoint2: CGPoint(x + w, y + y1), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])
		path2.closeSubpath()

		// path 3
		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x, y + y1))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + y1), framePoint2: CGPoint(x + midX, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x + midX, y), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y), framePoint2: CGPoint(x + w, y + y1), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x, y + y3))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		path3.addCurve(to: CGPoint(x + w, y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x + w, y + y1))
		// Removed since evenodd rule is used for stroke which causes inproper rendering
		//        controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: y1)
		//        path3.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])
		//
		//        controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: y1)
		//        path3.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		//        path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(midX, y2)]
		let textFrame = CGRect(x: x, y: y + y2, width: w, height: y3 - y2)
		let animationFrame = frame
		let connector = [[midX, y2, 270], [midX, 0, 270], [0, midY, 180], [midX, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func cube(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 1, Type: "x")
		let x1 = w - f1
		let y1 = h - f1

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + f1))
		path1.addLines(between: [CGPoint(x, y + f1), CGPoint(x, y + h), CGPoint(x + x1, y + h), CGPoint(x + x1, y + f1)])
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x, y + f1))
		path2.addLines(between: [CGPoint(x, y + f1), CGPoint(x + f1, y), CGPoint(x + w, y), CGPoint(x + x1, y + f1)])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x + x1, y + h))
		path3.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x1, y + f1), CGPoint(x + w, y), CGPoint(x + w, y + y1)])
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x, y + h))
		path4.addLines(between: [CGPoint(x, y + h), CGPoint(x, y + f1), CGPoint(x + f1, y), CGPoint(x + w, y), CGPoint(x + w, y + y1), CGPoint(x + x1, y + h)])
		path4.closeSubpath()

		path4.move(to: CGPoint(x, y + f1))
		path4.addLine(to: CGPoint(x + x1, y + f1))

		path4.move(to: CGPoint(x + x1, y + f1))
		path4.addLine(to: CGPoint(x + x1, y + h))

		path4.move(to: CGPoint(x + x1, y + f1))
		path4.addLine(to: CGPoint(x + w, y))

		let x2 = x1 * 0.5
		let y2 = y1 * 0.5
		let x3 = (f1 + w) * 0.5
		let y3 = (f1 + h) * 0.5

		let pathArray = [path1, path2, path3, path4]
		let handles = [CGPoint(0, f1)]
		let textFrame = CGRect(x: x, y: y + f1, width: x1, height: h - f1)
		let animationFrame = frame
		let connector = [[x3, 0, 270], [x2, f1, 270], [0, y3, 180], [x2, h, 90], [x1, y3, 0], [w, y2, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func bevel(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let f1 = a
		let x1 = w - f1
		let y1 = h - f1
		let midX = w * 0.5
		let midY = h * 0.5

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x + f1, y + f1))
		path1.addLines(between: [CGPoint(x + f1, y + f1), CGPoint(x + x1, y + f1), CGPoint(x + x1, y + y1), CGPoint(x + f1, y + y1)])
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x, y))
		path2.addLines(between: [CGPoint(x, y), CGPoint(x + f1, y + f1), CGPoint(x + f1, y + y1), CGPoint(x, y + h)])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x, y))
		path3.addLines(between: [CGPoint(x, y), CGPoint(x + w, y), CGPoint(x + x1, y + f1), CGPoint(x + f1, y + f1)])
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x + w, y))
		path4.addLines(between: [CGPoint(x + w, y), CGPoint(x + w, y + h), CGPoint(x + x1, y + y1), CGPoint(x + x1, y + f1)])
		path4.closeSubpath()

		let path5 = CGMutablePath()
		path5.move(to: CGPoint(x + w, y + h))
		path5.addLines(between: [CGPoint(x + w, y + h), CGPoint(x, y + h), CGPoint(x + f1, y + y1), CGPoint(x + x1, y + y1)])
		path5.closeSubpath()

		let path6 = CGMutablePath()
		path6.move(to: CGPoint(x, y))
		path6.addLines(between: [CGPoint(x, y), CGPoint(x, y + h), CGPoint(x + w, y + h), CGPoint(x + w, y)])
		path6.closeSubpath()

		path6.move(to: CGPoint(x + f1, y + f1))
		path6.addLines(between: [CGPoint(x + f1, y + f1), CGPoint(x + f1, y + y1), CGPoint(x + x1, y + y1), CGPoint(x + x1, y + f1)])
		path6.closeSubpath()

		path6.move(to: CGPoint(x, y))
		path6.addLine(to: CGPoint(x + f1, y + f1))

		path6.move(to: CGPoint(x, y + h))
		path6.addLine(to: CGPoint(x + f1, y + y1))

		path6.move(to: CGPoint(x + w, y + h))
		path6.addLine(to: CGPoint(x + x1, y + y1))

		path6.move(to: CGPoint(x + w, y))
		path6.addLine(to: CGPoint(x + x1, y + f1))

		let pathArray = [path1, path2, path3, path4, path5, path6]
		let handles = [CGPoint(f1, 0)]
		let textFrame = CGRect(x: x + f1, y: y + f1, width: x1 - f1, height: y1 - f1)
		let animationFrame = frame
		let connector = [[w, midY, 0], [x1, midY, 0], [midX, h, 90], [midX, y1, 90], [0, midY, 180], [f1, midY, 180], [midX, 0, 270], [midX, f1, 270]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func donut(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let midx = w * 0.5
		let midy = h * 0.5
		var rx = w * 0.5
		var ry = h * 0.5

		let path = CGMutablePath()
		path.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))

		rx = midx - f1
		ry = midy - f1

		path.addEllipse(in: CGRect(x: x + f1, y: y + f1, width: 2 * rx, height: 2 * ry))

		let handles = [CGPoint(f1, midy)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func noSymbol(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		let n = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.33, Type: "x")
		var controlPoint: [CGPoint]

		let midx = w * 0.5
		let midy = h * 0.5
		let ang = CGFloat(degreesToRadians(angle: 45))
		let cosVal = cos(ang)
		let sinVal = sin(ang)

		let f2 = midx - n
		let f3 = n / 2.0
		let f4 = sqrt(f2 * f2 - f3 * f3)

		let f5 = (cosVal * ((-1) * f3) + sinVal * ((-1) * f4)) + midx
		let f7 = (cosVal * ((-1) * f3) + sinVal * f4) + midx
		let f9 = (cosVal * f3 + sinVal * f4) + midx
		let f11 = (cosVal * f3 + sinVal * ((-1) * f4)) + midx

		let n1 = n * h / w
		let a2 = midy - n1
		let a3 = n1 / 2.0
		let a4 = sqrt(a2 * a2 - a3 * a3)

		let f6 = ((-1) * (sinVal * ((-1) * a3) - cosVal * ((-1) * a4))) + midy
		let f8 = (-1 * (sinVal * ((-1) * a3) - cosVal * a4)) + midy
		let f10 = (-1 * (sinVal * a3 - cosVal * a4)) + midy
		let f12 = (-1 * (sinVal * a3 - cosVal * ((-1) * a4))) + midy
		let rx = midx - n
		let ry = midy - n1

		path.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))

		var angle = atan2((f6 - (h * 0.5)) * (rx / ry), f5 - (w * 0.5))
		if angle < 0 {
			angle += 2 * .pi
		}
		var framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)

		framePoint1.x = x + w * 0.5 + rx * cos(.pi)
		framePoint1.y = y + h * 0.5 + ry * sin(.pi)

		path.move(to: CGPoint(x + f5, y + f6))
		controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: CGPoint(x + f5, y + f6), startAngle: .pi, endAngle: angle, rx: rx, ry: ry)
		path.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1.x = x + w * 0.5 + rx * cos(0.5 * .pi)
		framePoint1.y = y + h * 0.5 + ry * sin(0.5 * .pi)
		framePoint2.x = x + w * 0.5 + rx * cos(.pi)
		framePoint2.y = y + h * 0.5 + ry * sin(.pi)

		controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: 0.5 * .pi, endAngle: .pi, rx: rx, ry: ry)
		path.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		angle = atan2((f8 - (h * 0.5)) * (rx / ry), f7 - (w * 0.5))
		if angle < 0 {
			angle += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + f7, y + f8), framePoint2: framePoint1, startAngle: angle, endAngle: 0.5 * .pi, rx: rx, ry: ry)
		path.addCurve(to: CGPoint(x + f7, y + f8), control1: controlPoint[1], control2: controlPoint[0])
		path.closeSubpath()

		path.move(to: CGPoint(x + f9, y + f10))

		angle = atan2((f10 - (h * 0.5)) * (rx / ry), f9 - (w * 0.5))
		if angle < 0 {
			angle += 2 * .pi
		}
		framePoint1.x = x + w * 0.5 + rx * cos(0)
		framePoint1.y = y + h * 0.5 + ry * sin(0)
		controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: CGPoint(x + f9, y + f10), startAngle: 0, endAngle: angle, rx: rx, ry: ry)
		path.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		framePoint1.x = x + w * 0.5 + rx * cos(1.5 * .pi)
		framePoint1.y = y + h * 0.5 + ry * sin(1.5 * .pi)
		framePoint2.x = x + w * 0.5 + rx * cos(0)
		framePoint2.y = y + h * 0.5 + ry * sin(0)
		controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: 1.5 * .pi, endAngle: 0, rx: rx, ry: ry)
		path.addCurve(to: framePoint1, control1: controlPoint[1], control2: controlPoint[0])

		angle = atan2((f12 - (h * 0.5)) * (rx / ry), f11 - (w * 0.5))
		if angle < 0 {
			angle += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + f11, y + f12), framePoint2: framePoint1, startAngle: angle, endAngle: 1.5 * .pi, rx: rx, ry: ry)
		path.addCurve(to: CGPoint(x + f11, y + f12), control1: controlPoint[1], control2: controlPoint[0])
		path.closeSubpath()

		let handles = [CGPoint(n, midy)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:disable function_body_length cyclomatic_complexity
	func blockArc(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		let angle1 = modifiers[0]
		let angle2 = modifiers[1]
		let f1 = getCoordinates(modifiers[2], Width: w, Height: h, Percent: 0.5, Type: "x")

		let midX = w * 0.5
		let midY = h * 0.5
		var rx = midX
		var ry = midY

		let a = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx, ry: ry, mid: CGPoint(-1, -1))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]
		var b = [CGFloat]()
		var x3 = CGFloat(), y3 = CGFloat(), x4 = CGFloat(), y4 = CGFloat()

		if angle1 == 0, angle2 == 0 {
			path.move(to: CGPoint(x: 0, y: midX))
		} else if angle1 == 0, angle2 == (.pi * 2) {
			path.move(to: CGPoint(x: 0, y: midY))
			path.addEllipse(in: CGRect(x: midX, y: midY, width: rx, height: ry))
			path.move(to: CGPoint(x: f1, y: midY))
			rx = midX - f1
			ry = midY - f1
			path.addEllipse(in: CGRect(x: midX, y: midY, width: rx, height: ry))
		} else {
			var m1: CGFloat, m2: CGFloat

			m1 = atan2((y1 - midY) * (midX / midY), x1 - midX)
			if m1 < 0 {
				m1 += 2 * .pi
			}

			m2 = atan2((y2 - midY) * (midX / midY), x2 - midX)
			if m2 < 0 {
				m2 += 2 * .pi
			}

			var sweepAngle = m2 - m1
			var startAngle = m1, endAngle = m2
			var framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)
			var quadrantNumber: CGFloat, fullQuadrant: CGFloat, endQuadrantNumber: CGFloat, startQuadrantNumber: CGFloat
			var controlPoint: [CGPoint]

			if m1 >= 0, m1 < (0.5 * .pi) {
				startQuadrantNumber = 1
			} else if m1 >= (0.5 * .pi), m1 < .pi {
				startQuadrantNumber = 2
			} else if m1 >= .pi, m1 < (1.5 * .pi) {
				startQuadrantNumber = 3
			} else {
				startQuadrantNumber = 4
			}

			if m2 >= 0, m2 < (0.5 * .pi) {
				endQuadrantNumber = 1
			} else if m2 >= (0.5 * .pi), m2 < .pi {
				endQuadrantNumber = 2
			} else if m2 >= .pi, m2 < 3 * (0.5 * .pi) {
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

			if endQuadrantNumber != quadrantNumber, sweepAngle >= 0 {
				endAngle = quadrantNumber * (0.5 * .pi)

				framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
				framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

				framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
				framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

				path.move(to: framePoint1)
				controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
			}

			if sweepAngle < 0 {
				endAngle = quadrantNumber * (0.5 * .pi)
				framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
				framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

				framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
				framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

				path.move(to: framePoint1)
				controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
			}

			// full quadrants
			quadrantNumber += 1

			while fullQuadrant > 0 {
				framePoint1 = framePoint2
				startAngle = endAngle
				endAngle = quadrantNumber * (0.5 * .pi)

				framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
				framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

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
					framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
					framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)
					path.move(to: framePoint1)
					endAngle = m2
				}
				framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
				framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
			} else {
				framePoint1 = framePoint2
				startAngle = endAngle
				endAngle = m2
				framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
				framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
			}

			rx = abs(midX - f1)
			ry = abs(midY - f1)

			b = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			x3 = b[0]
			y3 = b[1]
			x4 = b[2]
			y4 = b[3]

			path.addLine(to: CGPoint(x + x4, y + y4))

			m1 = atan2((y4 - midY) * (rx / ry), x4 - midX)
			if m1 < 0 {
				m1 += 2 * .pi
			}

			m2 = atan2((y3 - midY) * (rx / ry), x3 - midX)
			if m2 < 0 {
				m2 += 2 * .pi
			}

			sweepAngle = m2 - m1
			startAngle = m1
			endAngle = m2

			if m1 >= 0, m1 < (0.5 * .pi) {
				startQuadrantNumber = 1
			} else if m1 >= (0.5 * .pi), m1 < .pi {
				startQuadrantNumber = 2
			} else if m1 >= .pi, m1 < 3 * (0.5 * .pi) {
				startQuadrantNumber = 3
			} else {
				startQuadrantNumber = 4
			}

			if m2 >= 0, m2 < (0.5 * .pi) {
				endQuadrantNumber = 1
			} else if m2 >= (0.5 * .pi), m2 < .pi {
				endQuadrantNumber = 2
			} else if m2 >= .pi, m2 < 3 * (0.5 * .pi) {
				endQuadrantNumber = 3
			} else {
				endQuadrantNumber = 4
			}

			if sweepAngle > 0 {
				fullQuadrant = floor(m1 / (0.5 * .pi)) + floor((2 * .pi - m2) / (0.5 * .pi))
			} else if sweepAngle == 0 {
				fullQuadrant = -1
			} else {
				fullQuadrant = floor(m1 / (0.5 * .pi)) - floor(m2 / (0.5 * .pi)) - 1
			}

			if sweepAngle < 0, startQuadrantNumber == endQuadrantNumber {
				fullQuadrant = 0
			}
			quadrantNumber = startQuadrantNumber

			// first incomplete quadrant
			if sweepAngle >= 0, startQuadrantNumber != endQuadrantNumber {
				endAngle = (quadrantNumber - 1) * (0.5 * .pi)

				framePoint1.x = x + w * 0.5 + rx * cos(m1)
				framePoint1.y = y + h * 0.5 + ry * sin(m1)

				framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
				framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])
			}

			if sweepAngle >= 0, startQuadrantNumber == endQuadrantNumber {
				endAngle = (quadrantNumber - 1) * (0.5 * .pi)

				framePoint1.x = x + w * 0.5 + rx * cos(m1)
				framePoint1.y = y + h * 0.5 + ry * sin(m1)

				framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
				framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])
			}

			if sweepAngle < 0, startQuadrantNumber != endQuadrantNumber {
				endAngle = (quadrantNumber - 1) * (0.5 * .pi)
				framePoint1.x = x + w * 0.5 + rx * cos(m1)
				framePoint1.y = y + h * 0.5 + ry * sin(m1)

				framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
				framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])
			}

			// full quadrants
			quadrantNumber -= 1

			while fullQuadrant > 0 {
				framePoint1 = framePoint2
				startAngle = endAngle
				endAngle = (quadrantNumber - 1) * (0.5 * .pi)

				framePoint2.x = x + w * 0.5 + rx * cos(endAngle)
				framePoint2.y = y + h * 0.5 + ry * sin(endAngle)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])

				fullQuadrant -= 1
				quadrantNumber -= 1
			}

			// last quadrant
			if sweepAngle >= 0 {
				framePoint1 = framePoint2
				startAngle = endAngle
				endAngle = m2
				framePoint2.x = x + w * 0.5 + rx * cos(m2)
				framePoint2.y = y + h * 0.5 + ry * sin(m2)

				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])
			} else {
				if endQuadrantNumber != startQuadrantNumber {
					framePoint1 = framePoint2
					framePoint2.x = x + w * 0.5 + rx * cos(m2)
					framePoint2.y = y + h * 0.5 + ry * sin(m2)
					startAngle = endAngle
					endAngle = m2
				} else {
					framePoint1.x = x + w * 0.5 + rx * cos(m1)
					framePoint1.y = y + h * 0.5 + ry * sin(m1)
					framePoint2.x = x + w * 0.5 + rx * cos(m2)
					framePoint2.y = y + h * 0.5 + ry * sin(m2)
					endAngle = m2
				}
				controlPoint = getControlPointsForEllipse(framePoint1: framePoint2, framePoint2: framePoint1, startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
				path.addCurve(to: framePoint2, control1: controlPoint[1], control2: controlPoint[0])
			}
			path.closeSubpath()
		}
		let maxX = w
		let maxY = h

		let constant_angle = CGFloat(degreesToRadians(angle: 360))
		let sw11 = angle2 - angle1
		let sw12 = sw11 + constant_angle
		let swAng = ifElse(First: sw11, Second: sw11, Third: sw12)
		let sw0 = constant_angle - angle1
		let da1 = swAng - sw0
		let g1 = (x1 > x4) ? x1 : x4
		let g2 = (x2 > x3) ? x2 : x3
		let g3 = (g1 > g2) ? g1 : g2
		let r = ifElse(First: da1, Second: maxX, Third: g3)

		let sw1 = CGFloat(degreesToRadians(angle: 90)) - angle1
		let sw2 = CGFloat(degreesToRadians(angle: 450)) - angle1
		let sw3 = ifElse(First: sw1, Second: sw1, Third: sw2)
		let da2 = swAng - sw3
		let g5 = (y1 > y4) ? y1 : y4
		let g6 = (y2 > y3) ? y2 : y3
		let g7 = (g5 > g6) ? g5 : g6
		let b3 = ifElse(First: da2, Second: maxY, Third: g7)
		let sw4 = CGFloat(degreesToRadians(angle: 180)) - angle1
		let sw5 = CGFloat(degreesToRadians(angle: 540)) - angle1
		let sw6 = ifElse(First: sw4, Second: sw4, Third: sw5)
		let da3 = swAng - sw6
		let g9 = (x1 < x4) ? x1 : x4
		let g10 = (x2 < x3) ? x2 : x3
		let g11 = (g9 < g10) ? g9 : g10
		let l = ifElse(First: da3, Second: 0, Third: g11)

		let sw7 = CGFloat(degreesToRadians(angle: 270)) - angle1
		let sw8 = CGFloat(degreesToRadians(angle: 630)) - angle1
		let sw9 = ifElse(First: sw7, Second: sw7, Third: sw8)
		let da4 = swAng - sw9
		let g13 = (y1 < y4) ? y1 : y4
		let g14 = (y2 < y3) ? y2 : y3
		let g15 = (g13 < g14) ? g13 : g14
		let t = ifElse(First: da4, Second: 0, Third: g15)

		// MARK: Unused

		let x5 = (x1 + x3) * 0.5
		let y5 = (y1 + y3) * 0.5
		let x6 = (x2 + x4) * 0.5
		let y6 = (y2 + y4) * 0.5
		let cang1 = CGFloat(degreesToRadians(angle: Int(angle1))) - 90
		let cang2 = CGFloat(degreesToRadians(angle: Int(angle2))) + 90
		let cang3 = (cang1 + cang2) * 0.5

		let handles = [CGPoint(x1, y1), CGPoint(x4, y4)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b3 - t)
		let animationFrame = frame
		let connector = [[x5, y5, cang1], [x6, y6, cang2], [midX, midY, cang3]]

		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length cyclomatic_complexity
	func foldedCorner(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let a = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let x1 = w - a
		let x2 = x1 + a * 0.2
		let y2 = h - a
		let y1 = y2 + a * 0.2

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y))
		path1.addLines(between: [CGPoint(x, y), CGPoint(x + w, y), CGPoint(x + w, y + y2), CGPoint(x + x1, y + h), CGPoint(x, y + h)])
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + x1, y + h))
		path2.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x2, y + y1), CGPoint(x + w, y + y2)])
		path2.addLine(to: CGPoint(x + x1, y + h))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x + x1, y + h))
		path3.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x2, y + y1), CGPoint(x + w, y + y2), CGPoint(x + x1, y + h), CGPoint(x, y + h), CGPoint(x, y), CGPoint(x + w, y), CGPoint(x + w, y + y2)])
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(x1, h)]
		let textFrame = CGRect(x: x, y: y, width: w, height: y2)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func smiley(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1 = w * 0.228_9
		let x2 = w * 0.287_7
		let x3 = w * 0.608
		let x4 = w * 0.77
		let y1 = h * 0.35
		let y3 = h * 0.764
		let dy2 = modifiers[0] * h
		let y2 = y3 - dy2
		let y4 = y3 + dy2
		let dy3 = dy2 * 2
		let y5 = y4 + dy3
		let wR = 0.052 * w
		let hR = 0.052 * h

		let midx = w * 0.5

		// MARK: Unused

//		var controlPoint: [CGPoint]

		let path1 = CGMutablePath()
		path1.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + x1, y + y2))
		let cubicPoint = toCubicControlPoints(p1: CGPoint(x1, y2), cx1: midx, cy1: y5, p2: CGPoint(x4, y2))
		path2.addCurve(to: CGPoint(x + x4, y + y2), control1: CGPoint(x + cubicPoint[0], y + cubicPoint[1]), control2: CGPoint(x + cubicPoint[2], y + cubicPoint[3]))
		//        path3.addCurve(to: CGPoint(x + x1, y + y2), control1: CGPoint(x + cubicPoint[2], y + cubicPoint[3]), control2: CGPoint(x + cubicPoint[0], y + cubicPoint[1]))

		let path3 = CGMutablePath()
		path3.addEllipse(in: CGRect(x: x + x2, y: y + y1 - hR, width: 2 * wR, height: 2 * hR))
		path3.addEllipse(in: CGRect(x: x + x3, y: y + y1 - hR, width: 2 * wR, height: 2 * hR))

		let path4 = CGMutablePath()
		path4.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
		path4.addEllipse(in: CGRect(x: x + x2, y: y + y1 - hR, width: 2 * wR, height: 2 * hR))
		path4.addEllipse(in: CGRect(x: x + x3, y: y + y1 - hR, width: 2 * wR, height: 2 * hR))

		let pathArray = [path1, path2, path3, path4]
		let handles = [CGPoint(midx, y4)]
		let textFrame = self.setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func heart(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let dx1 = w * 49.0 / 48.0
		let dx2 = w * 9.0 / 48.0
		let midX = w * 0.5
		let x1 = midX - dx1
		let x2 = midX - dx2
		let x3 = midX + dx2
		let x4 = midX + dx1
		let y1 = -1.0 * h / 3.0
		let y2 = h / 4.0

		let path = CGMutablePath()
		path.move(to: CGPoint(x + midX, y + y2))
		path.addCurve(to: CGPoint(x + midX, y + h), control1: CGPoint(x + x3, y + y1), control2: CGPoint(x + x4, y + y2))
		path.addCurve(to: CGPoint(x + midX, y + y2), control1: CGPoint(x + x1, y + y2), control2: CGPoint(x + x2, y + y1))
		path.closeSubpath()

		let l = w * (1.0 / 6.0)
		let r = w * (5.0 / 6.0)
		let b = h * (2.0 / 3.0)

		let textFrame = CGRect(x: x + l, y: y + y2, width: r - l, height: b - y2)
		let animationFrame = frame
		let connector = [[midX, y2, 270], [midX, h, 90]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func lightningBolt(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1 = 0.392_2 * w
		let x2 = 0.595_4 * w
		let y2 = 0.281_4 * h
		let x3 = 0.511_5 * w
		let y3 = 0.314_6 * h
		let x4 = 0.767_4 * w
		let y4 = 0.555_8 * h
		let x5 = 0.683_6 * w
		let y5 = 0.596_1 * h
		let x6 = 0.463_5 * w
		let y6 = 0.690_5 * h
		let x7 = 0.565_8 * w
		let y7 = 0.647_5 * h
		let x8 = 0.232_5 * w
		let y8 = 0.449_3 * h
		let x9 = 0.351_9 * w
		let y9 = 0.388_0 * h
		let y10 = 0.180_09 * h

		let lineSegmentPoints = [
			CGPoint(x + x1, y),
			CGPoint(x + x2, y + y2),
			CGPoint(x + x3, y + y3),
			CGPoint(x + x4, y + y4),
			CGPoint(x + x5, y + y5),
			CGPoint(x + w, y + h),
			CGPoint(x + x6, y + y6),
			CGPoint(x + x7, y + y7),
			CGPoint(x + x8, y + y8),
			CGPoint(x + x9, y + y9),
			CGPoint(x, y + y10)
		]

		let path = CGMutablePath()
		path.move(to: CGPoint(x1, y))

		path.addLines(between: lineSegmentPoints)
		path.closeSubpath()

		let x_constant = w / 21_600.0
		let y_constant = h / 21_600.0
		let l = 8_757.0 * x_constant
		let t = 7_437.0 * y_constant
		let r = 13_917.0 * x_constant
		let b = 14_277.0 * y_constant

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[x1, 0, 270], [0, y10, 270], [x6, y6, 180], [x8, y8, 180], [w, h, 90], [x2, y2, 0], [x4, y4, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sun(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let maxX = w, maxY = h
		let xx = modifiers[0] * maxX
		let midx = maxX * 0.5
		let midy = maxY * 0.5
		let f0 = midx - xx
		let f0y = f0 * maxY / maxX

		let f1 = f0 * 0.923_8
		let f2 = f0 * 0.382_6
		let f1y = f0y * 0.932_8
		let f2y = f0y * 0.382_6

		let f5 = midx - f1
		let f6 = midx - f2
		let f5y = midy - f1y
		let f6y = midy - f2y

		let f7 = f5 * 0.75
		let f8 = f6 * 0.75

		let f7y = f5y * 0.75
		let f8y = f6y * 0.75

		let t1 = (0.036_62 * maxX)
		let f9 = f7 + t1
		let f10 = f8 + t1

		let t2 = (0.036_62 * maxY)
		let f9y = f7y + t2
		let f10y = f8y + t2

		let f11 = f8 + (0.125 * maxX)
		let f11y = f8y + (0.125 * maxY)

		let f12 = maxX - f7
		let f12y = maxY - f7y

		let f13 = maxX - f9
		let f13y = maxY - f9y

		let f14 = maxX - f10
		let f14y = maxY - f10y

		let f15 = maxX - f11
		let f15y = maxY - f11y

		let x1 = maxX * 0.853
		let y1 = maxY * 0.146_4
		let x2 = maxX * 0.146_4
		let y2 = maxY * 0.853

		let path = CGMutablePath()
		path.addEllipse(in: CGRect(x: x + midx - f0, y: y + midy - f0y, width: f0 + f0, height: f0y + f0y))

		path.move(to: CGPoint(x + maxX, y + midy))
		path.addLines(between: [CGPoint(x + maxX, y + midy), CGPoint(x + f12, y + f15y), CGPoint(x + f12, y + f11y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + x1, y + y1))
		path.addLines(between: [CGPoint(x + x1, y + y1), CGPoint(x + f13, y + f10y), CGPoint(x + f14, y + f9y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + midx, y))
		path.addLines(between: [CGPoint(x + midx, y), CGPoint(x + f15, y + f7y), CGPoint(x + f11, y + f7y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + x2, y + y1))
		path.addLines(between: [CGPoint(x + x2, y + y1), CGPoint(x + f10, y + f9y), CGPoint(x + f9, y + f10y)])
		path.closeSubpath()

		path.move(to: CGPoint(x, y + midy))
		path.addLines(between: [CGPoint(x, y + midy), CGPoint(x + f7, y + f11y), CGPoint(x + f7, y + f15y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + x2, y + y2))
		path.addLines(between: [CGPoint(x + x2, y + y2), CGPoint(x + f9, y + f14y), CGPoint(x + f10, y + f13y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + midx, y + maxY))
		path.addLines(between: [CGPoint(x + midx, y + maxY), CGPoint(x + f11, y + f12y), CGPoint(x + f15, y + f12y)])
		path.closeSubpath()

		path.move(to: CGPoint(x + x1, y + y2))
		path.addLines(between: [CGPoint(x + x1, y + y2), CGPoint(x + f14, y + f13y), CGPoint(x + f13, y + f14y)])
		path.closeSubpath()

		let angle1 = CGFloat(degreesToRadians(angle: 225))
		let angle2 = CGFloat(degreesToRadians(angle: 45))
		let a = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: f0, ry: f0y, mid: CGPoint(midx, midy))

		let handles = [CGPoint(xx, midy)]
		let textFrame = CGRect(x: x + a[0], y: y + a[1], width: a[2] - a[0], height: a[3] - a[1])
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func moon(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var controlPoint: [CGPoint]
		let width = w

		let f0 = modifiers[0] * width
		let midY = h * 0.5

		// MARK: Unused

//		let f1 = width - f0
//		let f2 = f0 * f0 / f1
//		let f3 = width * width / f1
//		let f4 = f3 * 2.0
//		let f5 = f4 - f2
//		let f6 = f5 - f0
//		let f7 = f5 * 0.5
//		let f8 = f7 - f0
//		let yy = abs((f8 * midY) / width)

		let x1 = f0

		// MARK: Unused

//		let x2 = f6
//		let x3 = abs(x2 - x1)
//		let xx = x3 * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + w, y))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + midY), framePoint2: CGPoint(x + w, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: w, ry: midY)
		path.addCurve(to: CGPoint(x, y + midY), control1: controlPoint[1], control2: controlPoint[0])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + h), framePoint2: CGPoint(x, y + midY), startAngle: 0.5 * .pi, endAngle: .pi, rx: w, ry: midY)
		path.addCurve(to: CGPoint(x + w, y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + h), framePoint2: CGPoint(x + x1, y + midY), startAngle: 0.5 * .pi, endAngle: .pi, rx: w - x1, ry: midY)
		path.addCurve(to: CGPoint(x + x1, y + midY), control1: controlPoint[0], control2: controlPoint[1])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + midY), framePoint2: CGPoint(x + w, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: w - x1, ry: midY)
		path.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])
		path.closeSubpath()

		let ss = min(w, h)
		let g0 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "y")
		let g12 = g0 * 0.3
		let l = (ss > 0) ? ((g12 * w) / ss) : CGFloat(0.0)
		let g13 = ss - l
		let q1 = ss * ss
		let q2 = g13 * g13
		let q3 = q1 - q2
		let q4 = sqrt(q3)
		let dy4 = (ss > 0) ? (q4 * midY / ss) : CGFloat(0.0)
		let t = midY - dy4
		let b = midY + dy4

		let handles = [CGPoint(x1, midY)]
		let textFrame = CGRect(x: x + l, y: y + t, width: x1 - l, height: b - t)
		let animationFrame = frame
		let connector = [[w, 0, 270], [0, midY, 180], [w, h, 90], [x1, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func cloud(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		var t: CGFloat = 21_600.0
		let tx = w / t
		let ty = h / t

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x + 1_950 * tx, y + 7_185 * ty))
		path1.addQuadCurve(to: CGPoint(x + 7_005 * tx, y + 2_580 * ty), control: CGPoint(x + 2_000 * tx, y + 500 * ty))
		path1.addQuadCurve(to: CGPoint(x + 11_250 * tx, y + 1_665 * ty), control: CGPoint(x + 9_000 * tx, y - 650 * ty))
		path1.addQuadCurve(to: CGPoint(x + 14_910 * tx, y + 1_170 * ty), control: CGPoint(x + 13_500 * tx, y - 700 * ty))
		path1.addQuadCurve(to: CGPoint(x + 19_140 * tx, y + 2_715 * ty), control: CGPoint(x + 18_000 * tx, y - 1_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 20_895 * tx, y + 7_665 * ty), control: CGPoint(x + 22_000 * tx, y + 4_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 18_690 * tx, y + 15_045 * ty), control: CGPoint(x + 22_500 * tx, y + 13_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 14_280 * tx, y + 18_330 * ty), control: CGPoint(x + 18_000 * tx, y + 20_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 8_235 * tx, y + 19_545 * ty), control: CGPoint(x + 12_000 * tx, y + 24_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 2_910 * tx, y + 17_640 * ty), control: CGPoint(x + 5_400 * tx, y + 22_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 1_080 * tx, y + 12_690 * ty), control: CGPoint(x - 300 * tx, y + 16_000 * ty))
		path1.addQuadCurve(to: CGPoint(x + 1_950 * tx, y + 7_185 * ty), control: CGPoint(x - 650 * tx, y + 9_000 * ty))
		path1.closeSubpath()

		let path2_sp1 = CGMutablePath()
		path2_sp1.move(to: CGPoint(x + 2_340 * tx, y + 13_080 * ty))
		path2_sp1.addQuadCurve(to: CGPoint(x + 1_080 * tx, y + 12_690 * ty), control: CGPoint(x + 1_500 * tx, y + 13_200 * ty))

		let path2_sp2 = CGMutablePath()
		path2_sp2.move(to: CGPoint(x + 3_465 * tx, y + 17_445 * ty))
		path2_sp2.addQuadCurve(to: CGPoint(x + 2_910 * tx, y + 17_640 * ty), control: CGPoint(x + 3_200 * tx, y + 17_500 * ty))

		let path2_sp3 = CGMutablePath()
		path2_sp3.move(to: CGPoint(x + 8_235 * tx, y + 19_545 * ty))
		path2_sp3.addQuadCurve(to: CGPoint(x + 7_905 * tx, y + 18_675 * ty), control: CGPoint(x + 8_100 * tx, y + 19_000 * ty))

		let path2_sp4 = CGMutablePath()
		path2_sp4.move(to: CGPoint(x + 14_400 * tx, y + 17_370 * ty))
		path2_sp4.addQuadCurve(to: CGPoint(x + 14_280 * tx, y + 18_330 * ty), control: CGPoint(x + 14_340 * tx, y + 17_800 * ty))

		let path2_sp5 = CGMutablePath()
		path2_sp5.move(to: CGPoint(x + 17_070 * tx, y + 11_475 * ty))
		path2_sp5.addQuadCurve(to: CGPoint(x + 18_690 * tx, y + 15_045 * ty), control: CGPoint(x + 18_600 * tx, y + 12_500 * ty))

		let path2_sp6 = CGMutablePath()
		path2_sp6.move(to: CGPoint(x + 20_895 * tx, y + 7_665 * ty))
		path2_sp6.addQuadCurve(to: CGPoint(x + 20_175 * tx, y + 9_015 * ty), control: CGPoint(x + 20_600 * tx, y + 8_600 * ty))

		let path2_sp7 = CGMutablePath()
		path2_sp7.move(to: CGPoint(x + 19_140 * tx, y + 2_715 * ty))
		path2_sp7.addQuadCurve(to: CGPoint(x + 19_200 * tx, y + 3_345 * ty), control: CGPoint(x + 19_170 * tx, y + 3_000 * ty))

		let path2_sp8 = CGMutablePath()
		path2_sp8.move(to: CGPoint(x + 14_550 * tx, y + 1_980 * ty))
		path2_sp8.addQuadCurve(to: CGPoint(x + 14_910 * tx, y + 1_170 * ty), control: CGPoint(x + 14_570 * tx, y + 1_600 * ty))

		let path2_sp9 = CGMutablePath()
		path2_sp9.move(to: CGPoint(x + 11_040 * tx, y + 2_340 * ty))
		path2_sp9.addQuadCurve(to: CGPoint(x + 11_250 * tx, y + 1_665 * ty), control: CGPoint(x + 11_170 * tx, y + 2_000 * ty))

		let path2_sp10 = CGMutablePath()
		path2_sp10.move(to: CGPoint(x + 7_005 * tx, y + 2_580 * ty))
		path2_sp10.addQuadCurve(to: CGPoint(x + 7_650 * tx, y + 3_270 * ty), control: CGPoint(x + 7_300 * tx, y + 2_800 * ty))

		let path2_sp11 = CGMutablePath()
		path2_sp11.move(to: CGPoint(x + 2_070 * tx, y + 7_890 * ty))
		path2_sp11.addQuadCurve(to: CGPoint(x + 1_950 * tx, y + 7_185 * ty), control: CGPoint(x + 2_010 * tx, y + 7_400 * ty))
		path2_sp11.closeSubpath()

		let l = 2_977 * tx
		t = 3_262 * ty
		let r = 17_087 * tx
		let b = 17_337 * ty
		let g27 = 67 * tx
		let g28 = 21_577 * ty
		let g29 = 21_582 * tx
		let g30 = 1_235 * ty
		let midX = w * 0.5
		let midY = h * 0.5

		let pathArray = [path1, path2_sp1, path2_sp2, path2_sp3, path2_sp4, path2_sp5, path2_sp6, path2_sp7, path2_sp8, path2_sp9, path2_sp10, path2_sp11]
		let pathProps = [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[g29, midY, 0], [midX, g28, 90], [g27, midY, 180], [midX, g30, 270]]
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps, connectors: connector)
	}

	// swiftlint:disable function_body_length
	func arc(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let path = CGMutablePath()

		let angle1 = modifiers[0]
		let angle2 = modifiers[1]
		let midX = w * 0.5
		let midY = h * 0.5
		let a: [CGFloat] = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]
		var m1: CGFloat, m2: CGFloat

		m1 = atan2((y1 - midY) * (midX / midY), x1 - midX)
		if m1 < 0 {
			m1 += 2 * .pi
		}

		m2 = atan2((y2 - midY) * (midX / midY), x2 - midX)
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

			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			path.move(to: framePoint1)
			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
			framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			path.move(to: framePoint1)
			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		// full quadrants
		quadrantNumber += 1

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(endAngle)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(endAngle)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
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
				framePoint1.x = x + w * 0.5 + w * 0.5 * cos(m1)
				framePoint1.y = y + h * 0.5 + h * 0.5 * sin(m1)
				endAngle = m2
			}
			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		} else {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = m2

			framePoint2.x = x + w * 0.5 + w * 0.5 * cos(m2)
			framePoint2.y = y + h * 0.5 + h * 0.5 * sin(m2)

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: midX, ry: midY)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
		}

		let c = CGFloat(degreesToRadians(angle: 360))
		let sw11 = angle2 - angle1
		let sw12 = sw11 + c
		let swAng = ifElse(First: sw11, Second: sw11, Third: sw12)

		let sw0 = c - angle1
		let da1 = swAng - sw0
		let g1 = (x1 > x2) ? x1 : x2
		let r = ifElse(First: da1, Second: w, Third: g1)
		let sw1 = CGFloat(degreesToRadians(angle: 90)) - angle1
		let sw2 = CGFloat(degreesToRadians(angle: 450)) - angle1
		let sw3 = ifElse(First: sw1, Second: sw1, Third: sw2)
		let da2 = swAng - sw3
		let g5 = (y1 > y2) ? y1 : y2
		let b = ifElse(First: da2, Second: h, Third: g5)
		let sw4 = CGFloat(degreesToRadians(angle: 180)) - angle1
		let sw5 = CGFloat(degreesToRadians(angle: 540)) - angle1
		let sw6 = ifElse(First: sw4, Second: sw4, Third: sw5)
		let da3 = swAng - sw6
		let g9 = (x1 < x2) ? x1 : x2
		let l = ifElse(First: da3, Second: 0, Third: g9)
		let sw7 = CGFloat(degreesToRadians(angle: 270)) - angle1
		let sw8 = CGFloat(degreesToRadians(angle: 630)) - angle1
		let sw9 = ifElse(First: sw7, Second: sw7, Third: sw8)
		let da4 = swAng - sw9
		let g13 = (y1 < y2) ? y1 : y2
		let t = ifElse(First: da4, Second: 0, Third: g13)

		let cang1 = (angle1 * (180.0 / .pi)) - 90
		let cang2 = (angle2 * (180.0 / .pi)) + 90
		let cang3 = (cang1 + cang2) * 0.5

		let handles = [CGPoint(x1, y1), CGPoint(x2, y2)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[x1, y1, cang1], [midX, midY, cang3], [x2, y2, cang2]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func doubleBracket(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let sY = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + sX, y))
		path.addArc(center: CGPoint(x + sX, y + f1), radius: w - sX, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + sY))
		path.addArc(center: CGPoint(x + sX, y + sY), radius: w - sX, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)

		path.move(to: CGPoint(x + f1, y + h))
		path.addArc(center: CGPoint(x + f1, y + sY), radius: f1, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x, y + f1))
		path.addArc(center: CGPoint(x + f1, y + f1), radius: f1, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)

		let l = f1 * 0.293
		let r = w - l
		let b = h - l

		let handles = [CGPoint(0, f1)]
		let textFrame = CGRect(x: x + l, y: y + l, width: r - l, height: b - l)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func doubleBrace(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.25, Type: "z")
		let midY = h * 0.5

		let x2 = f1 * 2
		let y2 = midY - f1
		let y3 = midY + f1
		let y4 = h - f1
		let x3 = w - x2
		let x4 = w - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x3, y))
		path.addArc(center: CGPoint(x + x3, y + f1), radius: f1, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + x4, y + y2))
		path.addArc(center: CGPoint(x + w, y + y2), radius: midY - y2, startAngle: .pi, endAngle: 0.5 * .pi, clockwise: true)
		path.addArc(center: CGPoint(x + w, y + y3), radius: y3 - midY, startAngle: 1.5 * .pi, endAngle: .pi, clockwise: true)
		path.addLine(to: CGPoint(x + x4, y + y4))
		path.addArc(center: CGPoint(x + x3, y + y4), radius: h - y4, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)

		path.move(to: CGPoint(x + x2, y + h))
		path.addArc(center: CGPoint(x + x2, y + y4), radius: h - y4, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x + f1, y + y3))
		path.addArc(center: CGPoint(x, y + y3), radius: y3 - midY, startAngle: 0, endAngle: 1.5 * .pi, clockwise: true)
		path.addArc(center: CGPoint(x, y + y2), radius: midY - y2, startAngle: 0.5 * .pi, endAngle: 0, clockwise: true)
		path.addLine(to: CGPoint(x + f1, y + f1))
		path.addArc(center: CGPoint(x + x2, y + f1), radius: f1, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)

		let t = f1 * 0.293
		let l = f1 + t
		let r = w - l
		let b = h - t

		let handles = [CGPoint(0, f1)]
		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftBracket(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let y1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "y")
		let y2 = h - y1
//		let midX = w * 0.5
		let midY = h * 0.5
		var controlPoint: [CGPoint]

		let path = CGMutablePath()
		path.move(to: CGPoint(x + w, y + h))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + h), framePoint2: CGPoint(x, y + y2), startAngle: 0.5 * .pi, endAngle: .pi, rx: w, ry: h - y2)
		path.addCurve(to: CGPoint(x, y + y2), control1: controlPoint[0], control2: controlPoint[1])
		path.addLine(to: CGPoint(x, y + y1))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + y1), framePoint2: CGPoint(x + w, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: w, ry: y1)
		path.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])

		let angle = CGFloat(degreesToRadians(angle: 45))
		let dx1 = w * cos(angle)
		let dy1 = y1 * sin(angle)
		let l = w - dx1
		let t = y1 - dy1
		let b = h + dy1 - y1

		let handles = [CGPoint(0, y1)]
		let textFrame = CGRect(x: x + l, y: y + t, width: w - l, height: b - t)
		let animationFrame = frame
		let connector = [[w, 0, 90], [0, midY, 180], [w, h, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func rightBracket(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let y1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 0.5, Type: "y")
		let y2 = h - y1
		let midY = h * 0.5
		var controlPoint: [CGPoint]

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y), framePoint2: CGPoint(x + w, y + y1), startAngle: 1.5 * .pi, endAngle: 0, rx: w, ry: y1)
		path.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])
		path.addLine(to: CGPoint(x + w, y + y2))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y2), framePoint2: CGPoint(x, y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: w, ry: h - y2)
		path.addCurve(to: CGPoint(x, y + h), control1: controlPoint[0], control2: controlPoint[1])

		let angle = CGFloat(degreesToRadians(angle: 45))
		let dx1 = w * cos(angle)
		let dy1 = y1 * sin(angle)
		let t = y1 - dy1
		let b = h + dy1 - y1

		let handles = [CGPoint(w, y1)]
		let textFrame = CGRect(x: x, y: y + t, width: dx1, height: b - t)
		let animationFrame = frame
		let connector = [[0, 0, 90], [0, h, 270], [w, midY, 180]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftBrace(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let a = self.checkBraceMax(width: w, height: h, modifiers: modifiers)
		let yy = a[0]
		let y1 = a[1]
		let y2 = yy - y1
		let y3 = yy + y1
		let y4 = h - y1
		var controlPoint: [CGPoint]

		let path = CGMutablePath()
		path.move(to: CGPoint(x + w, y + h))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + h), framePoint2: CGPoint(x + midX, y + y4), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x + midX, y + y4), control1: controlPoint[0], control2: controlPoint[1])

		path.addLine(to: CGPoint(x + midX, y + y3))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + yy), framePoint2: CGPoint(x + midX, y + y3), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x, y + yy), control1: controlPoint[1], control2: controlPoint[0])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + yy), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[1], control2: controlPoint[0])

		path.addLine(to: CGPoint(x + midX, y + y1))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y1), framePoint2: CGPoint(x + w, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])

		let angle = CGFloat(degreesToRadians(angle: 45))
		let dx1 = midX * cos(angle)
		let dy1 = y1 * sin(angle)
		let l = w - dx1
		let t = y1 - dy1
		let b = h + dy1 - y1

		let handles = [CGPoint(midX, y1), CGPoint(0, y)]
		let textFrame = CGRect(x: x + l, y: y + t, width: w - l, height: b - t)
		let animationFrame = frame
		let connector = [[w, 0, 90], [0, y, 180], [w, h, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func rightBrace(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let a = self.checkBraceMax(width: w, height: h, modifiers: modifiers)
		let yy = a[0]
		let y1 = a[1]
		let y2 = yy - y1
		let y3 = yy + y1
		let y4 = h - y1
		var controlPoint: [CGPoint]

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y), framePoint2: CGPoint(x + midX, y + y1), startAngle: 1.5 * .pi, endAngle: 0, rx: midX, ry: y1)
		path.addCurve(to: CGPoint(x + midX, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path.addLine(to: CGPoint(x + midX, y + y2))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + yy), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0.5 * .pi, endAngle: .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x + w, y + yy), control1: controlPoint[1], control2: controlPoint[0])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y3), framePoint2: CGPoint(x + w, y + yy), startAngle: .pi, endAngle: 1.5 * .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x + midX, y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path.addLine(to: CGPoint(x + midX, y + y4))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y4), framePoint2: CGPoint(x, y + h), startAngle: 0, endAngle: 0.5 * .pi, rx: midX, ry: h - y4)
		path.addCurve(to: CGPoint(x, y + h), control1: controlPoint[0], control2: controlPoint[1])

		let angle = CGFloat(degreesToRadians(angle: 45))
		let dx1 = midX * cos(angle)
		let dy1 = y1 * sin(angle)
		let t = y1 - dy1
		let b = h + dy1 - y1

		let handles = [CGPoint(midX, y1), CGPoint(w, y)]
		let textFrame = CGRect(x: x, y: y + t, width: dx1, height: b - t)
		let animationFrame = frame
		let connector = [[0, 0, 90], [w, y, 180], [0, h, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func clock(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ry = h * 0.5
		let rx = w * 0.5

		let midY = h * 0.5
		let midX = w * 0.5

		let rx1 = rx * 0.03
		let ry1 = ry * 0.03

		let path = CGMutablePath()
		path.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
		path.addEllipse(in: CGRect(x: x + midX - rx1, y: y + midY - ry1, width: 2 * rx1, height: 2 * ry1))

		let rx2 = 0.96 * rx
		let ry2 = 0.96 * ry

		var rx3: CGFloat = 0.0, ry3: CGFloat = 0.0
		var n = 30

		while n < 361 {
			if n.isMultiple(of: 90) {
				rx3 = 0.84 * rx
				ry3 = 0.84 * ry
			} else {
				rx3 = 0.9 * rx
				ry3 = 0.9 * ry
			}

			let rad1 = CGFloat(degreesToRadians(angle: n))
			let a = self.getEllipseCoordinates(angle1: rad1, angle2: -1_000, rx: rx2, ry: ry2, mid: CGPoint(midX, midY))
			let a1 = self.getEllipseCoordinates(angle1: rad1, angle2: -1_000, rx: rx3, ry: ry3, mid: CGPoint(midX, midY))

			path.move(to: CGPoint(x + a[0], y + a[1]))
			path.addLine(to: CGPoint(x + a1[0], y + a1[1]))
			n += 30
		}

		var angle1 = modifiers[0]
		var angle2 = modifiers[1]

		let rx4 = 0.75 * rx
		let ry4 = 0.75 * ry

		let rx5 = 0.6 * rx
		let ry5 = 0.6 * ry

		let h1 = self.getEllipseCoordinates(angle1: angle1, angle2: -1_000, rx: rx4, ry: ry4, mid: CGPoint(midX, midY))
		let h2 = self.getEllipseCoordinates(angle1: angle2, angle2: -1_000, rx: rx5, ry: ry5, mid: CGPoint(midX, midY))

		path.move(to: CGPoint(x + h1[0], y + h1[1]))
		path.addLine(to: CGPoint(x + midX, y + midY))

		path.move(to: CGPoint(x + h2[0], y + h2[1]))
		path.addLine(to: CGPoint(x + midX, y + midY))

		angle1 = CGFloat(degreesToRadians(angle: 225))
		angle2 = CGFloat(degreesToRadians(angle: 45))
		let a = self.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx3, ry: ry3, mid: CGPoint(midX, midY))

		let handles = [CGPoint(h1[0], h1[1]), CGPoint(h2[0], h2[1])]
		let textFrame = CGRect(x: x + a[0], y: y + a[1], width: a[2] - a[0], height: a[3] - a[1])
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}
}

// swiftlint:enable file_length
