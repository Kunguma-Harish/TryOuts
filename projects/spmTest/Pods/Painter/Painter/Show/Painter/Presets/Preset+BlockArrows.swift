//
//  Preset+BlockArrows.swift
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
	// swiftlint:disable function_parameter_count
	func drawArrrow(x0: CGFloat, x1: CGFloat, x2: CGFloat, y0: CGFloat, y1: CGFloat, y2: CGFloat, y3: CGFloat, yy: CGFloat, x: CGFloat, y: CGFloat) -> CGPath {
		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLine(to: CGPoint(x + x1, y + y0))
		path.addLine(to: CGPoint(x + x2, y + yy))
		path.addLine(to: CGPoint(x + x1, y + y3))
		path.addLine(to: CGPoint(x + x1, y + y2))
		path.addLine(to: CGPoint(x + x0, y + y2))
		path.addLine(to: CGPoint(x + x0, y + y1))
		path.closeSubpath()
		return path
	}

	func drawVerticleArrow(y0: CGFloat, y1: CGFloat, y2: CGFloat, x0: CGFloat, x1: CGFloat, x2: CGFloat, x3: CGFloat, xx: CGFloat, x: CGFloat, y: CGFloat) -> CGPath {
		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLine(to: CGPoint(x + x1, y + y2))
		path.addLine(to: CGPoint(x + x2, y + y2))
		path.addLine(to: CGPoint(x + x2, y + y1))
		path.addLine(to: CGPoint(x + x3, y + y1))
		path.addLine(to: CGPoint(x + xx, y + y0))
		path.addLine(to: CGPoint(x + x0, y + y1))
		path.closeSubpath()
		return path
	}

	// swiftlint:enable function_parameter_count
	func computeCurvedArrowValuesModifiers(maxX: CGFloat, maxY: CGFloat, yVal: Bool, m: [CGFloat]) -> [CGFloat] {
		var mid = maxY * 0.5
		if yVal {
			mid = maxX * 0.5
		}

		var param: Character = "y"
		if yVal {
			param = "x"
		}

		let aw = getCoordinates(m[1], Width: maxX, Height: maxY, Percent: 0.5, Type: param)
		let th = getCoordinates(m[0], Width: maxX, Height: maxY, Percent: m[1], Type: "z")
		let q1 = (th + aw) * 0.25
		let hR = mid - q1
		let q7 = hR * 2
		let q8 = q7 * q7
		let q9 = th * th
		var q10 = q8 - q9
		if q10 < 0 {
			q10 = 0
		}

		let q11 = sqrt(q10)
		var idx = q11 * maxX / q7
		if yVal {
			idx = q11 * maxY / q7
		}

		var val = idx / maxX
		if yVal {
			val = idx / maxY
		}

		var param1: Character = "x"
		if yVal {
			param1 = "y"
		}

		let ah = getCoordinates(m[2], Width: maxX, Height: maxY, Percent: val, Type: param1)
		return [th, aw, ah, hR, idx]
	}

	func rightArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let yy = modifiers[0] * h
		let y1 = (h - yy) * 0.5
		let dx = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "x")
		let x1 = w - dx
		let y2 = h - y1
		let midY = h * 0.5

		let path = self.drawArrrow(x0: 0, x1: x1, x2: w, y0: 0, y1: y1, y2: y2, y3: h, yy: midY, x: x, y: y)
		let x2 = y1 * dx / midY
		let r = x1 + x2

		let handles = [CGPoint(0, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x, y: y + y1, width: r, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x1, 0, 270], [0, midY, 180], [x1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let yy = modifiers[0] * h
		let y1 = (h - yy) * 0.5
		let x1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "x")
		let y2 = h - y1
		let midY = h * 0.5

		let path = self.drawArrrow(x0: w, x1: x1, x2: 0, y0: h, y1: y2, y2: y1, y3: 0, yy: midY, x: x, y: y)
		let dx = y1 * x1 / midY
		let l = x1 - dx

		let handles = [CGPoint(w, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x + l, y: y + y1, width: w - l, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x1, 0, 270], [0, midY, 180], [x1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func upArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let xx = modifiers[0] * w
		let x1 = (w - xx) * 0.5
		let y1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "y")
		let x2 = w - x1
		let midX = w * 0.5

		let path = self.drawVerticleArrow(y0: 0, y1: y1, y2: h, x0: 0, x1: x1, x2: x2, x3: w, xx: midX, x: x, y: y)
		let dy = x1 * y1 / midX
		let t = y1 - dy

		let handles = [CGPoint(x1, h), CGPoint(0, y1)]
		let textFrame = CGRect(x: x + x1, y: y + t, width: x2 - x1, height: h - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, y1, 180], [midX, h, 90], [w, y1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func downArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let xx = modifiers[0] * w
		let x1 = (w - xx) * 0.5
		let dy = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "y")
		let y1 = h - dy
		let x2 = w - x1
		let midX = w * 0.5

		let path = self.drawVerticleArrow(y0: h, y1: y1, y2: 0, x0: w, x1: x2, x2: x1, x3: 0, xx: midX, x: x, y: y)
		let dy1 = x1 * dy / midX
		let b = y1 + dy1

		let handles = [CGPoint(x1, 0), CGPoint(0, y1)]
		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: b)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, y1, 180], [midX, h, 90], [w, y1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func upDownArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let xx = modifiers[0] * w
		let x1 = (w - xx) * 0.5
		let y1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "y")
		let y2 = h - y1
		let x2 = w - x1
		let midX = w * 0.5
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLines(between: [CGPoint(x + x1, y + y1), CGPoint(x + x1, y + y2), CGPoint(x, y + y2), CGPoint(x + midX, y + h), CGPoint(x + w, y + y2), CGPoint(x + x2, y + y2), CGPoint(x + x2, y + y1), CGPoint(x + w, y + y1), CGPoint(x + midX, y), CGPoint(x, y + y1)])
		path.closeSubpath()

		let dy = x1 * y1 / midX
		let t = y1 - dy
		let b = y2 + dy

		let handles = [CGPoint(x1, y2), CGPoint(0, y1)]
		let textFrame = CGRect(x: x + x1, y: y + t, width: x2 - x1, height: b - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, y2, 180], [x1, midY, 180], [0, y1, 180], [midX, h, 90], [w, y2, 0], [x2, midY, 0], [w, y1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftRightArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let yy = modifiers[0] * w
		let y1 = (h - yy) * 0.5
		let x1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "x")
		let x2 = w - x1
		let y2 = h - y1
		let midY = h * 0.5
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x2, y + y1))
		path.addLines(between: [CGPoint(x + x2, y + y1), CGPoint(x + x2, y), CGPoint(x + w, y + midY), CGPoint(x + x2, y + h), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + x1, y + h), CGPoint(x, y + midY), CGPoint(x + x1, y), CGPoint(x + x1, y + y1)])
		path.closeSubpath()

		let dx = y1 * x1 / midY
		let l = x1 - dx
		let r = x2 + dx

		let handles = [CGPoint(x2, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x + l, y: y + y1, width: r - l, height: y2 - y1)
		let animationFrame = frame
		let connector = [[w, midY, 0], [x2, h, 90], [midX, y2, 90], [x1, h, 90], [0, midY, 180], [x1, 0, 270], [x2, 0, 270], [midX, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func quadArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let f = computeArrowValuesModifiers(ww: w, hh: h, m: modifiers)
		let x1 = midX - f[0]
		let x2 = midX - f[1]
		let x3 = midX + f[1]
		let x4 = midX + f[0]

		let y1 = midY - f[0]
		let y2 = midY - f[1]
		let y3 = midY + f[1]
		let y4 = midY + f[0]

		let f5 = f[2]
		let x6 = w - f5
		let y6 = h - f5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + f5))
		path.addLines(between: [CGPoint(x + x1, y + f5), CGPoint(x + midX, y), CGPoint(x + x4, y + f5), CGPoint(x + x3, y + f5), CGPoint(x + x3, y + y2), CGPoint(x + x6, y + y2), CGPoint(x + x6, y + y1), CGPoint(x + w, y + midY), CGPoint(x + x6, y + y4), CGPoint(x + x6, y + y3), CGPoint(x + x3, y + y3), CGPoint(x + x3, y + y6), CGPoint(x + x4, y + y6), CGPoint(x + midX, y + h), CGPoint(x + x1, y + y6), CGPoint(x + x2, y + y6), CGPoint(x + x2, y + y3), CGPoint(x + f5, y + y3), CGPoint(x + f5, y + y4), CGPoint(x, y + midY), CGPoint(x + f5, y + y1), CGPoint(x + f5, y + y2), CGPoint(x + x2, y + y2), CGPoint(x + x2, y + f5)])
		path.closeSubpath()

		let l = f[1] * f[2] / f[0]
		let r = w - l

		let handles = [CGPoint(x2, f5), CGPoint(x1, 0), CGPoint(w, f5)]
		let textFrame = CGRect(x: x + l, y: y + y2, width: r - l, height: y3 - y2 * 2)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftRightUpArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let f = computeArrowValuesModifiers(ww: w, hh: h, m: modifiers)
		let x1 = midX - f[0]
		let x2 = midX - f[1]
		let x3 = midX + f[1]
		let x4 = midX + f[0]

		let y3 = h - f[0]
		let y4 = y3 + f[1]
		let y1 = h - (2 * f[0])
		let y2 = y3 - f[1]

		let f5 = f[2]
		let x6 = w - f5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + f5))
		path.addLines(between: [CGPoint(x + x1, y + f5), CGPoint(x + midX, y), CGPoint(x + x4, y + f5), CGPoint(x + x3, y + f5), CGPoint(x + x3, y + y2), CGPoint(x + x6, y + y2), CGPoint(x + x6, y + y1), CGPoint(x + w, y + y3), CGPoint(x + x6, y + h), CGPoint(x + x6, y + y4), CGPoint(x + f5, y + y4), CGPoint(x + f5, y + h), CGPoint(x, y + y3), CGPoint(x + f5, y + y1), CGPoint(x + f5, y + y2), CGPoint(x + x2, y + y2), CGPoint(x + x2, y + f5)])
		path.closeSubpath()

		let l = f[1] * f5 / f[0]
		let r = w - l

		let handles = [CGPoint(x2, f5), CGPoint(x1, 0), CGPoint(w, f5)]
		let textFrame = CGRect(x: x + l, y: y + y2, width: r - l, height: y3 - y2)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, y3, 180], [midX, y4, 90], [w, y3, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func bentArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ss = min(w, h)
		let aw2 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "z")
		let th = getCoordinates(modifiers[0], Width: w, Height: h, Percent: modifiers[1] * 2, Type: "z")
		var th2 = th * 0.5
		var dh2 = aw2 - th2
		let ah = getCoordinates(modifiers[2], Width: w, Height: h, Percent: 0.5, Type: "z")
		let bw = w - ah
		let bh = h - dh2
		let bs = min(bh, bw)
		let bd = getCoordinates(modifiers[3], Width: w, Height: h, Percent: bs / ss, Type: "z")

		dh2 = aw2 - (th * 0.5)
		th2 = th * 0.5

		let bd3 = bd - th
		let bd2 = max(bd3, 0)
		let x3 = th + bd2
		let x4 = w - ah
		let y3 = dh2 + th
		let y4 = y3 + dh2
		let y5 = dh2 + bd

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + h))
		path.addLine(to: CGPoint(x, y + y5))
		path.addArc(center: CGPoint(x + y5 - dh2, y + y5), radius: y5 - dh2, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + x4, y + dh2))
		path.addLine(to: CGPoint(x + x4, y))
		path.addLine(to: CGPoint(x + w, y + aw2))
		path.addLine(to: CGPoint(x + x4, y + y4))
		path.addLine(to: CGPoint(x + x4, y + y3))
		path.addLine(to: CGPoint(x + x3, y + y3))

		path.addArc(center: CGPoint(x + x3, y + y3 + bd2), radius: bd2, startAngle: 1.5 * .pi, endAngle: .pi, clockwise: true)
		path.addLine(to: CGPoint(x + th, y + h))
		path.closeSubpath()

		let handles = [CGPoint(th, h), CGPoint(w, y4), CGPoint(x4, 0), CGPoint(bd, 0)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[x4, 0, 270], [x4, y4, 90], [th2, h, 90], [w, aw2, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func uTurnArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ss = min(w, h)
		let f1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "z")
		let f0 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: modifiers[1] * 2, Type: "z")

		var y4 = modifiers[4] * h
		y4 = max(y4, f0 + modifiers[2] * ss)

		let f3 = getCoordinates(modifiers[2], Width: w, Height: h, Percent: (y4 - f0) / h, Type: "y")
		var y3 = y4 - f3
		var f5 = f1 - (f0 * 0.5)
		var max1 = (w - f5) * 0.5

		let ss1 = y3
		if ss1 < max1 {
			max1 = ss1
		}

		let f2 = getCoordinates(modifiers[3], Width: w, Height: h, Percent: max1 / w, Type: "x")
		y3 = y4 - f3

		let mx1 = f1 * 2
		f5 = (mx1 - f0) * 0.5

		let x6 = w - f5
		let x7 = x6 - f2
		let x5 = w - f1
		let x3 = x5 - f1
		let x4 = x3 + f5

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + h))
		path.addLine(to: CGPoint(x, y + f2))
		path.addArc(center: CGPoint(x + f2, y + f2), radius: f2, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + x7, y))
		path.addArc(center: CGPoint(x + x7, y + f2), radius: x6 - x7, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + x6, y + y3))
		path.addLine(to: CGPoint(x + w, y + y3))
		path.addLine(to: CGPoint(x + x5, y + y4))
		path.addLine(to: CGPoint(x + x3, y + y3))
		path.addLine(to: CGPoint(x + x4, y + y3))

		if f2 > f0 {
			path.addLine(to: CGPoint(x + x4, y + f2))
			path.addArc(center: CGPoint(x + x7, y + f2), radius: f0 - f2, startAngle: .pi, endAngle: 0.5 * .pi, clockwise: true)
			path.addLine(to: CGPoint(x + f2, y + f0))
			path.addArc(center: CGPoint(x + f2, y + f2), radius: f0 - f2, startAngle: 0.5 * .pi, endAngle: 0, clockwise: true)
			path.addLine(to: CGPoint(x + f0, y + h))
		} else {
			path.addLine(to: CGPoint(x + x4, y + f0))
			path.addLine(to: CGPoint(x + f0, y + f0))
			path.addLine(to: CGPoint(x + f0, y + h))
		}
		path.closeSubpath()

		let c1 = f0 * 0.5
		let c2 = (f0 + x4) * 0.5
		let handles = [CGPoint(f0, h), CGPoint(x3, h), CGPoint(x3, y3), CGPoint(f2, 0), CGPoint(w, y4)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[w, y3, 0], [x5, y4, 90], [x3, y3, 90], [c1, h, 90], [c2, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftUpArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let ss = min(w, h)
		let f0 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "z")
		var f1 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: modifiers[1] * 2, Type: "z")
		let t = ss - (f0 * 2)
		let f2 = getCoordinates(modifiers[2], Width: w, Height: h, Percent: t / h, Type: "y")

		f1 *= 0.5
		let mm = f0
		let mx = w - mm
		let x1 = w - f0 * 2
		let y1 = f2
		let d = f0 - f1
		let diff = d
		let x2 = w - diff
		let y2 = h - diff
		let x3 = f2
		let my = h - mm
		let y3 = h - f0 * 2
		let y4 = y3 + diff
		let x4 = x1 + diff

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLines(between: [CGPoint(x + x1, y + y1), CGPoint(x + mx, y), CGPoint(x + w, y + y1), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x3, y + y2), CGPoint(x + x3, y + h), CGPoint(x, y + my), CGPoint(x + x3, y + y3), CGPoint(x + x3, y + y4), CGPoint(x + x4, y + y4), CGPoint(x + x4, y + y1)])
		path.closeSubpath()

//		let l = (f0 * 2 * x2) / f1
		let c1 = (y1 + y2) * 0.5
		let c2 = (x2 + x3) * 0.5

		let handles = [CGPoint(x4, y1), CGPoint(x1, 0), CGPoint(w, f2)]
		let textFrame = CGRect(x: x, y: y + y4, width: mx, height: h - y2)
		let animationFrame = frame
		let connector = [[mx, 0, 270], [w, f2, 0], [x2, c1, 0], [c2, y2, 90], [f2, h, 90], [0, my, 180], [x3, y3, 270], [x4, y1, 180]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func bentUpArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.5, Type: "z")
		let f0 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: modifiers[1] * 2, Type: "z")
		let f2 = getCoordinates(modifiers[2], Width: w, Height: h, Percent: 0.5, Type: "z")
		let tx = 2 * f1
		let tx1 = (tx - f0) * 0.5
		let y1 = h - f0
		let x1 = w - tx
		let x2 = x1 + tx1
		let x3 = x1 + f1
		let x4 = w - tx1

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + y1))
		path.addLines(between: [CGPoint(x, y + y1), CGPoint(x, y + h), CGPoint(x + x4, y + h), CGPoint(x + x4, y + f2), CGPoint(x + w, y + f2), CGPoint(x + x3, y), CGPoint(x + x1, y + f2), CGPoint(x + x2, y + f2), CGPoint(x + x2, y + y1)])
		path.closeSubpath()

		let c1 = (f2 + h) * 0.5
		let c2 = x4 * 0.5
		let c3 = (y1 + h) * 0.5

		let handles = [CGPoint(0, y1), CGPoint(x1, 0), CGPoint(w, f2)]
		let textFrame = CGRect(x: x, y: y + y1, width: x4, height: h - y1)
		let animationFrame = frame
		let connector = [[w, f2, 0], [x4, c1, 0], [c2, h, 90], [0, c3, 180], [x1, f2, 180], [x3, 0, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:disable function_body_length
	func curvedRightArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f = self.computeCurvedArrowValuesModifiers(maxX: w, maxY: h, yVal: false, m: modifiers)
		let th = f[0]
		let aw = f[1]
		let ah = f[2]
		let hR = f[3]
		let idx = f[4]
		let y3 = hR + th
		let q2 = w * w
		let q3 = ah * ah
		let q4 = q2 - q3
		let q5 = sqrt(q4)
		let dy = q5 * hR / w
		let y5 = hR + dy
		let y7 = y3 + dy
		let q6 = aw - th
		let dh = q6 * 0.5
		let y4 = y5 - dh
		let y8 = y7 + dh
		let aw2 = aw * 0.5
		let y6 = h - aw2
		let x1 = w - ah
		let iy = (hR + y3) * 0.5
		let ix = w - idx
		let yv = y3 - hR

		var controlPoint: [CGPoint]
		var m1: CGFloat, m2: CGFloat

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + hR))

		m1 = atan2((y5 - hR) * (w / hR), x1 - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((hR - hR) * (w / hR), 0 - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + y5), framePoint2: CGPoint(x, y + hR), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path1.addCurve(to: CGPoint(x + x1, y + y5), control1: controlPoint[1], control2: controlPoint[0])
		path1.addLine(to: CGPoint(x + x1, y + y4))
		path1.addLine(to: CGPoint(x + w, y + y6))
		path1.addLine(to: CGPoint(x + x1, y + y8))
		path1.addLine(to: CGPoint(x + x1, y + y7))

		m1 = atan2((y7 - (yv + hR)) * (w / hR), x1 - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((y3 - (yv + hR)) * (w / hR), 0 - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + y7), framePoint2: CGPoint(x, y + y3), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path1.addCurve(to: CGPoint(x, y + y3), control1: controlPoint[0], control2: controlPoint[1])
		path1.closeSubpath()

		m1 = atan2((iy - (yv + hR)) * (w / hR), ix - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((th - (yv + hR)) * (w / hR), w - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + w, y + th))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + ix, y + iy), framePoint2: CGPoint(x + w, y + th), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path2.addCurve(to: CGPoint(x + ix, y + iy), control1: controlPoint[1], control2: controlPoint[0])

		m1 = atan2((iy - hR) * (w / hR), ix - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((0 - hR) * (w / hR), w - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + ix, y + iy), framePoint2: CGPoint(x, y + hR), startAngle: m1, endAngle: .pi, rx: w, ry: hR)
		path2.addCurve(to: CGPoint(x, y + hR), control1: controlPoint[0], control2: controlPoint[1])
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + hR), framePoint2: CGPoint(x + w, y), startAngle: .pi, endAngle: m2, rx: w, ry: hR)
		path2.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x, y + hR))

		m1 = atan2((y5 - hR) * (w / hR), x1 - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((hR - hR) * (w / hR), 0 - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + y5), framePoint2: CGPoint(x, y + hR), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + x1, y + y5), control1: controlPoint[1], control2: controlPoint[0])
		path3.addLine(to: CGPoint(x + x1, y + y4))
		path3.addLine(to: CGPoint(x + w, y + y6))
		path3.addLine(to: CGPoint(x + x1, y + y8))
		path3.addLine(to: CGPoint(x + x1, y + y7))

		m1 = atan2((y7 - (yv + hR)) * (w / hR), x1 - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((y3 - (yv + hR)) * (w / hR), 0 - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + y7), framePoint2: CGPoint(x, y + y3), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x, y + y3), control1: controlPoint[0], control2: controlPoint[1])
		path3.addLine(to: CGPoint(x, y + hR))

		m1 = atan2((hR - hR) * (w / hR), 0 - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((0 - hR) * (w / hR), w - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + hR), framePoint2: CGPoint(x + w, y), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])
		path3.addLine(to: CGPoint(x + w, y + th))

		m1 = atan2((iy - (yv + hR)) * (w / hR), ix - w)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((th - (yv + hR)) * (w / hR), w - w)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + ix, y + iy), framePoint2: CGPoint(x + w, y + th), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + ix, y + iy), control1: controlPoint[1], control2: controlPoint[0])

		let c1 = th * 0.5
		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(x1, y5), CGPoint(w, y4), CGPoint(x1, h)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[0, iy, 180], [x1, h, 90], [w, y6, 0], [x1, y4, 0], [w, c1, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func curvedLeftArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f = self.computeCurvedArrowValuesModifiers(maxX: w, maxY: h, yVal: false, m: modifiers)
		let th = f[0]
		let aw = f[1]
		let ah = f[2]
		let hR = f[3]
		let idx = f[4]
		let y3 = hR + th
		let q2 = w * w
		let q3 = ah * ah
		let q4 = q2 - q3
		let q5 = sqrt(q4)
		let dy = q5 * hR / w
		let y5 = hR + dy
		let y7 = y3 + dy
		let q6 = aw - th
		let dh = q6 * 0.5
		let y4 = y5 - dh
		let y8 = y7 + dh
		let aw2 = aw * 0.5
		let y6 = h - aw2
		let x1 = ah
		let iy = (hR + y3) * 0.5

		var controlPoint: [CGPoint]
		var m1: CGFloat, m2: CGFloat

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + y6))
		path1.addLine(to: CGPoint(x + x1, y + y4))
		path1.addLine(to: CGPoint(x + x1, y + y5))

		m1 = atan2((iy - hR) * (w / hR), idx)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((y5 - hR) * (w / hR), x1)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + idx, y + iy), framePoint2: CGPoint(x + x1, y + y5), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path1.addCurve(to: CGPoint(x + idx, y + iy), control1: controlPoint[1], control2: controlPoint[0])

		m1 = atan2((iy - (th + hR)) * (w / hR), idx)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		var framePoint = CGPoint(0, 0)
		framePoint.x = x + w * cos(0)
		framePoint.y = y + (th + hR) + hR * sin(0)
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + idx, y + iy), framePoint2: framePoint, startAngle: m1, endAngle: 0, rx: w, ry: hR)
		path1.addCurve(to: framePoint, control1: controlPoint[0], control2: controlPoint[1])

		m2 = atan2((y7 - (th + hR)) * (w / hR), x1)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: framePoint, framePoint2: CGPoint(x + x1, y + y7), startAngle: 0, endAngle: m2, rx: w, ry: hR)
		path1.addCurve(to: CGPoint(x + x1, y + y7), control1: controlPoint[0], control2: controlPoint[1])
		path1.addLine(to: CGPoint(x + x1, y + y8))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + w, y + y3))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + th), framePoint2: CGPoint(x + w, y + y3), startAngle: 1.5 * .pi, endAngle: 0, rx: w, ry: hR)
		path2.addCurve(to: CGPoint(x, y + th), control1: controlPoint[1], control2: controlPoint[0])

		path2.addLine(to: CGPoint(x, y))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y), framePoint2: CGPoint(x + w, y + hR), startAngle: 1.5 * .pi, endAngle: 0, rx: w, ry: hR)
		path2.addCurve(to: CGPoint(x + w, y + hR), control1: controlPoint[0], control2: controlPoint[1])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x + w, y + y3))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + th), framePoint2: CGPoint(x + w, y + y3), startAngle: 1.5 * .pi, endAngle: 0, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x, y + th), control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x, y))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y), framePoint2: CGPoint(x + w, y + hR), startAngle: 1.5 * .pi, endAngle: 0, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + w, y + hR), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + w, y + y3))

		m2 = atan2((y7 - (th + hR)) * (w / hR), x1)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: framePoint, framePoint2: CGPoint(x + x1, y + y7), startAngle: 0, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + x1, y + y7), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + x1, y + y8))
		path3.addLine(to: CGPoint(x, y + y6))
		path3.addLine(to: CGPoint(x + x1, y + y4))
		path3.addLine(to: CGPoint(x + x1, y + y5))

		m1 = atan2((iy - hR) * (w / hR), idx)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((y5 - hR) * (w / hR), x1)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + idx, y + iy), framePoint2: CGPoint(x + x1, y + y5), startAngle: m1, endAngle: m2, rx: w, ry: hR)
		path3.addCurve(to: CGPoint(x + idx, y + iy), control1: controlPoint[1], control2: controlPoint[0])

		let c2 = th * 0.5
		let cang = CGFloat(120)
		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(x1, y5), CGPoint(0, y4), CGPoint(x1, h)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[0, c2, 180], [x1, y4, 180], [0, y6, cang], [x1, y8, 90], [w, iy, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func curvedUpArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f = self.computeCurvedArrowValuesModifiers(maxX: w, maxY: h, yVal: true, m: modifiers)
		let th = f[0]
		let aw = f[1]
		let ah = f[2]
		let wR = f[3]
		let idy = f[4]
		let x3 = wR + th
		let q2 = h * h
		let q3 = ah * ah
		let q4 = q2 - q3
		let q5 = sqrt(q4)
		let dx = q5 * wR / h
		let x5 = wR + dx
		let x7 = x3 + dx
		let q6 = aw - th
		let dh = q6 * 0.5
		let x4 = x5 - dh
		let x8 = x7 + dh
		let aw2 = aw * 0.5
		let x6 = w - aw2
		let y1 = ah
		let ix = (wR + x3) * 0.5

		var controlPoint: [CGPoint]
		var m1: CGFloat, m2: CGFloat

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x + x6, y))
		path1.addLine(to: CGPoint(x + x8, y + y1))
		path1.addLine(to: CGPoint(x + x7, y + y1))

		m1 = atan2(y1 * (wR / h), x7 - (th + wR))
		if m1 < 0 {
			m1 += 2 * .pi
		}

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + y1), framePoint2: CGPoint(x + th + wR, y + h), startAngle: m1, endAngle: 0.5 * .pi, rx: wR, ry: h)
		path1.addCurve(to: CGPoint(x + th + wR, y + h), control1: controlPoint[0], control2: controlPoint[1])

		m2 = atan2(idy * (wR / h), ix - (th + wR))
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + th + wR, y + h), framePoint2: CGPoint(x + ix, y + idy), startAngle: 0.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path1.addCurve(to: CGPoint(x + ix, y + idy), control1: controlPoint[0], control2: controlPoint[1])

		m1 = atan2(y1 * (wR / h), x5 - wR)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2(idy * (wR / h), ix - wR)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x5, y + y1), framePoint2: CGPoint(x + ix, y + idy), startAngle: m1, endAngle: m2, rx: wR, ry: h)
		path1.addCurve(to: CGPoint(x + x5, y + y1), control1: controlPoint[1], control2: controlPoint[0])
		path1.addLine(to: CGPoint(x + x4, y + y1))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + wR, y + h))
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + wR, y + h), framePoint2: CGPoint(x, y), startAngle: 0.5 * .pi, endAngle: .pi, rx: wR, ry: h)
		path2.addCurve(to: CGPoint(x, y), control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x + th, y))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + h), framePoint2: CGPoint(x + th, y), startAngle: 0.5 * .pi, endAngle: .pi, rx: wR, ry: h)
		path2.addCurve(to: CGPoint(x + x3, y + h), control1: controlPoint[1], control2: controlPoint[0])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x + ix, y + idy))

		m1 = atan2(y1 * (wR / h), x5 - wR)
		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2(idy * (wR / h), ix - wR)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x5, y + y1), framePoint2: CGPoint(x + ix, y + idy), startAngle: m1, endAngle: m2, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + x5, y + y1), control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x + x4, y + y1))
		path3.addLine(to: CGPoint(x + x6, y))
		path3.addLine(to: CGPoint(x + x8, y + y1))
		path3.addLine(to: CGPoint(x + x7, y + y1))

		m1 = atan2(y1 * (wR / h), x7 - (th + wR))
		if m1 < 0 {
			m1 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x7, y + y1), framePoint2: CGPoint(x + th + wR, y + h), startAngle: m1, endAngle: 0.5 * .pi, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + th + wR, y + h), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + wR, y + h))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + wR, y + h), framePoint2: CGPoint(x, y), startAngle: 0.5 * .pi, endAngle: .pi, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x, y), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + th, y))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y + h), framePoint2: CGPoint(x + th, y), startAngle: 0.5 * .pi, endAngle: .pi, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + x3, y + h), control1: controlPoint[1], control2: controlPoint[0])

		let c1 = th * 0.5
		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(x5, y1), CGPoint(x4, 0), CGPoint(w, y1)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[x6, 0, 270], [x4, y1, 270], [c1, 0, 270], [ix, h, 90], [x8, y1, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func curvedDownArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f = self.computeCurvedArrowValuesModifiers(maxX: w, maxY: h, yVal: true, m: modifiers)
		let th = f[0]
		let aw = f[1]
		let ah = f[2]
		let wR = f[3]
		let idy = f[4]
		let x3 = wR + th
		let q2 = h * h
		let q3 = ah * ah
		let q4 = q2 - q3
		let q5 = sqrt(q4)
		let dx = q5 * wR / h
		let x5 = wR + dx
		let x7 = x3 + dx
		let q6 = aw - th
		let dh = q6 * 0.5
		let x4 = x5 - dh
		let x8 = x7 + dh
		let aw2 = aw * 0.5
		let x6 = w - aw2
		let y1 = h - ah
		let iy = h - idy
		let ix = (wR + x3) * 0.5

		var controlPoint: [CGPoint]

		// MARK: Unused

//		var m1: CGFloat
		var m2: CGFloat

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x + x6, y + h))
		path1.addLine(to: CGPoint(x + x4, y + y1))
		path1.addLine(to: CGPoint(x + x5, y + y1))

		m2 = atan2((y1 - h) * (wR / h), x5 - wR)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + wR, y), framePoint2: CGPoint(x + x5, y + y1), startAngle: 1.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path1.addCurve(to: CGPoint(x + wR, y), control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x + x3, y))

		m2 = atan2((y1 - h) * (wR / h), x7 - (th + wR))
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y), framePoint2: CGPoint(x + x7, y + y1), startAngle: 1.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path1.addCurve(to: CGPoint(x + x7, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x + x8, y + y1))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x, y + h))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + h), framePoint2: CGPoint(x + wR, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: wR, ry: h)
		path2.addCurve(to: CGPoint(x + wR, y), control1: controlPoint[0], control2: controlPoint[1])

		m2 = atan2((iy - h) * (wR / h), ix - wR)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + wR, y), framePoint2: CGPoint(x + ix, y + iy), startAngle: 1.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path2.addCurve(to: CGPoint(x + ix, y + iy), control1: controlPoint[0], control2: controlPoint[1])

		m2 = atan2((iy - h) * (wR / h), ix - (wR + th))
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + th, y + h), framePoint2: CGPoint(x + ix, y + iy), startAngle: .pi, endAngle: m2, rx: wR, ry: h)
		path2.addCurve(to: CGPoint(x + th, y + h), control1: controlPoint[1], control2: controlPoint[0])
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x + ix, y + iy))

		m2 = atan2((iy - h) * (wR / h), ix - (wR + th))
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + th, y + h), framePoint2: CGPoint(x + ix, y + iy), startAngle: .pi, endAngle: m2, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + th, y + h), control1: controlPoint[1], control2: controlPoint[0])

		path3.addLine(to: CGPoint(x, y + h))

		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x, y + h), framePoint2: CGPoint(x + wR, y), startAngle: .pi, endAngle: 1.5 * .pi, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + wR, y), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + x3, y))

		m2 = atan2((y1 - h) * (wR / h), x7 - (th + wR))
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x3, y), framePoint2: CGPoint(x + x7, y + y1), startAngle: 1.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + x7, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path3.addLine(to: CGPoint(x + x8, y + y1))
		path3.addLine(to: CGPoint(x + x6, y + h))
		path3.addLine(to: CGPoint(x + x4, y + y1))
		path3.addLine(to: CGPoint(x + x5, y + y1))

		m2 = atan2((y1 - h) * (wR / h), x5 - wR)
		if m2 < 0 {
			m2 += 2 * .pi
		}
		controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + wR, y), framePoint2: CGPoint(x + x5, y + y1), startAngle: 1.5 * .pi, endAngle: m2, rx: wR, ry: h)
		path3.addCurve(to: CGPoint(x + wR, y), control1: controlPoint[1], control2: controlPoint[0])

		let c1 = th * 0.5

		let pathArray = [path1, path2, path3]
		let handles = [CGPoint(x5, y1), CGPoint(x4, h), CGPoint(w, y1)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = [[ix, 0, 270], [c1, h, 90], [x4, y1, 90], [x6, h, 90], [x8, y1, 0]]
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func stripedRightArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f0 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 0.843_75, Type: "x")
		let x1 = w - f0
		let f = h - (modifiers[0] * h)
		let f1 = f * 0.5
		let x2 = getCoordinates(1.0 / 32.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let x3 = getCoordinates(1.0 / 16.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let x4 = getCoordinates(1.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let x5 = getCoordinates(5.0 / 32.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let midY = h * 0.5
		let y2 = h - f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + f1))
		path.addLines(between: [CGPoint(x + x1, y + f1), CGPoint(x + x1, y), CGPoint(x + w, y + midY), CGPoint(x + x1, y + h), CGPoint(x + x1, y + y2), CGPoint(x + x5, y + y2), CGPoint(x + x5, y + f1)])
		path.closeSubpath()

		path.move(to: CGPoint(x, y + f1))
		path.addLines(between: [CGPoint(x, y + f1), CGPoint(x + x2, y + f1), CGPoint(x + x2, y + y2), CGPoint(x, y + y2)])
		path.closeSubpath()

		path.move(to: CGPoint(x + x3, y + f1))
		path.addLines(between: [CGPoint(x + x3, y + f1), CGPoint(x + x4, y + f1), CGPoint(x + x4, y + y2), CGPoint(x + x3, y + y2)])
		path.closeSubpath()

		let dy1 = midY - f1
		let dx = dy1 * f0 / midY
		let r = w - dx

		let handles = [CGPoint(0, f1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x + x5, y: y + f1, width: r - x5, height: y2 - f1)
		let animationFrame = frame
		let connector = [[x1, 0, 270], [0, midY, 180], [x1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func notchedRightArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midY = h * 0.5
		let f0 = getCoordinates(modifiers[1], Width: w, Height: h, Percent: 1, Type: "x")
		let yy = modifiers[0] * h
		let y1 = yy * 0.5
		let y2 = h - y1
		let x1 = w - f0
		let x2 = f0 - (y1 / midY) * f0

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + y1))
		path.addLines(between: [CGPoint(x + x1, y + y1), CGPoint(x + x1, y), CGPoint(x + w, y + midY), CGPoint(x + x1, y + h), CGPoint(x + x1, y + y2), CGPoint(x, y + y2), CGPoint(x + x2, y + midY), CGPoint(x, y + y1)])
		path.closeSubpath()

		let dy1 = midY - y1
		let l = (midY != 0) ? (dy1 * f0 / midY) : 0.0
		let r = w - l

		let handles = [CGPoint(w, y1), CGPoint(x1, 0)]
		let textFrame = CGRect(x: x + l, y: y + y1, width: r - l, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x1, 0, 270], [x2, midY, 180], [x1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func pentagonArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let x1 = w - getCoordinates(modifiers[0], Width: w, Height: h, Percent: 1, Type: "x")
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y))
		path.addLines(between: [CGPoint(x + x1, y), CGPoint(x + w, y + midY), CGPoint(x + x1, y + h), CGPoint(x, y + h), CGPoint(x, y)])
		path.closeSubpath()

		let r = (x1 + w) * 0.5
		let x2 = x1 * 0.5
		let handles = [CGPoint(x1, 0)]
		let textFrame = CGRect(x: x, y: y, width: r, height: h)
		let animationFrame = frame
		let connector = [[x2, 0, 270], [0, midY, 180], [x2, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func chevron(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let x2 = getCoordinates(modifiers[0], Width: w, Height: h, Percent: 1, Type: "x")
		let x1 = w - x2
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y))
		path.addLines(between: [CGPoint(x + x1, y), CGPoint(x + w, y + midY), CGPoint(x + x1, y + h), CGPoint(x, y + h), CGPoint(x + x2, y + midY), CGPoint(x, y)])
		path.closeSubpath()

		let dx = x1 - x2
		let l = ifElse(First: dx, Second: x2, Third: 0)
		let r = ifElse(First: dx, Second: x1, Third: w)
		let x3 = x1 * 0.5
		let handles = [CGPoint(x1, 0)]
		let textFrame = CGRect(x: x + l, y: y, width: r - l, height: h)
		let animationFrame = frame
		let connector = [[x3, 0, 270], [x2, midY, 180], [x3, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func circularArrow(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		var path = CGMutablePath()
		var aa = modifiers[0]
		let bb = modifiers[1]
		let cc = modifiers[2]
		let dd = modifiers[3]
		let ee = modifiers[4]
		var rx = CGFloat()
		var ry = CGFloat()

		aa = 0.25 - aa
		let ff = (cc + bb).truncatingRemainder(dividingBy: 6.283_184_6)

		// MARK: Unused

//		var gg = CGFloat()
//		if cc >= bb {
//			gg = cc - bb
//		} else {
//			gg = 6.283_184_6 - (bb - cc)
//		}

		//        let mm = cc >= bb ? cc - bb : 6.2831846 - bb - cc
		let hh = (cc + bb).truncatingRemainder(dividingBy: 6.283_184_6)
		let ii = (hh + 3.141_592_3).truncatingRemainder(dividingBy: 6.283_184_6)
		let f2 = min(w, h)
		let midX = w * 0.5
		let midY = h * 0.5

		if ee < (aa / 2) {
			rx = w * 0.5
			ry = h * 0.5
		} else {
			rx = (w * 0.5) - (f2 * ee) + (f2 * aa / 2)
			ry = (h * 0.5) - (f2 * ee) + (f2 * aa / 2)
		}

		let a = getEllipseCoordinates(angle1: dd, angle2: cc, rx: rx, ry: ry, mid: CGPoint(midX, midY))
		let x1 = a[0]
		let y1 = a[1]
		let x2 = a[2]
		let y2 = a[3]

		var controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + y1), framePoint2: CGPoint(x + x2, y + y2), startAngle: dd, endAngle: cc, rx: rx, ry: ry)
		path.move(to: CGPoint(x + x1, y + y1))
		//        path.addCurve(to: CGPoint(x + x2,y + y2), control1: controlPoint[0], control2: controlPoint[1])
		path = self.addRoundArc(path: path, m1: dd, m2: cc, rx: rx, ry: ry, midX: midX, midY: midY, x: x, y: y)

		var rx1 = CGFloat()
		var ry1 = CGFloat()
		if ee < (aa / 2) {
			rx1 = (w * 0.5) - (f2 * 2 * ee)
			ry1 = (h * 0.5) - (f2 * 2 * ee)
		} else {
			rx1 = (w * 0.5) - (f2 * ee) - (f2 * aa / 2)
			ry1 = (h * 0.5) - (f2 * ee) - (f2 * aa / 2)
		}

		// MARK: Unused

//		var b = getEllipseCoordinates(angle1: dd, angle2: cc, rx: rx1, ry: ry1, mid: CGPoint(midX, midY))
//		let x3 = b[0]
//		let y3 = b[1]
//		let x4 = b[2]
//		let y4 = b[3]

		rx = (w * 0.5) - (f2 * ee)
		ry = (h * 0.5) - (f2 * ee)

		let c = getEllipseCoordinates(angle1: dd, angle2: ff, rx: rx, ry: ry, mid: CGPoint(midX, midY))
		let x5 = c[2]
		let y5 = c[3]
		let d = getEllipseCoordinates(angle1: dd, angle2: cc, rx: rx, ry: ry, mid: CGPoint(midX, midY))
		let x6 = d[2]
		let y6 = d[3]

		rx = ee * f2
		ry = ee * f2
		let e = getEllipseCoordinates(angle1: ii, angle2: hh, rx: rx, ry: ry, mid: CGPoint(x6, y6))
		let x7 = e[0]
		let y7 = e[1]
		let x8 = e[2]
		let y8 = e[3]

		rx = aa * f2 / 2
		ry = aa * f2 / 2

		let f = getEllipseCoordinates(angle1: ii, angle2: hh, rx: rx, ry: ry, mid: CGPoint(x6, y6))
		let x9 = f[0]
		let y9 = f[1]
		let x10 = f[2]
		let y10 = f[3]

		if ee < (aa / 2) {
			rx = w * 0.5
			ry = h * 0.5
		} else {
			rx = (w * 0.5) - (f2 * ee) + (f2 * aa / 2)
			ry = (h * 0.5) - (f2 * ee) + (f2 * aa / 2)
		}

		if ee >= (aa / 2) {
			controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x2, y + y2), framePoint2: CGPoint(x + x10, y + y10), startAngle: ii, endAngle: hh, rx: rx, ry: ry)
			path.addCurve(to: CGPoint(x + x10, y + y10), control1: controlPoint[1], control2: controlPoint[0])
			path.addLine(to: CGPoint(x + x8, y + y8))
		}
		path.addLine(to: CGPoint(x + x5, y + y5))

		if ee < (aa / 2) {
			path.addLine(to: CGPoint(x + x7, y + y7))
		}

		if ee >= (aa / 2) {
			path.addLine(to: CGPoint(x + x7, y + y7))
			path.addLine(to: CGPoint(x + x9, y + y9))
			//            An addition line is being added if the below line is included
			//            path.addLine(to: CGPoint(x + x4,y + y4))
		}

		//        controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x + x3,y + y3), framePoint2: CGPoint(x + x4,y + y4), startAngle: dd, endAngle: cc, rx: rx1, ry: ry1)
		//        path.addCurve(to: CGPoint(x + x3,y + y3), control1: controlPoint[1], control2: controlPoint[0])
		path = self.addReverseRoundArc(path: path, m1: dd, m2: cc, rx: rx1, ry: ry1, midX: midX, midY: midY, x: x, y: y)
		path.closeSubpath()

		let cang1 = radiansToDegrees(angle: dd) - 90
		let cang2 = radiansToDegrees(angle: cc) + 90
		let cang3 = (cang1 + cang2) * 0.5

		let animationFrame = frame
		let handles = [CGPoint(0, y1)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let connector = [[x5, y5, CGFloat(cang1)], [x6, y6, CGFloat(cang2)], [midX, midY, CGFloat(cang3)]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:disable function_parameter_count
	func addRoundArc(path: CGMutablePath, m1: CGFloat, m2: CGFloat, rx: CGFloat, ry: CGFloat, midX: CGFloat, midY: CGFloat, x: CGFloat, y: CGFloat, isClockwise: Bool = true) -> CGMutablePath {
		let i = 0, j = 1
		let sweepAngle = m2 - m1
		var startAngle = m1, endAngle = m2
		var framePoint: [CGPoint] = [.zero, .zero]
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
			let coordinate = getEllipseCoordinates(angle1: m1, angle2: endAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]
			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[j], control1: controlPoint[i], control2: controlPoint[j])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			let coordinate = getEllipseCoordinates(angle1: m1, angle2: endAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]

			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[j], control1: controlPoint[i], control2: controlPoint[j])
		}

		// full quadrants
		quadrantNumber += 1

		while fullQuadrant > 0 {
			framePoint[0] = framePoint[1]
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)
			let coordinate = getEllipseCoordinates(angle1: startAngle, angle2: endAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[j], control1: controlPoint[i], control2: controlPoint[j])

			fullQuadrant -= 1
			quadrantNumber += 1
		}

		// last quadrant
		if sweepAngle >= 0 {
			if endQuadrantNumber != startQuadrantNumber {
				framePoint[0] = framePoint[1]
				startAngle = endAngle
				endAngle = m2
			} else {
				startAngle = m1
				let coordinate = getEllipseCoordinates(angle1: m1, angle2: m2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
				framePoint[0].x = x + coordinate[0]
				framePoint[0].y = y + coordinate[1]
				endAngle = m2
			}
			let coordinate = getEllipseCoordinates(angle1: m1, angle2: m2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[j], control1: controlPoint[i], control2: controlPoint[j])
		} else {
			framePoint[0] = framePoint[1]
			startAngle = endAngle
			endAngle = m2
			let coordinate = getEllipseCoordinates(angle1: m1, angle2: m2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: startAngle, endAngle: endAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[j], control1: controlPoint[i], control2: controlPoint[j])
		}
		return path
	}

	func addReverseRoundArc(path: CGMutablePath, m1: CGFloat, m2: CGFloat, rx: CGFloat, ry: CGFloat, midX: CGFloat, midY: CGFloat, x: CGFloat, y: CGFloat, isClockwise: Bool = true) -> CGMutablePath {
		// MARK: Unused

//		var i = 0, j = 1
		let m1 = m1, m2 = m2
		let sweepAngle = m1 - m2
		var startAngle = m2, endAngle = m1
		var framePoint: [CGPoint] = [.zero, .zero]
		var quadrantNumber: CGFloat, fullQuadrant: CGFloat, endQuadrantNumber: CGFloat, startQuadrantNumber: CGFloat
		var controlPoint: [CGPoint]

		if m2 >= 0, m2 < .pi / 2 {
			startQuadrantNumber = 1
		} else if m2 >= .pi / 2, m2 < .pi {
			startQuadrantNumber = 2
		} else if m2 >= .pi, m2 < 3 * .pi / 2 {
			startQuadrantNumber = 3
		} else {
			startQuadrantNumber = 4
		}

		if m1 >= 0, m1 < .pi / 2 {
			endQuadrantNumber = 1
		} else if m1 >= .pi / 2, m1 < .pi {
			endQuadrantNumber = 2
		} else if m1 >= .pi, m1 < 3 * .pi / 2 {
			endQuadrantNumber = 3
		} else {
			endQuadrantNumber = 4
		}

		if sweepAngle <= 0 {
			//            fullQuadrant =  endQuadrantNumber - startQuadrantNumber - 1
			fullQuadrant = startQuadrantNumber - endQuadrantNumber - 1
		} else {
			fullQuadrant = 4 - endQuadrantNumber + startQuadrantNumber - 1
		}

		if startQuadrantNumber != 1 {
			quadrantNumber = startQuadrantNumber - 1
		} else {
			quadrantNumber = 4
		}

		// first incomplete quadrant
		if endQuadrantNumber != quadrantNumber, sweepAngle >= 0 {
			endAngle = quadrantNumber * .pi / 2
			let coordinate = getEllipseCoordinates(angle1: endAngle, angle2: m2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]
			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: endAngle, endAngle: m2, rx: rx, ry: ry)
			path.addCurve(to: framePoint[0], control1: controlPoint[1], control2: controlPoint[0])
		}

		if sweepAngle < 0 {
			endAngle = quadrantNumber * (.pi / 2)
			let coordinate = getEllipseCoordinates(angle1: endAngle, angle2: m2, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]

			framePoint[1].x = x + coordinate[2]
			framePoint[1].y = y + coordinate[3]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: endAngle, endAngle: m2, rx: rx, ry: ry)
			path.addCurve(to: framePoint[0], control1: controlPoint[1], control2: controlPoint[0])
		}

		// full quadrants
		quadrantNumber -= 1

		while fullQuadrant > 0 {
			framePoint[1] = framePoint[0]
			startAngle = endAngle
			endAngle = quadrantNumber * (.pi / 2)
			let coordinate = getEllipseCoordinates(angle1: endAngle, angle2: startAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[0], control1: controlPoint[1], control2: controlPoint[0])

			fullQuadrant -= 1
			quadrantNumber -= 1
		}

		// last quadrant
		if sweepAngle >= 0 {
			if endQuadrantNumber != startQuadrantNumber {
				framePoint[1] = framePoint[0]
				startAngle = endAngle
				endAngle = m1
			} else {
				startAngle = m2
				let coordinate = getEllipseCoordinates(angle1: m1, angle2: startAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
				framePoint[1].x = x + coordinate[2]
				framePoint[1].y = y + coordinate[3]
				endAngle = m1
			}
			let coordinate = getEllipseCoordinates(angle1: m1, angle2: startAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[0], control1: controlPoint[1], control2: controlPoint[0])
		} else {
			framePoint[1] = framePoint[0]
			startAngle = endAngle
			endAngle = m1
			let coordinate = getEllipseCoordinates(angle1: endAngle, angle2: startAngle, rx: rx, ry: ry, mid: CGPoint(midX, midY))
			framePoint[0].x = x + coordinate[0]
			framePoint[0].y = y + coordinate[1]

			controlPoint = getControlPointsForEllipse(framePoint1: framePoint[0], framePoint2: framePoint[1], startAngle: endAngle, endAngle: startAngle, rx: rx, ry: ry)
			path.addCurve(to: framePoint[0], control1: controlPoint[1], control2: controlPoint[0])
		}
		return path
	}

	// swiftlint:enable function_parameter_count
}

// swiftlint:enable file_length
