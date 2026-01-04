//
//  Preset+FlowCharts.swift
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
	func predefinedProcess(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: x, y: CGFloat(y + h)))
		path.closeSubpath()

		path.move(to: CGPoint(x: CGFloat(x + (w * (1.0 / 8.0))), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + (w * (1.0 / 8.0))), y: y + h))

		path.move(to: CGPoint(x: CGFloat(x + w - (w * (1.0 / 8.0))), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w - (w * (1.0 / 8.0))), y: y + h))

		let x1: CGFloat = (1.0 / 8.0) * w
		let x2: CGFloat = w - x1

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func internalStorage(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: x, y: CGFloat(y + h)))
		path.closeSubpath()

		path.move(to: CGPoint(x: CGFloat(x + (w * (1.0 / 8.0))), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + (w * (1.0 / 8.0))), y: y + h))
		path.move(to: CGPoint(x: CGFloat(x), y: y + (h * (1.0 / 8.0))))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y + (h * (1.0 / 8.0))))

		let x1: CGFloat = (1.0 / 8.0) * w
		let y1: CGFloat = (1.0 / 8.0) * h

		let textFrame = CGRect(x: x + x1, y: y + y1, width: w - x1, height: h - y1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func flowchartDocument(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX = w * 0.5
		let midY = h * 0.5
		let c2 = 0.933 * h
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x, y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y + h * 0.802))
		path.addCurve(to: CGPoint(x: CGFloat(x), y: y + h * 0.934), control1: CGPoint(x: x + w * 0.5, y: y + h * 0.802), control2: CGPoint(x: x + w * 0.5, y: y + h * 1.107_5))
		//        path.addLine(to: CGPoint(x: x, y: y))
		path.closeSubpath()

		let y1: CGFloat = 0.802 * h
		let textFrame = CGRect(x: x, y: y, width: w, height: y1)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, midY, 180], [midX, c2, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func process(frame: CGRect) -> PresetPathInfo {
		return self.rect(frame: frame)
	}

	func alternateProcess(frame: CGRect) -> PresetPathInfo {
		return roundRect(frame: frame)
	}

	func decision(frame: CGRect) -> PresetPathInfo {
		return diamond(frame: frame)
	}

	func data(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = (1.0 / 5.0) * w
		let x2: CGFloat = (4.0 / 5.0) * w
		let midY = h * 0.5
		let midX = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: y))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: x, y: CGFloat(y + h)))
		path.closeSubpath()

		let c1 = (9 / 10) * w
		let c2 = (2 / 5) * w
		let c3 = (1 / 10) * w
		let c4 = (3 / 5) * w

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [c4, 0, 270], [c3, midY, 180], [c2, h, 90], [midX, h, 90], [c1, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func multiDocument(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = (9_298.0 / 21_600.0) * w
		let x2: CGFloat = (18_595.0 / 21_600.0) * w
		let x3: CGFloat = (1_532.0 / 21_600.0) * w
		let x4: CGFloat = (20_000.0 / 21_600.0) * w
		let x5: CGFloat = (19_298.0 / 21_600.0) * w
		let x6: CGFloat = (2_972.0 / 21_600.0) * w
		let x7: CGFloat = (20_800.0 / 21_600.0) * w
		let y1: CGFloat = (20_782.0 / 21_600.0) * h
		let y2: CGFloat = (23_542.0 / 21_600.0) * h
		let y3: CGFloat = (18_022.0 / 21_600.0) * h
		let y4: CGFloat = (3_675.0 / 21_600.0) * h
		let y5: CGFloat = (1_815.0 / 21_600.0) * h
		let y6: CGFloat = (16_252.0 / 21_600.0) * h
		let y7: CGFloat = (16_352.0 / 21_600.0) * h
		let y8: CGFloat = (14_392.0 / 21_600.0) * h
		let y9: CGFloat = (14_467.0 / 21_600.0) * h

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y1)))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)), control2: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path1.closeSubpath()
		path1.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y5)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y5)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y6)))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y7)), control1: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y6)), control2: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y7)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path1.closeSubpath()
		path1.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y8)))
		path1.addCurve(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y9)), control1: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + y8)), control2: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y9)))
		path1.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y5)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y1)))
		path2.addCurve(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)), control1: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)), control2: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path2.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + y4)))
		path2.closeSubpath()
		path2.move(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y5)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y5)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y6)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
		path2.move(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y5)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y)))
		path2.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path2.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + y8)))
		path2.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y8)))

		let c1 = (12286 / 21600) * h
		let midY = h * 0.5

		let pathArray = [path1, path2]
		let textFrame = CGRect(x: x, y: y + y4, width: x2, height: y1 - y4)
		let animationFrame = frame
		let connector = [[c1, 0, 270], [0, midY, 180], [x1, y1, 90], [w, midY, 0]]
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func terminator(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = (3_475.0 / 21_600.0) * w
		let x2: CGFloat = (18_125.0 / 21_600.0) * w
		let ry: CGFloat = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x + x1, y))
		path.addLine(to: CGPoint(x + x2, y))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x2, y), framePoint2: CGPoint(x + w, y + ry), startAngle: (.pi / 2) * 3, endAngle: 0, rx: x1, ry: ry)

		path.addCurve(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + ry)), control1: controlPoint[0], control2: controlPoint[1])
		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + ry), framePoint2: CGPoint(x + x2, y + h), startAngle: 0, endAngle: .pi / 2, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x + x2, y + h), control1: controlPoint[0], control2: controlPoint[1])
		path.addLine(to: CGPoint(x + x1, y + h))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + h), framePoint2: CGPoint(x, y + ry), startAngle: .pi / 2, endAngle: .pi, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + ry), framePoint2: CGPoint(x + x1, y), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x + x1, y), control1: controlPoint[0], control2: controlPoint[1])
		path.closeSubpath()

		let l: CGFloat = (1_018.0 / 21_600.0) * w
		let r: CGFloat = (20_582.0 / 21_600.0) * w
		let t: CGFloat = (3_163.0 / 21_600.0) * h
		let b: CGFloat = (18_437.0 / 21_600.0) * h

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func preparation(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = 0.2 * w
		let x2: CGFloat = w - x1
		let midY: CGFloat = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midY)))
		path.closeSubpath()

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func manualInput(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let yy: CGFloat = 0.2 * h

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + yy)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path.closeSubpath()
		let y1: CGFloat = 0.2 * h

		let textFrame = CGRect(x: x, y: y + y1, width: w, height: h - y1)
		let animationFrame = frame
		let c1 = 0.1 * h
		let midX = w * 0.5
		let midY = h * 0.5
		let connector = [[midX, c1, 270], [0, midY, 180], [midX, h, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func manualOperation(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = 0.2 * w
		let x2: CGFloat = w - x1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.closeSubpath()

		let c1 = 0.1 * w
		let c2 = 0.9 * w
		let midY = h * 0.5
		let midX = w * 0.5

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [c1, midY, 180], [midX, h, 90], [c2, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func presetConnector(frame: CGRect) -> PresetPathInfo {
		return self.oval(frame: frame)
	}

	func presetOffpageConnector(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let yy: CGFloat = 0.8 * h
		let midX: CGFloat = w * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + yy)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + yy)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.closeSubpath()

		let textFrame = CGRect(x: x, y: y, width: w, height: yy)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func punchedCard(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let xx: CGFloat = 0.2 * w
		let yy: CGFloat = 0.2 * h

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + xx), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + yy)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.closeSubpath()

		let y1: CGFloat = 0.2 * h
		let textFrame = CGRect(x: x, y: y + y1, width: w, height: h - y1)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func punchedTape(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let y1: CGFloat = 0.1 * h
		let y2: CGFloat = h - y1
		let rx: CGFloat = w * 0.25

		let path = CGMutablePath()
		path.move(to: CGPoint(x, y + y1))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.25, y + y1 + y1), framePoint2: CGPoint(x, y + y1), startAngle: .pi / 2, endAngle: .pi, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x: CGFloat(x + w * 0.25), y: CGFloat(y + y1 + y1)), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.5, y + y1), framePoint2: CGPoint(x + w * 0.25, y + y1 + y1), startAngle: 0, endAngle: .pi / 2, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w * 0.5, y + y1), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.5, y + y1), framePoint2: CGPoint(x + w * 0.75, y), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w * 0.75, y), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.75, y), framePoint2: CGPoint(x + w, y + y1), startAngle: (.pi / 2) * 3, endAngle: 0, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path.addLine(to: CGPoint(x + w, y + y2))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.75, y + h - (y1 + y1)), framePoint2: CGPoint(x + w, y + h - y1), startAngle: (.pi / 2) * 3, endAngle: 0, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w * 0.75, y + h - (y1 + y1)), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.5, y + h - y1), framePoint2: CGPoint(x + w * 0.75, y + h - (y1 + y1)), startAngle: .pi, endAngle: (.pi / 2) * 3, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w * 0.5, y + h - y1), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.5, y + h - y1), framePoint2: CGPoint(x + w * 0.25, y + h), startAngle: CGFloat(0), endAngle: .pi / 2, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x + w * 0.25, y + h), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w * 0.25, y + h), framePoint2: CGPoint(x, y + h - y1), startAngle: .pi / 2, endAngle: .pi, rx: rx, ry: y1)
		path.addCurve(to: CGPoint(x, y + h - y1), control1: controlPoint[0], control2: controlPoint[1])
		path.closeSubpath()

		let t1: CGFloat = 0.2 * h
		let t2: CGFloat = h - t1
		let midX = w * 0.5
		let midY = h * 0.5

		let textFrame = CGRect(x: x, y: y + t1, width: w, height: t2 - t1)
		let animationFrame = frame
		let connector = [[midX, y1, 270], [0, midY, 180], [midX, y2, 90], [w, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func summingJunction(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.addEllipse(in: frame)

		var point1 = CGPoint.zero
		var point2 = CGPoint.zero

		point1.x = x + w * 0.5 + (w * 0.5) * CGFloat(cosf(Float.pi / 4))
		point1.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float.pi / 4))
		point2.x = x + w * 0.5 + (w * 0.5) * CGFloat(cosf(Float(225) * (Float.pi / 180.0)))
		point2.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float(225) * (Float.pi / 180.0)))

		path.move(to: point1)
		path.addLine(to: point2)

		point1.x = x + w * 0.5 + (w * 0.5) * CGFloat(cosf(Float(135) * (Float.pi / 180.0)))
		point1.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float(135) * (Float.pi / 180.0)))
		point2.x = x + w * 0.5 + (w * 0.5) * CGFloat(cosf(Float(315) * (Float.pi / 180.0)))
		point2.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float(315) * (Float.pi / 180.0)))
		path.move(to: point1)
		path.addLine(to: point2)

		let textFrame = setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func or(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.addEllipse(in: frame)
		path.move(to: CGPoint(x + w * 0.5, y))
		path.addLine(to: CGPoint(x + w * 0.5, y + h))
		path.move(to: CGPoint(x, y + h * 0.5))
		path.addLine(to: CGPoint(x + w, y + h * 0.5))

		let textFrame = setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame)
	}

	func collate(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.closeSubpath()

		let r: CGFloat = 0.75 * w
		let b: CGFloat = 0.75 * h
		let l: CGFloat = 0.25 * w
		let t: CGFloat = 0.25 * h
		let midX = w * 0.5
		let midY = h * 0.5

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [midX, midY, 270], [midX, h, 90]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sort(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h * 0.5)))
		path.addLine(to: CGPoint(x: CGFloat(x + w * 0.5), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h * 0.5)))
		path.addLine(to: CGPoint(x: CGFloat(x + w * 0.5), y: CGFloat(y)))
		path.closeSubpath()
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h * 0.5)))

		let r: CGFloat = 0.75 * w
		let b: CGFloat = 0.75 * h
		let l: CGFloat = 0.25 * w
		let t: CGFloat = 0.25 * h

		let textFrame = CGRect(x: x + l, y: y + t, width: r - l, height: b - t)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func extract(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + w * 0.5), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path.closeSubpath()

		let x1: CGFloat = 0.25 * w
		let x2: CGFloat = 0.75 * w
		let midX: CGFloat = 0.5 * w
		let midY: CGFloat = 0.5 * h

		let textFrame = CGRect(x: x + x1, y: y + midY, width: x2 - x1, height: h - midY)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [x1, midY, 180], [midX, h, 90], [x2, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func merge(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + w * 0.5), y: CGFloat(y + h)))
		path.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path.closeSubpath()

		let x1: CGFloat = 0.25 * w
		let x2: CGFloat = 0.75 * w
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: midY)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [x1, midY, 180], [midX, h, 90], [x2, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func storedData(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		let x1: CGFloat = (1.0 / 6.0) * w
		let ry: CGFloat = h * 0.5

		path.move(to: CGPoint(x + x1, y))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + ry), framePoint2: CGPoint(x + x1, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x, y + ry), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + h), framePoint2: CGPoint(x, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x + x1, y + h), control1: controlPoint[1], control2: controlPoint[0])
		path.addLine(to: CGPoint(x + w, y + h))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + h), framePoint2: CGPoint(x + w - x1, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x + w - x1, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w - x1, y + ry), framePoint2: CGPoint(x + w, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x1, ry: ry)
		path.addCurve(to: CGPoint(x + w, y), control1: controlPoint[0], control2: controlPoint[1])
		path.closeSubpath()

		let x2: CGFloat = w - x1
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = [[midX, 0, 270], [0, midY, 180], [midX, h, 90], [x2, midY, 0]]
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func delay(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x, y))

		let rx: CGFloat = w * 0.5
		let ry: CGFloat = h * 0.5
		path.addLine(to: CGPoint(x + rx, y))
		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + rx, y), framePoint2: CGPoint(x + w, y + ry), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: rx, ry: ry)
		path.addCurve(to: CGPoint(x + w, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + ry), framePoint2: CGPoint(x + rx, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: rx, ry: ry)
		path.addCurve(to: CGPoint(x + rx, y + h), control1: controlPoint[0], control2: controlPoint[1])
		path.addLine(to: CGPoint(x, y + h))
		path.closeSubpath()

		let angle1: CGFloat = ((.pi * 225) / 180)
		let angle2: CGFloat = ((.pi * 45) / 180)
		let a: [CGFloat] = getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx, ry: ry, mid: CGPoint(-1, -1))

		let textFrame = CGRect(x: x, y: y + a[1], width: a[2], height: a[3] - a[1])
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func sequentialAccessStorage(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + w * 0.5), y: CGFloat(y + h)))

		var fullQuadrant: CGFloat = 3
		var quadrantNumber: CGFloat = 2
		var startAngle: CGFloat = 0.0
		var endAngle = CGFloat.pi / 2
		var framePoint1 = CGPoint.zero
		var framePoint2 = CGPoint.zero
		framePoint2.x = x + w * 0.5
		framePoint2.y = y + h
		var controlPoint: [CGPoint]

		while fullQuadrant > 0 {
			framePoint1 = framePoint2
			startAngle = endAngle
			endAngle = quadrantNumber * CGFloat.pi / 2
			framePoint2.x = x + w * 0.5 + w * 0.5 * CGFloat(cosf(Float(endAngle)))
			framePoint2.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float(endAngle)))
			controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w * 0.5, ry: h * 0.5)
			path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])
			fullQuadrant -= 1
			quadrantNumber += 1
		}

		framePoint1.x = x + w
		framePoint1.y = y + h * 0.5
		framePoint2.x = x + w * 0.5 + w * 0.5 * CGFloat(cosf(Float.pi / 4))
		framePoint2.y = y + h * 0.5 + h * 0.5 * CGFloat(sinf(Float.pi / 4))

		startAngle = 0
		endAngle = CGFloat.pi / 4

		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: w * 0.5, ry: h * 0.5)
		path.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		path.addLine(to: CGPoint(x + w, framePoint2.y))
		path.addLine(to: CGPoint(x + w, y + h))
		path.closeSubpath()

		let textFrame = setTextBox(midX: w * 0.5, midY: h * 0.5, frame: frame)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func magneticDisk(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let f0: CGFloat = getCoordinates(0.25, Width: w, Height: h, Percent: 0.5, Type: "y")
		let y1: CGFloat = f0 * 0.5
		let y2: CGFloat = y1 + y1
		let y3: CGFloat = h - y1
		let midX: CGFloat = w * 0.5

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + y1))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + y1), framePoint2: CGPoint(x + midX, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y), framePoint2: CGPoint(x + w, y + y1), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: CGFloat.pi / 2, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path1.addLine(to: CGPoint(x, y + y3))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + w, y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path1.addLine(to: CGPoint(x + w, y + y1))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: CGFloat.pi / 2, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: midX, ry: y1)
		path1.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])
		path1.closeSubpath()

		//        path1.move(to: CGPoint(x + w, y + y1))
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle:  (CGFloat.pi/2), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])
		//
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: (CGFloat.pi/2), endAngle:  (CGFloat.pi), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])
		//        path1.addLine(to: CGPoint(x, y + y3))
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: (CGFloat.pi/2), endAngle:  (CGFloat.pi), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[1], control2: controlPoint[0])
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle:  (CGFloat.pi/2), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + w, y + y3), control1: controlPoint[1], control2: controlPoint[0])
		//        path1.addLine(to: CGPoint(x + w, y + y1))
		//        path1.closeSubpath()

		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: (CGFloat.pi/2), endAngle:  (CGFloat.pi), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[1], control2: controlPoint[0])
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle:  (CGFloat.pi/2), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[1], control2: controlPoint[0])
		//
		//        path1.addLine(to: CGPoint(x + w,y + y3))
		//
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle:  (CGFloat.pi/2), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[0], control2: controlPoint[1])
		//        controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: (CGFloat.pi/2), endAngle:  (CGFloat.pi), rx: midX, ry: y1)
		//        path1.addCurve(to: CGPoint(x, y + y3), control1: controlPoint[0], control2: controlPoint[1])
		//        path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x, y + y1))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + y1), framePoint2: CGPoint(x + midX, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + midX, y), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y), framePoint2: CGPoint(x + w, y + y1), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + w, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y1), framePoint2: CGPoint(x + midX, y + y2), startAngle: 0, endAngle: CGFloat.pi / 2, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + midX, y + y2), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + y2), framePoint2: CGPoint(x, y + y1), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x, y + y1), control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x, y + y3))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + midX, y + h), framePoint2: CGPoint(x, y + y3), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + midX, y + h), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + y3), framePoint2: CGPoint(x + midX, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: midX, ry: y1)
		path2.addCurve(to: CGPoint(x + w, y + y3), control1: controlPoint[1], control2: controlPoint[0])

		path2.addLine(to: CGPoint(x + w, y + y1))

		let t: CGFloat = (1.0 / 3.0) * h
		let b: CGFloat = (5.0 / 6.0) * h
		let pathArray = [path1, path2]
		let textFrame = CGRect(x: x, y: y + t, width: w, height: b - t)
		let animationFrame = frame
		let connector = [[midX, t, 270]]
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func directAccessStorage(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = (5.0 / 6.0) * w
		let x2: CGFloat = w - x1
		let ry: CGFloat = h * 0.5

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x + x1, y))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y), framePoint2: CGPoint(x + w, y + ry), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + w, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + ry), framePoint2: CGPoint(x + x1, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x1, y + h), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + h), framePoint2: CGPoint(x + x1 - x2, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x1 - x2, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1 - x2, y + ry), framePoint2: CGPoint(x + x1, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x1, y), control1: controlPoint[0], control2: controlPoint[1])
		path1.addLine(to: CGPoint(x + x2, y))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + ry), framePoint2: CGPoint(x + x2, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x, y + ry), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x2, y + h), framePoint2: CGPoint(x, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x2, y + h), control1: controlPoint[1], control2: controlPoint[0])
		path1.addLine(to: CGPoint(x + x1, y + h))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + h), framePoint2: CGPoint(x + x1 - x2, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x1 - x2, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1 - x2, y + ry), framePoint2: CGPoint(x + x1, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x2, ry: ry)
		path1.addCurve(to: CGPoint(x + x1, y), control1: controlPoint[0], control2: controlPoint[1])
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x + x1, y))
		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y), framePoint2: CGPoint(x + w, y + ry), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x + w, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + ry), framePoint2: CGPoint(x + x1, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x + x1, y + h), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1, y + h), framePoint2: CGPoint(x + x1 - x2, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x + x1 - x2, y + ry), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x1 - x2, y + ry), framePoint2: CGPoint(x + x1, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x + x1, y), control1: controlPoint[0], control2: controlPoint[1])

		path2.addLine(to: CGPoint(x + x2, y))

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x, y + ry), framePoint2: CGPoint(x + x2, y), startAngle: CGFloat.pi, endAngle: (CGFloat.pi / 2) * 3, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x, y + ry), control1: controlPoint[1], control2: controlPoint[0])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x2, y + h), framePoint2: CGPoint(x, y + ry), startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, rx: x2, ry: ry)
		path2.addCurve(to: CGPoint(x + x2, y + h), control1: controlPoint[1], control2: controlPoint[0])
		path2.addLine(to: CGPoint(x + x1, y + h))

		let x3: CGFloat = (2.0 / 3.0) * w
		let midY = h * 0.5
		let pathArray = [path1, path2]
		let textFrame = CGRect(x: x + x2, y: y, width: x3 - x2, height: h)
		let animationFrame = frame
		let connector = [[x3, midY, 270]]
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func display(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let x1: CGFloat = (1.0 / 6.0) * w
		let x2: CGFloat = w - x1
		let midy: CGFloat = h * 0.5

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y + midy)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y)))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: CGPoint(x + x2, y), framePoint2: CGPoint(x + w, y + midy), startAngle: (CGFloat.pi / 2) * 3, endAngle: 0, rx: x1, ry: midy)
		path.addCurve(to: CGPoint(x + w, y + midy), control1: controlPoint[0], control2: controlPoint[1])

		controlPoint = self.getControlPointsForEllipse(framePoint1: CGPoint(x + w, y + midy), framePoint2: CGPoint(x + x2, y + h), startAngle: 0, endAngle: CGFloat.pi / 2, rx: x1, ry: midy)
		path.addCurve(to: CGPoint(x + x2, y + h), control1: controlPoint[0], control2: controlPoint[1])

		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + h)))
		path.closeSubpath()

		let textFrame = CGRect(x: x + x1, y: y, width: x2 - x1, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: [path], textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func plus(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let a1: CGFloat = modifiers[0]
		let val: CGFloat = 0.734_90
		let xval: CGFloat = val * w * 0.5
		let yval: CGFloat = val * h * 0.5
		var f1: CGFloat = getCoordinates(a1, Width: w, Height: h, Percent: 0.734_90, Type: "z")
		f1 *= 0.5

		let x1: CGFloat = midX - f1
		let x2: CGFloat = midX + f1
		let y1: CGFloat = midY - f1
		let y2: CGFloat = midY + f1
		let x3: CGFloat = midX - xval
		let x4: CGFloat = midX + xval
		let y3: CGFloat = midY - yval
		let y4: CGFloat = midY + yval

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.closeSubpath()

		let handles = [CGPoint(0, y1)]
		let textFrame = CGRect(x: x + x3, y: y + y1, width: x4 - x3, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x4, midY, 0], [midX, y4, 90], [x3, midY, 180], [midX, y3, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func minus(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		var a1: CGFloat = modifiers[0] * h
		a1 *= 0.5

		let val: CGFloat = 0.367_45
		let xval: CGFloat = val * w
		let x1: CGFloat = midX - xval
		let x2: CGFloat = midX + xval
		let y1: CGFloat = midY - a1
		let y2: CGFloat = midY + a1

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.closeSubpath()

		let handles = [CGPoint(0, y1)]
		let textFrame = CGRect(x: x + x1, y: y + y1, width: x2 - x1, height: y2 - y1)
		let animationFrame = frame
		let connector = [[x2, midY, 0], [midX, y2, 90], [x1, midY, 180], [midX, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func multiply(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let val: CGFloat = 0.519_65
		let f0: CGFloat = getCoordinates(modifiers[0], Width: w, Height: h, Percent: val, Type: "z")
		let a = CGFloat(atan2f(Float(h), Float(w)))

		let sa = CGFloat(sinf(Float(a)))
		let ca = CGFloat(cosf(Float(a)))
		let ta = CGFloat(tanf(Float(a)))
		let a1 = CGFloat(sqrtf(powf(Float(w), 2.0) + powf(Float(h), 2.0)))
		let rw: CGFloat = a1 * val
		let a2: CGFloat = a1 - rw
		let a3: CGFloat = ca * (a2 / 2.0)
		let a4: CGFloat = sa * (a2 / 2.0)
		let a5: CGFloat = sa * (f0 / 2.0)
		let a6: CGFloat = ca * (f0 / 2.0)
		let x1: CGFloat = a3 - a5
		let y1: CGFloat = a4 + a6
		let x2: CGFloat = a3 + a5
		let y2: CGFloat = a4 - a6
		let a7: CGFloat = midX - x2
		let a8: CGFloat = a7 * ta
		let y3: CGFloat = a8 + y2
		let x4: CGFloat = w - x2
		let x5: CGFloat = w - x1
		let a9: CGFloat = midY - y1
		let a10: CGFloat = a9 / ta
		let x6: CGFloat = x5 - a10
		let x7: CGFloat = x1 + a10
		let y5: CGFloat = h - y1
		let y6: CGFloat = h - y2
		let y7: CGFloat = h - y3

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + midY)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + y7)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y6)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y5)))
		path.addLine(to: CGPoint(x: CGFloat(x + x7), y: CGFloat(y + midY)))
		path.closeSubpath()

		let cx1 = (x5 + x4) * 0.5
		let cy1 = (y5 + y6) * 0.5
		let cx2 = (x2 + x1) * 0.5
		let cy2 = (y1 + y2) * 0.5

		let handles = [CGPoint(0, f0)]
		let textFrame = CGRect(x: x + x1, y: y + y2, width: x5 - x1, height: y6 - y2)
		let animationFrame = frame
		let connector = [[cx2, cy2, 180], [cx1, cy2, 270], [cx1, cy1, 0], [cx2, cy1, 90]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func divide(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let ma1: CGFloat = -1 * modifiers[0]
		let ma3h: CGFloat = (0.734_90 + ma1) * 0.25
		let ma3w: CGFloat = 0.367_45 * w / h
		let mx3: CGFloat = min(ma3h, ma3w)
		let md2: CGFloat = limit(value: modifiers[2], minValue: 0.01, maxValue: mx3)
		let m4a3: CGFloat = -4 * md2
		let mx2: CGFloat = 0.734_90 + m4a3 - modifiers[0]
		let md1: CGFloat = limit(value: modifiers[1], minValue: 0, maxValue: mx2)

		let a: [CGFloat] = [modifiers[0], md1, md2]
		//        a[0] = modifier[0]
		//        a[1] = md1
		//        a[2] = md2
		let dy1: CGFloat = a[0] * h * 0.5
		let yg: CGFloat = a[1] * h
		let rad: CGFloat = a[2] * h
		let dx1: CGFloat = w * 0.367_45
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let y3: CGFloat = midY - dy1
		let y4: CGFloat = midY + dy1
		let aa: CGFloat = yg + rad
		let y2: CGFloat = y3 - aa
		let y1: CGFloat = y2 - rad
		let y5: CGFloat = h - y1
		let x1: CGFloat = midX - dx1
		let x3: CGFloat = midX + dx1
		let x2: CGFloat = midX - rad

		// MARK: Unused

//		let x2: CGFloat = midX - rad

		let path = CGMutablePath()
		path.move(to: CGPoint(x: CGFloat(x + midX - rad), y: CGFloat(y + y1)))
		path.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + y1)), radius: rad, startAngle: .pi, endAngle: 3 * .pi, clockwise: false)
		path.move(to: CGPoint(x: CGFloat(x + midX - rad), y: CGFloat(y + y5)))
		path.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + y5)), radius: rad, startAngle: .pi, endAngle: 3 * .pi, clockwise: false)
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y4)))
		path.closeSubpath()

		let handles = [CGPoint(0, y3), CGPoint(w, y2), CGPoint(x2, 0)]
		let textFrame = CGRect(x: x + x1, y: y + y3, width: x3 - x1, height: y4 - y3)
		let animationFrame = frame
		let connector = [[x3, midY, 0], [midX, y5, 90], [x1, midY, 180], [midX, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func equal(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5

		let a1: CGFloat = modifiers[0] * h
		var a2: CGFloat = modifiers[1] * h
		let max: CGFloat = h - (a1 * 2)

		a2 = min(a2, max)
		a2 *= 0.5
		let val: CGFloat = 0.367_45
		let xval: CGFloat = val * w
		let x1: CGFloat = midX - xval
		let x2: CGFloat = midX + xval
		let y2: CGFloat = midY - a2
		let y3: CGFloat = midY + a2
		let y1: CGFloat = y2 - a1
		let y4: CGFloat = y3 + a1
		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.closeSubpath()

		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x2), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y4)))
		path.closeSubpath()

		let c1 = (y1 + y2) * 0.5
		let c2 = (y3 + y4) * 0.5

		let handles = [CGPoint(0, y1), CGPoint(w, y2)]
		let textFrame = CGRect(x: x + x1, y: y + y1, width: x2 - x1, height: y4 - y1)
		let animationFrame = frame
		let connector = [[x2, c1, 0], [x2, c2, 0], [midX, y4, 90], [x1, c1, 180], [x1, c2, 180], [midX, y1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func notEqual(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let path = CGMutablePath()

		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let val: CGFloat = 0.367_45

		let a1: CGFloat = modifiers[0] * h
		var a2: CGFloat = modifiers[2] * h
		let max: CGFloat = h - (a1 * 2)

		a2 = min(a2, max)
		a2 *= 0.5
		let xval: CGFloat = val * w
		let x1: CGFloat = midX - xval
		let x8: CGFloat = midX + xval
		let y2: CGFloat = midY - a2
		let y3: CGFloat = midY + a2
		let y1: CGFloat = y2 - a1
		let y4: CGFloat = y3 + a1
		let ang: CGFloat = modifiers[1]

		let cadj2: CGFloat = ang - ((.pi * 90) / 180)
		let xadj2: CGFloat = midY * CGFloat(tanf(Float(cadj2)))
		let len: CGFloat = sqrt(pow(xadj2, 2) + pow(midY, 2))
		let bhw: CGFloat = len * a1 / midY
		let bhw2: CGFloat = bhw * 0.5
		let x7: CGFloat = midX + xadj2 - bhw2
		let dx67: CGFloat = xadj2 * y1 / midY
		let x6: CGFloat = x7 - dx67
		let dx57: CGFloat = xadj2 * y2 / midY
		let x5: CGFloat = x7 - dx57
		let dx47: CGFloat = xadj2 * y3 / midY
		let x4: CGFloat = x7 - dx47
		let dx37: CGFloat = xadj2 * y4 / midY
		let x3: CGFloat = x7 - dx37
		let rx7: CGFloat = x7 + bhw
		let rx6: CGFloat = x6 + bhw
		let rx5: CGFloat = x5 + bhw
		let rx4: CGFloat = x4 + bhw
		let rx3: CGFloat = x3 + bhw

		let dx7: CGFloat = a1 * midY / len
		let rxt: CGFloat = x7 + dx7
		let lxt: CGFloat = rx7 - dx7
		let rx: CGFloat = (cadj2 > 0) ? rxt : rx7
		let lx: CGFloat = (cadj2 > 0) ? x7 : lxt
		let dy3: CGFloat = a1 * xadj2 / len
		let dy4: CGFloat = 0 - dy3
		let ry: CGFloat = (cadj2 > 0) ? dy3 : 0
		let ly: CGFloat = (cadj2 > 0) ? 0 : dy4
		let dlx: CGFloat = w - rx
		let drx: CGFloat = w - lx
		let dly: CGFloat = h - ry
		let dry: CGFloat = h - ly
		let hx: CGFloat = midX + ((90 - (ang * (180.0 / .pi))) / 80) * rx6

		path.move(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x6), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + lx), y: CGFloat(y + ly)))
		path.addLine(to: CGPoint(x: CGFloat(x + rx), y: CGFloat(y + ry)))
		path.addLine(to: CGPoint(x: CGFloat(x + rx6), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y1)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + rx5), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + rx4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x8), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + rx3), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + drx), y: CGFloat(y + dry)))
		path.addLine(to: CGPoint(x: CGFloat(x + dlx), y: CGFloat(y + dly)))
		path.addLine(to: CGPoint(x: CGFloat(x + x3), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y4)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x4), y: CGFloat(y + y3)))
		path.addLine(to: CGPoint(x: CGFloat(x + x5), y: CGFloat(y + y2)))
		path.addLine(to: CGPoint(x: CGFloat(x + x1), y: CGFloat(y + y2)))
		path.closeSubpath()

		let c1 = (y3 + y4) * 0.5
		let c2 = (y1 + y2) * 0.5
		let cx1 = (lx + rx) * 0.5
		let cy1 = (ly + ry) * 0.5
		let cx2 = (drx + dlx) * 0.5
		let cy2 = (dry + dly) * 0.5

		let handles = [CGPoint(0, y1), CGPoint(hx, h), CGPoint(w, y2)]
		let textFrame = CGRect(x: x + x1, y: y + y1, width: x8 - x1, height: y4 - y1)
		let animationFrame = frame
		let connector = [[x8, c1, 0], [x8, c2, 0], [cx2, cy2, 90], [x1, c1, 180], [x1, c2, 180], [cx1, cy1, 270]]
		return PresetPathInfo(paths: [path], handles: handles, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}
}

// swiftlint:enable file_length
