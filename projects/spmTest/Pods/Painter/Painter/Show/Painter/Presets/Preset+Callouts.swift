//
//  Preset+Callouts.swift
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
	func computeArrowCalloutValuesModifiers(mod: [CGFloat], ww: CGFloat, hh: CGFloat, isY: Bool, isLeftOrTop: Bool, isLeftRight: Bool) -> [CGFloat] {
		let str: Character
		var max: CGFloat
		if isY {
			str = "y"
			max = hh
		} else {
			str = "x"
			max = ww
		}

		let f0 = getCoordinates(mod[2], Width: ww, Height: hh, Percent: 1, Type: str)
		var x1 = mod[3] * ww
		var val = max - f0
		if isLeftRight {
			val = max - (f0 * 2)
		}
		x1 = min(x1, val)

		var x2: CGFloat
		if isLeftOrTop {
			x2 = f0
			x1 = max - x1
		} else {
			x2 = max - f0
		}

		var str1: Character
		if isY {
			str1 = "x"
		} else {
			str1 = "y"
		}

		let f1 = getCoordinates(mod[1], Width: ww, Height: hh, Percent: 0.5, Type: str1)
		var f2 = getCoordinates(mod[0], Width: ww, Height: hh, Percent: mod[1] * 2, Type: "z")
		f2 *= 0.5

		var mid: CGFloat
		if isY {
			mid = ww * 0.5
		} else {
			mid = hh * 0.5
		}

		let y1 = mid - f1
		let y2 = mid - f2
		let y3 = mid + f2
		let y4 = mid + f1

		return [x1, x2, y1, y2, y3, y4]
	}

	func computeCalloutCallNum(callNum: Int, accent: Bool, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, m: [CGFloat]) -> ([CGPath], [CGPoint]) {
		assert(!m.isEmpty, "Modifiers array is empty")
		let dxPos = w * m[1]
		let dyPos = h * m[0]
		let xPos = w * m[3]
		let yPos = h * m[2]
		var objArray = [CGPoint(dxPos, dyPos), CGPoint(xPos, yPos)]

		let path1 = CGMutablePath()
		path1.addRect(CGRect(x: x, y: y, width: w, height: h))

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + dxPos, y + dyPos))
		path2.addLine(to: CGPoint(x + xPos, y + yPos))

		if callNum == 2 || callNum == 3 {
			let axPos = w * m[5]
			let ayPos = h * m[4]
			path2.addLine(to: CGPoint(x + axPos, y + ayPos))
			objArray.append(CGPoint(axPos, ayPos))
		}
		if callNum == 3 {
			let bxPos = w * m[7]
			let byPos = h * m[6]
			path2.addLine(to: CGPoint(x + bxPos, y + byPos))
			objArray.append(CGPoint(bxPos, byPos))
		}
		if accent {
			path2.move(to: CGPoint(x + dxPos, y))
			path2.addLine(to: CGPoint(x + dxPos, y + h))
		}
		return ([path1, path2], objArray)
	}

	func rightArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let arrowCalloutValues = self.computeArrowCalloutValuesModifiers(mod: modifiers, ww: w, hh: h, isY: false, isLeftOrTop: false, isLeftRight: false)
		let x1 = arrowCalloutValues[0]
		let x2 = arrowCalloutValues[1]
		let y1 = arrowCalloutValues[2]
		let y2 = arrowCalloutValues[3]
		let y3 = arrowCalloutValues[4]
		let y4 = arrowCalloutValues[5]
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + h))
		path.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x1, y + y3), CGPoint(x + x2, y + y3), CGPoint(x + x2, y + y4), CGPoint(x + w, y + midY), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + x1, y), CGPoint(x, y), CGPoint(x, y + h)])
		path.closeSubpath()

		let c1 = x1 * 0.5

		let handles = [CGPoint(x2, y2), CGPoint(w, y1), CGPoint(x2, 0), CGPoint(x1, h)]
		let textFrame = CGRect(x: x, y: y, width: x1, height: h)
		let animationFrame = frame
		let connector = [[c1, 0, 270], [0, midY, 180], [c1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let arrowCalloutValues = self.computeArrowCalloutValuesModifiers(mod: modifiers, ww: w, hh: h, isY: false, isLeftOrTop: true, isLeftRight: false)
		let x1 = arrowCalloutValues[0]
		let x2 = arrowCalloutValues[1]
		let y1 = arrowCalloutValues[2]
		let y2 = arrowCalloutValues[3]
		let y3 = arrowCalloutValues[4]
		let y4 = arrowCalloutValues[5]
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + h))
		path.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x1, y + y3), CGPoint(x + x2, y + y3), CGPoint(x + x2, y + y4), CGPoint(x, y + midY), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + x1, y), CGPoint(x + w, y), CGPoint(x + w, y + h)])
		path.closeSubpath()
		let c1 = (x1 + w) * 0.5

		let handles = [CGPoint(x2, y2), CGPoint(0, y1), CGPoint(x2, 0), CGPoint(x1, h)]
		let textFrame = CGRect(x: x + x1, y: y, width: w - x1, height: h)
		let animationFrame = frame
		let connector = [[c1, 0, 270], [0, midY, 180], [c1, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func upArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let arrowCalloutValues = self.computeArrowCalloutValuesModifiers(mod: modifiers, ww: w, hh: h, isY: true, isLeftOrTop: true, isLeftRight: false)
		let y1 = arrowCalloutValues[0]
		let y2 = arrowCalloutValues[1]
		let x1 = arrowCalloutValues[2]
		let x2 = arrowCalloutValues[3]
		let x3 = arrowCalloutValues[4]
		let x4 = arrowCalloutValues[5]
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + y1))
		path.addLines(between: [CGPoint(x, y + y1), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + midX, y), CGPoint(x + x4, y + y2), CGPoint(x + x3, y + y2), CGPoint(x + x3, y + y1), CGPoint(x + w, y + y1), CGPoint(x + w, y + h), CGPoint(x, y + h)])
		path.closeSubpath()

		let handles = [CGPoint(x2, y2), CGPoint(x1, 0), CGPoint(w, y2), CGPoint(0, y1)]
		let textFrame = CGRect(x: x, y: y + y1, width: w, height: h - y1)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, y1, 180], [midX, h, 90], [w, y1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func downArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let arrowCalloutValues = self.computeArrowCalloutValuesModifiers(mod: modifiers, ww: w, hh: h, isY: true, isLeftOrTop: false, isLeftRight: false)
		let y1 = arrowCalloutValues[0]
		let y2 = arrowCalloutValues[1]
		let x1 = arrowCalloutValues[2]
		let x2 = arrowCalloutValues[3]
		let x3 = arrowCalloutValues[4]
		let x4 = arrowCalloutValues[5]
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + y1))
		path.addLines(between: [CGPoint(x, y + y1), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + midX, y + h), CGPoint(x + x4, y + y2), CGPoint(x + x3, y + y2), CGPoint(x + x3, y + y1), CGPoint(x + w, y + y1), CGPoint(x + w, y), CGPoint(x, y)])
		path.closeSubpath()

		let c1 = y1 * 0.5

		let handles = [CGPoint(x2, y2), CGPoint(x1, h), CGPoint(w, y2), CGPoint(0, y1)]
		let textFrame = CGRect(x: x, y: y, width: w, height: y1)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, c1, 180], [midX, h, 90], [w, c1, 0]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func leftRightArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let a = self.computeArrowCalloutValuesModifiers(mod: modifiers, ww: w, hh: h, isY: false, isLeftOrTop: true, isLeftRight: true)
		let x1 = a[0] * 0.5
		let x2 = a[1]
		let y1 = a[2]
		let y2 = a[3]
		let y3 = a[4]
		let y4 = a[5]
		let x3 = w - x1
		let x4 = w - x2
		let midY = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + h))
		path.addLines(between: [CGPoint(x + x1, y + h), CGPoint(x + x1, y + y3), CGPoint(x + x2, y + y3), CGPoint(x + x2, y + y4), CGPoint(x, y + midY), CGPoint(x + x2, y + y1), CGPoint(x + x2, y + y2), CGPoint(x + x1, y + y2), CGPoint(x + x1, y), CGPoint(x + x3, y), CGPoint(x + x3, y + y2), CGPoint(x + x4, y + y2), CGPoint(x + x4, y + y1), CGPoint(x + w, y + midY), CGPoint(x + x4, y + y4), CGPoint(x + x4, y + y3), CGPoint(x + x3, y + y3), CGPoint(x + x3, y + h)])
		path.closeSubpath()

		let handles = [CGPoint(x2, y2), CGPoint(0, y1), CGPoint(x2, 0), CGPoint(x1, h)]
		let textFrame = CGRect(x: x + x1, y: y, width: x3 - x1, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func quadArrowCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let f = computeArrowValuesModifiers(ww: w, hh: h, m: modifiers)
		let ss = min(w, h)
		var f1 = modifiers[3] * ss
		f1 = limit(value: f1, minValue: f[1] * 2, maxValue: ss - (f[2] * 2))
		f1 *= 0.5

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
		let x7 = midX - f1
		let x8 = midX + f1
		let y7 = midY - f1
		let y8 = midY + f1

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y + f5))
		path.addLines(between: [CGPoint(x + x1, y + f5), CGPoint(x + midX, y), CGPoint(x + x4, y + f5), CGPoint(x + x3, y + f5), CGPoint(x + x3, y + y7), CGPoint(x + x8, y + y7), CGPoint(x + x8, y + y2), CGPoint(x + x6, y + y2), CGPoint(x + x6, y + y1), CGPoint(x + w, y + midY), CGPoint(x + x6, y + y4), CGPoint(x + x6, y + y3), CGPoint(x + x8, y + y3), CGPoint(x + x8, y + y8), CGPoint(x + x3, y + y8), CGPoint(x + x3, y + y6), CGPoint(x + x4, y + y6), CGPoint(x + midX, y + h), CGPoint(x + x1, y + y6), CGPoint(x + x2, y + y6), CGPoint(x + x2, y + y8), CGPoint(x + x7, y + y8), CGPoint(x + x7, y + y3), CGPoint(x + f5, y + y3), CGPoint(x + f5, y + y4), CGPoint(x, y + midY), CGPoint(x + f5, y + y1), CGPoint(x + f5, y + y2), CGPoint(x + x7, y + y2), CGPoint(x + x7, y + y7), CGPoint(x + x2, y + y7), CGPoint(x + x2, y + f5)])
		path.closeSubpath()

		let handles = [CGPoint(x2, f5), CGPoint(x1, 0), CGPoint(w, f5), CGPoint(0, y7)]
		let textFrame = CGRect(x: x + x7, y: y + y7, width: x8 - x7, height: y8 - y7)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func borderCallout1(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 1, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func borderCallout2(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 2, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func borderCallout3(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 3, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentCallout1(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 1, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentCallout2(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 2, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentCallout3(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 3, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func callout1(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 1, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func callout2(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 2, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func callout3(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 3, accent: false, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentBorderCallout1(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 1, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentBorderCallout2(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 2, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func accentBorderCallout3(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let callOutInfo = self.computeCalloutCallNum(callNum: 3, accent: true, x: x, y: y, w: w, h: h, m: modifiers)
		let pathArray = callOutInfo.0
		let handles = callOutInfo.1
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func cloudCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let t: CGFloat = 21_600.0
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

		let midX = w * 0.5
		let midY = h * 0.5
		let dxPos = w * modifiers[0]
		let dyPos = h * modifiers[1]
		let xPos = midX + dxPos
		let yPos = midY + dyPos
		let ht = cosTan(x: midY, Second: dxPos, Third: dyPos)
		let wt = sinTan(x: midX, Second: dxPos, Third: dyPos)
		let g2 = cosTan(x: midX, Second: ht, Third: wt)
		let g3 = sinTan(x: midY, Second: ht, Third: wt)
		let g4 = midX + g2
		let g5 = midY + g3
		let g6 = g4 - xPos
		let g7 = g5 - yPos
		let g8 = sqrt(pow(g6, 2) + pow(g7, 2))
		let g9 = getCoordinates(6_600.0 / 21_600.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g10 = g8 - g9
		let g11 = g10 * 1.0 / 3.0
		let g12 = getCoordinates(1_800.0 / 21_600.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g13 = g11 + g12
		let g14 = g13 * g6 / g8
		let g15 = g13 * g7 / g8
		let g16 = g14 + xPos
		let g17 = g15 + yPos
		let g18 = getCoordinates(4_800.0 / 21_600.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g19 = g11 * 2
		let g20 = g18 + g19
		let g21 = g20 * g6 / g8
		let g22 = g20 * g7 / g8
		let g23 = g21 + xPos
		let g24 = g22 + yPos
		let g25 = getCoordinates(1_200.0 / 21_600.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g26 = getCoordinates(600.0 / 21_600.0, Width: w, Height: h, Percent: 0.5, Type: "z")

		let x23 = xPos + g26
		let x24 = g16 + g25
		let x25 = g23 + g12

		let path3 = CGMutablePath()
		path3.addEllipse(in: CGRect(x: x + x23 - g26, y: y + yPos - g26, width: 2 * g26, height: 2 * g26))
		path3.addEllipse(in: CGRect(x: x + x24 - g25, y: y + g17 - g25, width: 2 * g25, height: 2 * g25))
		path3.addEllipse(in: CGRect(x: x + x25 - g12, y: y + g24 - g12, width: 2 * g12, height: 2 * g12))

		let pathArray = [path1, path2_sp1, path2_sp2, path2_sp3, path2_sp4, path2_sp5, path2_sp6, path2_sp7, path2_sp8, path2_sp9, path2_sp10, path2_sp11, path3]
		let pathProps = [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3]

		let handles = [CGPoint(x23, yPos)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps)
	}

	// swiftlint:disable function_body_length
	func ovalCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let path = CGMutablePath()

		let midX = w * 0.5
		let midY = h * 0.5

		let dxPos = modifiers[0] * w
		let dyPos = modifiers[1] * h
		let xPos = midX + dxPos
		let yPos = midY + dyPos
		let sdx = dxPos * h
		let sdy = dyPos * w

		let pang = atan2(sdy, sdx)
		let ang1 = CGFloat(degreesToRadians(angle: 11))
		let stAng = pang + ang1
		let enAng = pang - ang1

		let a: [CGFloat] = getEllipseCoordinates(angle1: stAng, angle2: enAng, rx: midX, ry: midY, mid: CGPoint(-1, -1))
		var m1: CGFloat, m2: CGFloat

		m1 = atan2((a[1] - midY) * (midX / midY), a[0] - midX)
		if m1 < 0 {
			m1 += 2 * .pi
		}

		m2 = atan2((a[3] - midY) * (midX / midY), a[2] - midX)
		if m2 < 0 {
			m2 += 2 * .pi
		}

		let sweepAngle = m2 - m1
		var startAngle = m1, endAngle = m2
		var framePoint1 = CGPoint(0, 0), framePoint2 = CGPoint(0, 0)
		var quadrantNumber: CGFloat, fullQuadrant: CGFloat, endQuadrantNumber: CGFloat, startQuadrantNumber: CGFloat
		var controlPoint: [CGPoint]

		path.move(to: CGPoint(x + xPos, y + yPos))
		path.addLine(to: CGPoint(x + a[0], y + a[1]))

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

		let handles = [CGPoint(xPos, yPos)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .oval)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func rectangularCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let dxPos = modifiers[0] * w
		let dyPos = modifiers[1] * h

		let xPos = midX + dxPos
		let yPos = midY + dyPos
		let dq = dxPos * h / w
		let ady = abs(dyPos)
		let adq = abs(dq)
		let dz = ady - adq
		let xg1 = ifElse(First: dxPos, Second: 7.0, Third: 2.0)
		let xg2 = ifElse(First: dxPos, Second: 10.0, Third: 5.0)
		let x1 = w * xg1 / 12.0
		let x2 = w * xg2 / 12.0
		let yg1 = ifElse(First: dyPos, Second: 7.0, Third: 2.0)
		let yg2 = ifElse(First: dyPos, Second: 10.0, Third: 5.0)
		let y1 = h * yg1 / 12.0
		let y2 = h * yg2 / 12.0
		let t1 = ifElse(First: dxPos, Second: 0, Third: xPos)
		let xl = ifElse(First: dz, Second: 0, Third: t1)
		let t2 = ifElse(First: dyPos, Second: x1, Third: xPos)
		let xt = ifElse(First: dz, Second: t2, Third: x1)
		let t3 = ifElse(First: dxPos, Second: xPos, Third: w)
		let xr = ifElse(First: dz, Second: w, Third: t3)
		let t4 = ifElse(First: dyPos, Second: xPos, Third: x1)
		let xb = ifElse(First: dz, Second: t4, Third: x1)

		let t5 = ifElse(First: dxPos, Second: y1, Third: yPos)
		let yl = ifElse(First: dz, Second: y1, Third: t5)
		let t6 = ifElse(First: dyPos, Second: 0, Third: yPos)
		let yt = ifElse(First: dz, Second: t6, Third: 0)
		let t7 = ifElse(First: dxPos, Second: yPos, Third: y1)
		let yr = ifElse(First: dz, Second: y1, Third: t7)
		let t8 = ifElse(First: dyPos, Second: yPos, Third: h)
		let yb = ifElse(First: dz, Second: t8, Third: h)

		let path = CGMutablePath()
		path.addLines(between: [CGPoint(x, y), CGPoint(x + x1, y), CGPoint(x + xt, y + yt), CGPoint(x + x2, y), CGPoint(x + w, y), CGPoint(x + w, y + y1), CGPoint(x + xr, y + yr), CGPoint(x + w, y + y2), CGPoint(x + w, y + h), CGPoint(x + x2, y + h), CGPoint(x + xb, y + yb), CGPoint(x + x1, y + h), CGPoint(x, y + h), CGPoint(x, y + y2), CGPoint(x + xl, y + yl), CGPoint(x, y + y1)])
		path.closeSubpath()

		let handles = [CGPoint(xPos, yPos)]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func roundedRectangularCallout(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let dxPos = modifiers[0] * w
		let dyPos = modifiers[1] * h

		let xPos = midX + dxPos
		let yPos = midY + dyPos
		let dq = dxPos * h / w
		let ady = abs(dyPos)
		let adq = abs(dq)
		let dz = ady - adq
		let xg1 = ifElse(First: dxPos, Second: 7.0, Third: 2.0)
		let xg2 = ifElse(First: dxPos, Second: 10.0, Third: 5.0)
		let x1 = w * xg1 / 12.0
		let x2 = w * xg2 / 12.0
		let yg1 = ifElse(First: dyPos, Second: 7.0, Third: 2.0)
		let yg2 = ifElse(First: dyPos, Second: 10.0, Third: 5.0)
		let y1 = h * yg1 / 12.0
		let y2 = h * yg2 / 12.0
		let t1 = ifElse(First: dxPos, Second: 0, Third: xPos)
		let xl = ifElse(First: dz, Second: 0, Third: t1)
		let t2 = ifElse(First: dyPos, Second: x1, Third: xPos)
		let xt = ifElse(First: dz, Second: t2, Third: x1)
		let t3 = ifElse(First: dxPos, Second: xPos, Third: w)
		let xr = ifElse(First: dz, Second: w, Third: t3)
		let t4 = ifElse(First: dyPos, Second: xPos, Third: x1)
		let xb = ifElse(First: dz, Second: t4, Third: x1)

		let t5 = ifElse(First: dxPos, Second: y1, Third: yPos)
		let yl = ifElse(First: dz, Second: y1, Third: t5)
		let t6 = ifElse(First: dyPos, Second: 0, Third: yPos)
		let yt = ifElse(First: dz, Second: t6, Third: 0)
		let t7 = ifElse(First: dxPos, Second: yPos, Third: y1)
		let yr = ifElse(First: dz, Second: y1, Third: t7)
		let t8 = ifElse(First: dyPos, Second: yPos, Third: h)
		let yb = ifElse(First: dz, Second: t8, Third: h)

		let u1 = getCoordinates(0.166_7, Width: w, Height: h, Percent: 0.5, Type: "z")
		let u2 = w - u1
		let v2 = h - u1

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + u1))
		path.addArc(center: CGPoint(x + u1, y + u1), radius: u1, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + x1, y))
		path.addLine(to: CGPoint(x + xt, y + yt))
		path.addLine(to: CGPoint(x + x2, y))
		path.addLine(to: CGPoint(x + u2, y))

		path.addArc(center: CGPoint(x + u2, y + u1), radius: u1, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
		path.addLine(to: CGPoint(x + w, y + y1))
		path.addLine(to: CGPoint(x + xr, y + yr))
		path.addLine(to: CGPoint(x + w, y + y2))
		path.addLine(to: CGPoint(x + w, y + v2))

		path.addArc(center: CGPoint(x + u2, y + v2), radius: h - v2, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)
		path.addLine(to: CGPoint(x + x2, y + h))
		path.addLine(to: CGPoint(x + xb, y + yb))
		path.addLine(to: CGPoint(x + x1, y + h))
		path.addLine(to: CGPoint(x + u1, y + h))

		path.addArc(center: CGPoint(x + u1, y + v2), radius: h - v2, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: false)
		path.addLine(to: CGPoint(x, y + y2))
		path.addLine(to: CGPoint(x + xl, y + yl))
		path.addLine(to: CGPoint(x, y + y1))
		path.closeSubpath()

		let l = u1 * 0.293
		let r = w - l
		let b = h - l

		let handles = [CGPoint(xPos, yPos)]
		let textFrame = CGRect(x: x, y: y, width: r - l, height: b - l)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}
}

// swiftlint:enable file_length
