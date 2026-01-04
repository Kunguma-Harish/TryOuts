//
//  Preset+Text.swift
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
	// swiftlint:disable function_body_length
	func borderQuote(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let path1 = CGMutablePath()
		let mod = 1 - modifiers[0]
		let mini = min(w, h)
		var midX = mod * w
		if (midX - (0.12 * mini)) < 0 {
			midX = 0.12 * mini
		}

		if (midX + (0.12 * mini)) > w {
			midX = w - (0.12 * mini)
		}
		path1.move(to: CGPoint(x: x, y: y + 0.17 * mini))

		if (midX - 0.14 * mini) > 0 {
			path1.addLine(to: CGPoint(x: x + midX - 0.14 * mini, y: y + 0.17 * mini))
		}
		path1.move(to: CGPoint(x: x + w, y: y + 0.17 * mini))

		if (midX + 0.14 * mini) < w {
			path1.addLine(to: CGPoint(x: x + midX + 0.14 * mini, y: y + 0.17 * mini))
		}
		midX = w - midX
		path1.move(to: CGPoint(x: x, y: y + h - 0.17 * mini))

		if (midX - 0.14 * mini) > 0 {
			path1.addLine(to: CGPoint(x: x + midX - 0.14 * mini, y: y + h - 0.17 * mini))
		}
		path1.move(to: CGPoint(x: x + w, y: y + h - 0.17 * mini))

		if (midX + 0.14 * mini) < w {
			path1.addLine(to: CGPoint(x: x + midX + 0.14 * mini, y: y + h - 0.17 * mini))
		}
		midX = mod * w

		if (midX - (0.12 * mini)) < 0 {
			midX = (0.12 * mini)
		}

		if (midX + (0.12 * mini)) > w {
			midX = w - (0.12 * mini)
		}
		var m1: CGFloat, m2: CGFloat
		m1 = atan2((0.15 * mini - 0.1 * mini) * (0.1 * mini / 0.1 * mini), midX - (0.12 * mini))

		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((0.075 * mini - 0.1 * mini) * (0.1 * mini / 0.1 * mini), midX - (0.02 * mini) - 0.1 * mini)

		if m2 < 0 {
			m2 += 2 * .pi
		}

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.15 * mini))
		path2.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.075 * mini))
		path2.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.15 * mini))
		path2.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.075 * mini))
		path2.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path2.closeSubpath()

		midX = w - midX

		path2.move(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.15 * mini))
		path2.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.075 * mini))
		path2.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.225 * mini))
		path2.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.15 * mini))
		path2.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.075 * mini))
		path2.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path2.closeSubpath()

		let path3 = CGMutablePath()
		midX = mod * w

		if (midX - (0.12 * mini)) < 0 {
			midX = 0.12 * mini
		}

		if (midX + (0.12 * mini)) > w {
			midX = w - (0.12 * mini)
		}
		path3.move(to: CGPoint(x: x, y: y + 0.17 * mini))

		if (midX - 0.14 * mini) > 0 {
			path3.addLine(to: CGPoint(x: x + midX - 0.14 * mini, y: y + 0.17 * mini))
		}
		path3.move(to: CGPoint(x: x + w, y: y + 0.17 * mini))

		if (midX + 0.14 * mini) < w {
			path3.addLine(to: CGPoint(x: x + midX + 0.14 * mini, y: y + 0.17 * mini))
		}
		midX = w - midX
		path3.move(to: CGPoint(x: x, y: y + h - 0.17 * mini))

		if (midX - 0.14 * mini) > 0 {
			path3.addLine(to: CGPoint(x: x + midX - 0.14 * mini, y: y + h - 0.17 * mini))
		}
		path3.move(to: CGPoint(x: x + w, y: y + h - 0.17 * mini))

		if (midX + 0.14 * mini) < w {
			path3.addLine(to: CGPoint(x: x + midX + 0.14 * mini, y: y + h - 0.17 * mini))
		}
		midX = mod * w

		if (midX - (0.12 * mini)) < 0 {
			midX = (0.12 * mini)
		}

		if (midX + (0.12 * mini)) > w {
			midX = w - (0.12 * mini)
		}
		m1 = atan2((0.15 * mini - 0.1 * mini) * (0.1 * mini / 0.1 * mini), midX - (0.12 * mini))

		if m1 < 0 {
			m1 += 2 * .pi
		}
		m2 = atan2((0.075 * mini - 0.1 * mini) * (0.1 * mini / 0.1 * mini), midX - (0.02 * mini) - 0.1 * mini)

		if m2 < 0 {
			m2 += 2 * .pi
		}

		path3.move(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.15 * mini))
		path3.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.075 * mini))
		path3.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.15 * mini))
		path3.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.075 * mini))
		path3.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path3.closeSubpath()

		midX = w - midX

		path3.move(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.15 * mini))
		path3.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.075 * mini))
		path3.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.225 * mini))
		path3.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.15 * mini))
		path3.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.075 * mini))
		path3.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x, y: y + 0.225 * mini, width: w, height: h - 0.225 * mini * 2)
		let handles = [CGPoint(midX, 0)]
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func twoEdgedFrame(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let a = 1 - modifiers[0]
		let b = 1 - modifiers[1]

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x, y: y))
		path1.addLine(to: CGPoint(x: x + w, y: y))
		path1.addLine(to: CGPoint(x: x + w, y: y + h))
		path1.addLine(to: CGPoint(x: x, y: y + h))
		path1.addLine(to: CGPoint(x: x, y: y))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		//        //        path2.move(to: CGPoint(x: x, y: y))
		//        path2.move(to: CGPoint(x: x + (a * w), y: y))
		//        // path2.addLine(to: CGPoint(x: x + (a * w), y: y))
		//        path2.addLine(to: CGPoint(x: x, y: y))
		//        //path2.move(to: CGPoint(x: x, y: y))
		//        path2.addLine(to: CGPoint(x: x, y: y + (b * h)))
		//        //        path2.move(to: CGPoint(x: x + w, y: y + h))
		//        path2.move(to: CGPoint(x: x + w, y: y + (h - b * h)))
		//        //path2.addLine(to: CGPoint(x: x + w, y: y + (h - b * h)))
		//        path2.addLine(to: CGPoint(x: x + w, y: y + h))
		//        //path2.move(to: CGPoint(x: x + w, y: y + h))
		//        path2.addLine(to: CGPoint(x: x + (w - a * w), y: y + h))

		// As per the web logic
		path2.move(to: CGPoint(x: x, y: y))
		path2.addLine(to: CGPoint(x: x + (a * w), y: y))
		path2.move(to: CGPoint(x: x, y: y))
		path2.addLine(to: CGPoint(x: x, y: y + (b * h)))
		path2.move(to: CGPoint(x: x + w, y: y + h))
		path2.addLine(to: CGPoint(x: x + w, y: y + (h - b * h)))
		path2.move(to: CGPoint(x: x + w, y: y + h))
		path2.addLine(to: CGPoint(x: x + (w - a * w), y: y + h))
		//

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x, y: y))
		path3.addLine(to: CGPoint(x: x + w, y: y))
		path3.addLine(to: CGPoint(x: x + w, y: y + h))
		path3.addLine(to: CGPoint(x: x, y: y + h))
		path3.addLine(to: CGPoint(x: x, y: y))
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let handles = [CGPoint(a * w, 0), CGPoint(w, (1 - b) * h)]
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func squareOnCircleBoard(frame: CGRect) -> PresetPathInfo {
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(0.1, Width: w, Height: h, Percent: 0.5, Type: "z")
		let f2 = getCoordinates(0.5, Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let st = 0.3 * h
		let en = 0.7 * h
		let midX = w * 0.5
		let midY = h * 0.5
		let x1 = CGFloat(sqrt(f2 * f2 - (st - midY) * (st - midY))) + midX
		let x2 = (2 * midX - x1)
		var m1: CGFloat = atan2(st - midY, x2 - midX)
		var m2: CGFloat = atan2((y + st) - (y + midY), (x + x1) - (x + midX))

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x + x2, y: y + st))
		path1.addArc(center: CGPoint(x: x + midX, y: y + midY), radius: f2, startAngle: m1, endAngle: m2, clockwise: false)

		m1 = atan2(en - midY, x2 - midX)
		m2 = atan2(en - midY, x1 - midX)
		path1.move(to: CGPoint(x: x + x2, y: y + en))
		path1.addArc(center: CGPoint(x: x + midX, y: y + midY), radius: f2, startAngle: m1, endAngle: m2, clockwise: true)

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + f1, y: y + st))
		path2.addLine(to: CGPoint(x: x + sX, y: y + st))
		path2.addArc(center: CGPoint(x: x + sX, y: y + st + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path2.addLine(to: CGPoint(x: x + w, y: y + en - f1))
		path2.addArc(center: CGPoint(x + w - f1, y + en - f1), radius: f1, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + f1, y: y + en))
		path2.addArc(center: CGPoint(x: x + f1, y: y + en - f1), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path2.addLine(to: CGPoint(x: x, y: y + st + f1))
		path2.addArc(center: CGPoint(x: x + f1, y: y + st + f1), radius: f1, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path2.closeSubpath()

		let path3 = CGMutablePath()
		m1 = atan2(st - midY, x2 - midX)
		m2 = atan2((y + st) - (y + midY), (x + x1) - (x + midX))
		path3.move(to: CGPoint(x: x + x2, y: y + st))
		path3.addArc(center: CGPoint(x: x + midX, y: y + midY), radius: f2, startAngle: m1, endAngle: m2, clockwise: false)

		m1 = atan2(en - midY, x2 - midX)
		m2 = atan2(en - midY, x1 - midX)
		path3.move(to: CGPoint(x: x + x2, y: y + en))
		path3.addArc(center: CGPoint(x: x + midX, y: y + midY), radius: f2, startAngle: m1, endAngle: m2, clockwise: true)
		path3.move(to: CGPoint(x: x + f1, y: y + st))
		path3.addLine(to: CGPoint(x: x + sX, y: y + st))
		path3.addArc(center: CGPoint(x: x + sX, y: y + st + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path3.addLine(to: CGPoint(x: x + w, y: y + en - f1))
		path3.addArc(center: CGPoint(x + w - f1, y + en - f1), radius: f1, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + f1, y: y + en))
		path3.addArc(center: CGPoint(x: x + f1, y: y + en - f1), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path3.addLine(to: CGPoint(x: x, y: y + st + f1))
		path3.addArc(center: CGPoint(x: x + f1, y: y + st + f1), radius: f1, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x, y: y + st, width: w, height: en - st)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func rectQuote(frame: CGRect) -> PresetPathInfo {
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(0.16, Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let sY = h - f1
		let mini = min(w, h)
		var midX = 0.12 * mini

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.075 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + 0.075 * mini))
		path1.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.075 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.017_5 * mini))

		path1.addArc(center: CGPoint(x: x + midX - (0.02 * mini), y: y + 0.075 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path1.closeSubpath()

		path1.move(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.075 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + 0.075 * mini))
		path1.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.075 * mini), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.037_5 * mini))
		path1.addArc(center: CGPoint(x: x + midX + (0.12 * mini), y: y + 0.075 * mini), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path1.closeSubpath()

		midX = w - midX

		path1.move(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.075 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX - (0.02 * mini), y: y + h - 0.075 * mini))
		path1.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.075 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.037_5 * mini))
		path1.addArc(center: CGPoint(x: x + midX - (0.12 * mini), y: y + h - 0.075 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path1.closeSubpath()

		path1.move(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.075 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.15 * mini))
		path1.addLine(to: CGPoint(x: x + midX + (0.12 * mini), y: y + h - 0.075 * mini))
		path1.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.075 * mini), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.037_5 * mini))
		path1.addArc(center: CGPoint(x: x + midX + (0.02 * mini), y: y + h - 0.075 * mini), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + 0.4 * mini, y: y))
		path2.addLine(to: CGPoint(x: x + sX, y: y))
		path2.addArc(center: CGPoint(x + sX, y + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path2.addLine(to: CGPoint(x: x + w, y: y + h - 0.3 * mini))
		path2.move(to: CGPoint(x: x + w - 0.4 * mini, y: y + h))
		path2.addLine(to: CGPoint(x: x + f1, y: y + h))
		path2.addArc(center: CGPoint(x + f1, y + sY), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path2.addLine(to: CGPoint(x: x, y: y + 0.3 * mini))

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x + f1, y: y))
		path3.addLine(to: CGPoint(x: x + sX, y: y))
		path3.addArc(center: CGPoint(x: x + sX, y: y + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path3.addLine(to: CGPoint(x: x + w, y: y + sY))
		path3.addArc(center: CGPoint(x: x + w - f1, y: y + sY), radius: f1, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + f1, y: y + h))
		path3.addArc(center: CGPoint(x: x + f1, y: y + sY), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path3.addLine(to: CGPoint(x: x, y: y + f1))
		path3.addArc(center: CGPoint(x: x + f1, y: y + f1), radius: f1, startAngle: .pi, endAngle: 3.0 * .pi / 2, clockwise: false)

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x + 0.25 * mini, y: y + 0.16 * mini, width: w - 0.25 * mini * 2, height: h - 0.15 * mini - 0.16 * mini)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func topBanner(frame: CGRect) -> PresetPathInfo {
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let yy = 0.8 * h
		let midX = w * 0.5
		let difX = 0.2 * w
		let linwid = min(w, h) * 0.05
		let linst = linwid

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x + difX, y: y))
		path1.addLine(to: CGPoint(x: x + difX, y: y + h))
		path1.addLine(to: CGPoint(x: x + midX, y: y + yy))
		path1.addLine(to: CGPoint(x: x + w - difX, y: y + h))
		path1.addLine(to: CGPoint(x: x + w - difX, y: y))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x, y: y + linst))
		path2.addLine(to: CGPoint(x: x + w, y: y + linst))

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x + difX, y: y))
		path3.addLine(to: CGPoint(x: x + difX, y: y + h))
		path3.addLine(to: CGPoint(x: x + midX, y: y + yy))
		path3.addLine(to: CGPoint(x: x + w - difX, y: y + h))
		path3.addLine(to: CGPoint(x: x + w - difX, y: y))
		path3.closeSubpath()
		path3.move(to: CGPoint(x: x, y: y + linst))
		path3.addLine(to: CGPoint(x: x + w, y: y + linst))

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x + difX, y: y + linst, width: w - 2 * difX, height: yy - 2 * linst)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func twinComet(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midY = h * 0.5
		var mini = min(w, h)
		let a = 0.25 - modifiers[0]
		let tex = a * w + 0.05 * mini
		if mini > 50 {
			mini = 50
		}

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y + midY))
		path.addLine(to: CGPoint(x: x + a * w, y: y + midY - 0.05 * mini))
		path.addQuadCurve(to: CGPoint(x + a * w, y + midY + 0.05 * mini), control: CGPoint(x + w * a + 0.05 * mini * 1.5, y + midY))
		path.closeSubpath()

		path.move(to: CGPoint(x: x + w, y: y + midY))
		path.addLine(to: CGPoint(x: x + w - a * w, y: y + midY - 0.05 * mini))
		path.addQuadCurve(to: CGPoint(x: x + w - a * w, y: y + midY + 0.05 * mini), control: CGPoint(x: x + w - a * w - 0.05 * mini * 1.5, y: y + midY))
		path.closeSubpath()

		let textFrame = CGRect(x: x + tex, y: y, width: w - tex * 2, height: h)
		let animationFrame = frame
		let handles = [CGPoint(a * w + 0.05 * mini, midY)]
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// getControlPointsForEllipse in Preset + CGPath has been modified from the previous getControlPointsForEllipse an additional optional variable multiplier has been added
	func circleQuote(frame: CGRect) -> PresetPathInfo {
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let rx1 = w * 0.4
		let ry1 = h * 0.4
		let mini = min(w, h)
		let a = getEllipseCoordinates(angle1: .pi * 7 / 6, angle2: .pi / 6, rx: rx1, ry: ry1, mid: CGPoint(midX, midY))
		let mid1X = a[0]
		let mid1Y = a[1]
		let mid2X = a[2]
		let mid2Y = a[3]
		let b = getEllipseCoordinates(angle1: .pi * 23 / 18, angle2: .pi / 12, rx: rx1, ry: ry1, mid: CGPoint(midX, midY))
		let c = getEllipseCoordinates(angle1: .pi * 5 / 18, angle2: .pi * 13 / 12, rx: rx1, ry: ry1, mid: CGPoint(midX, midY))

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x + b[0], y: y + b[1]))
		let controlPoint = getControlPointsForEllipse(framePoint1: CGPoint(x: x + b[0], y: y + b[1]), framePoint2: CGPoint(x + b[2], y + b[3]), startAngle: .pi * 23 / 18, endAngle: .pi / 12, rx: rx1, ry: ry1, multiplier: 2)
		path1.addCurve(to: CGPoint(x + b[2], y + b[3]), control1: CGPoint(controlPoint[0].x, controlPoint[0].y), control2: CGPoint(controlPoint[1].x, controlPoint[1].y))
		path1.move(to: CGPoint(x: x + c[0], y: y + c[1]))
		let controlpoint2 = getControlPointsForEllipse(framePoint1: CGPoint(x: x + c[0], y: y + c[1]), framePoint2: CGPoint(x + c[2], y + c[3]), startAngle: .pi * 5 / 18, endAngle: .pi * 13 / 12, rx: rx1, ry: ry1, multiplier: 2)
		path1.addCurve(to: CGPoint(x + c[2], y + c[3]), control1: controlpoint2[0], control2: controlpoint2[1])

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + mid1X - (0.01 * mini), y: y + mid1Y))
		path2.addLine(to: CGPoint(x: x + mid1X - (0.01 * mini), y: y + mid1Y + 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid1X - (0.06 * mini), y: y + mid1Y + 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid1X - (0.06 * mini), y: y + mid1Y))
		path2.addArc(center: CGPoint(x: x + mid1X - (0.01 * mini), y: y + mid1Y), radius: 0.05 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + mid1X - (0.01 * mini), y: y + mid1Y - 0.018_75 * mini))
		path2.addArc(center: CGPoint(x: x + mid1X - (0.01 * mini), y: y + mid1Y), radius: 0.025 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: x + mid1X + (0.06 * mini), y: y + mid1Y))
		path2.addLine(to: CGPoint(x: x + mid1X + (0.06 * mini), y: y + mid1Y + 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid1X + (0.01 * mini), y: y + mid1Y + 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid1X + (0.01 * mini), y: y + mid1Y))
		path2.addArc(center: CGPoint(x: x + mid1X + (0.06 * mini), y: y + mid1Y), radius: 0.05 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + mid1X + (0.06 * mini), y: y + mid1Y - 0.018_75 * mini))
		path2.addArc(center: CGPoint(x: x + mid1X + (0.06 * mini), y: y + mid1Y), radius: 0.025 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: x + mid2X - (0.06 * mini), y: y + mid2Y))
		path2.addLine(to: CGPoint(x: x + mid2X - (0.06 * mini), y: y + mid2Y - 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid2X - (0.01 * mini), y: y + mid2Y - 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid2X - (0.01 * mini), y: y + mid2Y))
		path2.addArc(center: CGPoint(x: x + mid2X - (0.06 * mini), y: y + mid2Y), radius: 0.05 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + mid2X - (0.06 * mini), y: y + mid2Y + 0.018_75 * mini))
		path2.addArc(center: CGPoint(x: x + mid2X - (0.06 * mini), y: y + mid2Y), radius: 0.025 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: x + mid2X + (0.01 * mini), y: y + mid2Y))
		path2.addLine(to: CGPoint(x: x + mid2X + (0.01 * mini), y: y + mid2Y - 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid2X + (0.06 * mini), y: y + mid2Y - 0.037_5 * mini))
		path2.addLine(to: CGPoint(x: x + mid2X + (0.06 * mini), y: y + mid2Y))
		path2.addArc(center: CGPoint(x: x + mid2X + (0.01 * mini), y: y + mid2Y), radius: 0.05 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + mid2X + (0.01 * mini), y: y + mid2Y + 0.018_75 * mini))
		path2.addArc(center: CGPoint(x: x + mid2X + (0.01 * mini), y: y + mid2Y), radius: 0.025 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path2.closeSubpath()

		// Path for the region for selection in the shape
		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x + midX - rx1, y: y + midY))
		path3.addEllipse(in: CGRect(x: rx1, y: ry1, width: midX, height: midY))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: x + mid1X - (0.02 * mini), y: y + mid1Y))
		path3.addLine(to: CGPoint(x: x + mid1X - (0.02 * mini), y: y + mid1Y + 0.075 * mini))
		path3.addLine(to: CGPoint(x: x + mid1X - (0.12 * mini), y: y + mid1Y + 0.075 * mini))
		path3.addLine(to: CGPoint(x: x + mid1X - (0.12 * mini), y: y + mid1Y))
		path3.addArc(center: CGPoint(x: x + mid1X - (0.02 * mini), y: y + mid1Y), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + mid1X - (0.02 * mini), y: y + mid1Y - 0.037_5 * mini))
		path3.addArc(center: CGPoint(x: x + mid1X - (0.02 * mini), y: y + mid1Y), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: x + mid1X + (0.12 * mini), y: y + mid1Y))
		path3.addLine(to: CGPoint(x: x + mid1X + (0.12 * mini), y: y + mid1Y + 0.075 * mini))
		path3.addLine(to: CGPoint(x: x + mid1X + (0.02 * mini), y: y + mid1Y + 0.075 * mini))
		path3.addLine(to: CGPoint(x: x + mid1X + (0.02 * mini), y: y + mid1Y))
		path3.addArc(center: CGPoint(x: x + mid1X + (0.12 * mini), y: y + mid1Y), radius: 0.1 * mini, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + mid1X + (0.12 * mini), y: y + mid1Y - 0.037_5 * mini))
		path3.addArc(center: CGPoint(x: x + mid1X + (0.12 * mini), y: y + mid1Y), radius: 0.05 * mini, startAngle: 3 * .pi / 2, endAngle: .pi, clockwise: true)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: x + mid2X - (0.12 * mini), y: y + mid2Y))
		path3.addLine(to: CGPoint(x: x + mid2X - (0.12 * mini), y: y + mid2Y - (0.075 * mini)))
		path3.addLine(to: CGPoint(x: x + mid2X - (0.02 * mini), y: y + mid2Y - (0.075 * mini)))
		path3.addLine(to: CGPoint(x: x + mid2X - (0.02 * mini), y: y + mid2Y))
		path3.addArc(center: CGPoint(x: x + mid2X - (0.12 * mini), y: y + mid2Y), radius: 0.1 * mini, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + mid2X - (0.12 * mini), y: y + mid2Y + 0.013_75 * mini))
		path3.addArc(center: CGPoint(x: x + mid2X - (0.12 * mini), y: y + mid2Y), radius: 0.05 * mini, startAngle: .pi / 2, endAngle: 0, clockwise: true)
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x + mid1X + (0.12 * mini), y: y + mid1Y + 0.075 * mini, width: mid2X - (mid1X + 0.12 * mini) - 0.12 * mini, height: mid2Y - (mid1Y + 0.075 * mini))
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func fourEdgedFrame(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let a = 0.5 - modifiers[0]
		let mini = min(w, h)

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x, y: y))
		path1.addLine(to: CGPoint(x: x + w, y: y))
		path1.addLine(to: CGPoint(x: x + w, y: y + h))
		path1.addLine(to: CGPoint(x: x, y: y + h))
		path1.addLine(to: CGPoint(x: x, y: y))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + (a * mini), y: y))
		path2.addLine(to: CGPoint(x: x, y: y))
		path2.addLine(to: CGPoint(x: x, y: y + (a * mini)))
		path2.move(to: CGPoint(x: x + (w - a * mini), y: y))
		path2.addLine(to: CGPoint(x: x + w, y: y))
		path2.addLine(to: CGPoint(x: x + w, y: y + a * mini))
		path2.move(to: CGPoint(x: x + w, y: y + (h - a * mini)))
		path2.addLine(to: CGPoint(x: x + w, y: y + h))
		path2.addLine(to: CGPoint(x: x + (w - a * mini), y: y + h))
		path2.move(to: CGPoint(x: x, y: y + (h - a * mini)))
		path2.addLine(to: CGPoint(x: x, y: y + h))
		path2.addLine(to: CGPoint(x: x + (a * mini), y: y + h))

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x, y: y))
		path3.addLine(to: CGPoint(x: x + w, y: y))
		path3.addLine(to: CGPoint(x: x + w, y: y + h))
		path3.addLine(to: CGPoint(x: x, y: y + h))
		path3.addLine(to: CGPoint(x: x, y: y))
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let handles = [CGPoint(a * mini, 0)]
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// Check about the dotted part and border stroking part
	func dottedSign(frame: CGRect) -> PresetPathInfo {
		let x: CGFloat = frame.origin.x, y: CGFloat = frame.origin.y, w: CGFloat = frame.size.width, h: CGFloat = frame.size.height
		let f1 = getCoordinates(0.16, Width: w, Height: h, Percent: 0.5, Type: "z")
		let sX = w - f1
		let sY = h - f1
		let f2 = getCoordinates(0.16, Width: w * 0.6, Height: h * 0.6, Percent: 0.5, Type: "z")

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: x + f1, y: y))
		path1.addLine(to: CGPoint(x: x + sX, y: y))
		path1.addArc(center: CGPoint(x: x + sX, y: y + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path1.addLine(to: CGPoint(x: x + w, y: y + sY))
		path1.addArc(center: CGPoint(x: x + sX, y: y + sY), radius: w - sX, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: x + f1, y: y + h))
		path1.addArc(center: CGPoint(x: x + f1, y: y + sY), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path1.addLine(to: CGPoint(x: x, y: y + f1))
		path1.addArc(center: CGPoint(x: x + f1, y: y + f1), radius: f1, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: x + f1, y: y + f1 - f2))
		path2.addLine(to: CGPoint(x: x + w - f1, y: y + f1 - f2))
		path2.addArc(center: CGPoint(x: x + w - f1, y: y + f1), radius: f2, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path2.addLine(to: CGPoint(x: x + w - f1 + f2, y: y + h - f1))
		path2.addArc(center: CGPoint(x: x + w - f1, y: y + h - f1), radius: f2, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: x + f1, y: y + h - f1 + f2))
		path2.addArc(center: CGPoint(x: x + f1, y: y + h - f1), radius: f2, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path2.addLine(to: CGPoint(x: x + f1 - f2, y: y + f1))
		path2.addArc(center: CGPoint(x: x + f1, y: y + f1), radius: f2, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: x + f1, y: y))
		path3.addLine(to: CGPoint(x: x + sX, y: y))
		path3.addArc(center: CGPoint(x: x + sX, y: y + f1), radius: f1, startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
		path3.addLine(to: CGPoint(x: x + w, y: y + sY))
		path3.addArc(center: CGPoint(x: x + sX, y: y + sY), radius: w - sX, startAngle: 0, endAngle: .pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: x + f1, y: y + h))
		path3.addArc(center: CGPoint(x: x + f1, y: y + sY), radius: f1, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
		path3.addLine(to: CGPoint(x: x, y: y + f1))
		path3.addArc(center: CGPoint(x: x + f1, y: y + f1), radius: f1, startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
		path3.closeSubpath()

		let pathArray = [path1, path2, path3]
		let textFrame = CGRect(x: x + f1 - f2, y: y + f1 - f2, width: w - f1 + f2, height: h - f1 + f2)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}
}

// swiftlint:enable file_length
