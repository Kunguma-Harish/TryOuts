//
//  Preset+ActionButtons.swift
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
	func computeEllipticCoords(radiusX rx: CGFloat, radiusY ry: CGFloat, start: CGPoint, startAngle: CGFloat, sweepAngle: CGFloat) -> CGPoint {
		let cx = start.x - rx * CGFloat(cosf(Float(startAngle)))
		let cy = start.y - ry * CGFloat(sinf(Float(startAngle)))
		let endAngle = startAngle + sweepAngle
		var end = CGPoint.zero
		end.x = cx + rx * CGFloat(cosf(Float(endAngle)))
		end.y = cy + ry * CGFloat(sinf(Float(endAngle)))
		return end
	}

	func actionPrevious(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let Ref: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g1: CGFloat = midX - Ref
		let g2: CGFloat = midX + Ref
		let g3: CGFloat = midY - Ref
		let g4: CGFloat = midY + Ref

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionNext(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let Ref: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g1: CGFloat = midX + Ref
		let g2: CGFloat = midX - Ref
		let g3: CGFloat = midY + Ref
		let g4: CGFloat = midY - Ref

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g1), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g3)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g2), y: CGFloat(y + g4)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionBegin(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let Ref: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g1: CGFloat = midY - Ref
		let g2: CGFloat = midY + Ref
		let g3: CGFloat = midX - Ref
		let g4: CGFloat = midX + Ref
		let v2: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g5: CGFloat = v2 * (1.0 / 8.0)
		let g6: CGFloat = v2 * (1.0 / 4.0)
		let g7: CGFloat = g3 + g5
		let g8: CGFloat = g3 + g6

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g2)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g2)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + g2)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionEnd(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let Ref: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g1: CGFloat = midY - Ref
		let g2: CGFloat = midY + Ref
		let g3: CGFloat = midX - Ref
		let g4: CGFloat = midX + Ref
		let v2: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g5: CGFloat = v2 * (3.0 / 4.0)
		let g6: CGFloat = v2 * (7.0 / 8.0)
		let g7: CGFloat = g3 + g5
		let g8: CGFloat = g3 + g6

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g2)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g2)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g7), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + g2)))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + g2)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g8), y: CGFloat(y + g2)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:disable function_body_length
	func actionHome(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let Ref: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g1: CGFloat = midY - Ref
		let g2: CGFloat = midY + Ref
		let g3: CGFloat = midX - Ref
		let g4: CGFloat = midX + Ref
		let v2: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g5: CGFloat = v2 * (1.0 / 16.0)
		let g6: CGFloat = v2 * (1.0 / 8.0)
		let g7: CGFloat = v2 * (3.0 / 16.0)
		let g8: CGFloat = v2 * (5.0 / 16.0)
		let g9: CGFloat = v2 * (7.0 / 16.0)
		let g10: CGFloat = v2 * (9.0 / 16.0)
		let g11: CGFloat = v2 * (11.0 / 16.0)
		let g12: CGFloat = v2 * (3.0 / 4.0)
		let g13: CGFloat = v2 * (13.0 / 16.0)
		let g14: CGFloat = v2 * (7.0 / 8.0)
		let g15: CGFloat = g1 + g5
		let g16: CGFloat = g1 + g7
		let g17: CGFloat = g1 + g8
		let g18: CGFloat = g1 + g12
		let g19: CGFloat = g3 + g6
		let g20: CGFloat = g3 + g9
		let g21: CGFloat = g3 + g10
		let g22: CGFloat = g3 + g11
		let g23: CGFloat = g3 + g13
		let g24: CGFloat = g3 + g14

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g1)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + g2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g2)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + midY)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g17)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g15)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g15)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g16)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + midY)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g18)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g18)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g2)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + midY)))
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g15)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g15)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g17)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g16)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g1)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + midY)))
		path3.closeSubpath()
		path3.move(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g2)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g18)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g18)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g2)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g1)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g17)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g16)))
		path4.closeSubpath()

		path4.move(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g19), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g18)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g18)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + midY)))
		path4.closeSubpath()

		path4.move(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g17)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g16)))
		path4.closeSubpath()

		path4.move(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g1)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g3), y: CGFloat(y + midY)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g4), y: CGFloat(y + midY)))
		path4.closeSubpath()

		path4.move(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g2)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g20), y: CGFloat(y + g18)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g18)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g21), y: CGFloat(y + g2)))
		path4.closeSubpath()

		let path5 = CGMutablePath()
		path5.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path5.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path5.closeSubpath()

		let pathArray = [path1, path2, path3, path4, path5]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionInformation(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let v1: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - v1
		let g11: CGFloat = midX - v1
		let v2: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g14: CGFloat = v2 * (1.0 / 32.0)
		let g17: CGFloat = v2 * (5.0 / 16.0)
		let g18: CGFloat = v2 * (3.0 / 8.0)
		let g19: CGFloat = v2 * (13.0 / 32.0)
		let g20: CGFloat = v2 * (19.0 / 32.0)
		let g22: CGFloat = v2 * (11.0 / 16.0)
		let g23: CGFloat = v2 * (13.0 / 16.0)
		let g24: CGFloat = v2 * (7.0 / 8.0)
		let g25: CGFloat = g9 + g14
		let g28: CGFloat = g9 + g17
		let g29: CGFloat = g9 + g18
		let g30: CGFloat = g9 + g23
		let g31: CGFloat = g9 + g24
		let g32: CGFloat = g11 + g17
		let g34: CGFloat = g11 + g19
		let g35: CGFloat = g11 + g20
		let g37: CGFloat = g11 + g22
		let g38: CGFloat = v2 * (3.0 / 32.0)
		let g39: CGFloat = midX - g38

		let path1_sp1 = CGMutablePath()
		path1_sp1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1_sp1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1_sp1.closeSubpath()

		let path1_sp2 = CGMutablePath()
		path1_sp2.move(to: CGPoint(x: CGFloat(x + g11 + 2 * v1), y: CGFloat(y + midY)))
		path1_sp2.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + midY)), radius: v1, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path2_sp1 = CGMutablePath()
		path2_sp1.move(to: CGPoint(x: CGFloat(x + g11 + 2 * v1), y: CGFloat(y + midY)))
		path2_sp1.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + midY)), radius: v1, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path2_sp2 = CGMutablePath()
		path2_sp2.move(to: CGPoint(x: CGFloat(x + g39 + 2 * g38), y: CGFloat(y + g25 + g38)))
		path2_sp2.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g25 + g38)), radius: g38, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path2_sp3 = CGMutablePath()
		path2_sp3.move(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g28)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g29)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g29)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g30)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g30)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g31)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g31)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g30)))
		path2_sp3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g28)))
		path2_sp3.closeSubpath()

		let path3_sp1 = CGMutablePath()
		path3_sp1.move(to: CGPoint(x: CGFloat(x + g39 + 2 * g38), y: CGFloat(y + g25 + g38)))
		path3_sp1.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g25 + g38)), radius: g38, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path3_sp2 = CGMutablePath()
		path3_sp2.move(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g28)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g29)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g29)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g30)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g30)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g31)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g31)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g30)))
		path3_sp2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g28)))
		path3_sp2.closeSubpath()

		let path4_sp1 = CGMutablePath()
		path4_sp1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4_sp1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4_sp1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4_sp1.closeSubpath()

		let path4_sp2 = CGMutablePath()
		path4_sp2.move(to: CGPoint(x: CGFloat(x + g11 + 2 * v1), y: CGFloat(y + midY)))
		path4_sp2.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + midY)), radius: v1, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path4_sp3 = CGMutablePath()
		path4_sp3.move(to: CGPoint(x: CGFloat(x + g39 + 2 * g38), y: CGFloat(y + g25 + g38)))
		path4_sp3.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g25 + g38)), radius: g38, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path4_sp4 = CGMutablePath()
		path4_sp4.move(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g28)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g29)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g29)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g30)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g30)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g31)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g31)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g30)))
		path4_sp4.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g28)))
		path4_sp4.closeSubpath()

		let path5 = CGMutablePath()
		path5.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path5.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path5.closeSubpath()

		let pathArray = [path1_sp1, path1_sp2, path2_sp1, path2_sp2, path2_sp3, path3_sp1, path3_sp2, path4_sp1, path4_sp2, path4_sp3, path4_sp4, path5]
		let pathProps = [1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 4, 5]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, pathProps: pathProps, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func actionReturn(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx2: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - dx2
		let g10: CGFloat = midY + dx2
		let g11: CGFloat = midX - dx2
		let g12: CGFloat = midX + dx2
		let g13: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g14: CGFloat = g13 * (7.0 / 8.0)
		let g15: CGFloat = g13 * (3.0 / 4.0)
		let g16: CGFloat = g13 * (5.0 / 8.0)
		let g17: CGFloat = g13 * (3.0 / 8.0)
		let g18: CGFloat = g13 * (1.0 / 4.0)
		let g19: CGFloat = g9 + g15
		let g20: CGFloat = g9 + g16
		let g21: CGFloat = g9 + g18
		let g22: CGFloat = g11 + g14
		let g23: CGFloat = g11 + g15
		let g24: CGFloat = g11 + g16
		let g25: CGFloat = g11 + g17
		let g26: CGFloat = g11 + g18
		let g27: CGFloat = g13 * (1.0 / 8.0)

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g9)))
		path1.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g20)))
		path1.addArc(center: CGPoint(x: CGFloat(x + g24 - g27), y: CGFloat(y + g20)), radius: g27, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19)))
		path1.addArc(center: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19 - g27)), radius: g27, startAngle: CGFloat.pi / 2, endAngle: .pi, clockwise: false)
		path1.addLine(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g20)))
		path1.addArc(center: CGPoint(x: CGFloat(x + g11 + g17), y: CGFloat(y + g20)), radius: g17, startAngle: .pi, endAngle: CGFloat.pi / 2, clockwise: true)
		path1.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10)))
		path1.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10 - g17)), radius: g17, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
		path1.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g21)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g9)))
		path2.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g20)))
		path2.addArc(center: CGPoint(x: CGFloat(x + g24 - g27), y: CGFloat(y + g20)), radius: g27, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
		path2.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19)))
		path2.addArc(center: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19 - g27)), radius: g27, startAngle: CGFloat.pi / 2, endAngle: .pi, clockwise: false)
		path2.addLine(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g20)))
		path2.addArc(center: CGPoint(x: CGFloat(x + g11 + g17), y: CGFloat(y + g20)), radius: g17, startAngle: .pi, endAngle: CGFloat.pi / 2, clockwise: true)
		path2.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10)))
		path2.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10 - g17)), radius: g17, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
		path2.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g21)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path3.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g23), y: CGFloat(y + g9)))
		path3.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g20)))
		path3.addArc(center: CGPoint(x: CGFloat(x + g24 - g27), y: CGFloat(y + g20)), radius: g27, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19)))
		path3.addArc(center: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g19 - g27)), radius: g27, startAngle: CGFloat.pi / 2, endAngle: .pi, clockwise: false)
		path3.addLine(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g20)))
		path3.addArc(center: CGPoint(x: CGFloat(x + g11 + g17), y: CGFloat(y + g20)), radius: g17, startAngle: .pi, endAngle: CGFloat.pi / 2, clockwise: true)
		path3.addLine(to: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10)))
		path3.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g10 - g17)), radius: g17, startAngle: CGFloat.pi / 2, endAngle: 0, clockwise: true)
		path3.addLine(to: CGPoint(x: CGFloat(x + g22), y: CGFloat(y + g21)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:disable function_body_length
	func actionMovie(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx2: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - dx2
		let g11: CGFloat = midX - dx2
		let g12: CGFloat = midX + dx2
		let g13: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g14: CGFloat = g13 * (1_455.0 / 21_600.0)
		let g15: CGFloat = g13 * (1_905.0 / 21_600.0)
		let g16: CGFloat = g13 * (2_325.0 / 21_600.0)
		let g17: CGFloat = g13 * (16_155.0 / 21_600.0)
		let g18: CGFloat = g13 * (17_010.0 / 21_600.0)
		let g19: CGFloat = g13 * (19_335.0 / 21_600.0)
		let g20: CGFloat = g13 * (19_725.0 / 21_600.0)
		let g21: CGFloat = g13 * (20_595.0 / 21_600.0)
		let g22: CGFloat = g13 * (5_280.0 / 21_600.0)
		let g23: CGFloat = g13 * (5_730.0 / 21_600.0)
		let g24: CGFloat = g13 * (6_630.0 / 21_600.0)
		let g25: CGFloat = g13 * (7_492.0 / 21_600.0)
		let g26: CGFloat = g13 * (9_067.0 / 21_600.0)
		let g27: CGFloat = g13 * (9_555.0 / 21_600.0)
		let g28: CGFloat = g13 * (13_342.0 / 21_600.0)
		let g29: CGFloat = g13 * (14_580.0 / 21_600.0)
		let g30: CGFloat = g13 * (15_592.0 / 21_600.0)
		let g31: CGFloat = g11 + g14
		let g32: CGFloat = g11 + g15
		let g33: CGFloat = g11 + g16
		let g34: CGFloat = g11 + g17
		let g35: CGFloat = g11 + g18
		let g36: CGFloat = g11 + g19
		let g37: CGFloat = g11 + g20
		let g38: CGFloat = g11 + g21
		let g39: CGFloat = g9 + g22
		let g40: CGFloat = g9 + g23
		let g41: CGFloat = g9 + g24
		let g42: CGFloat = g9 + g25
		let g43: CGFloat = g9 + g26
		let g44: CGFloat = g9 + g27
		let g45: CGFloat = g9 + g28
		let g46: CGFloat = g9 + g29
		let g47: CGFloat = g9 + g30

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g39)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g44)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g44)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g43)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g43)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g47)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g47)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g45)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g45)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g46)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g46)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g41)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g41)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g42)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g42)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g41)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g40)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g40)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g39)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g39)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g44)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g44)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g43)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g43)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g47)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g47)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g45)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g45)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g46)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g46)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g41)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g41)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g42)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g42)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g41)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g40)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g40)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g39)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path3.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path3.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g39)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g44)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g44)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g43)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g43)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g47)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g47)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g45)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g45)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g46)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g46)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g41)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g38), y: CGFloat(y + g41)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g42)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g42)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g35), y: CGFloat(y + g41)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g34), y: CGFloat(y + g40)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g32), y: CGFloat(y + g40)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g31), y: CGFloat(y + g39)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionDocument(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx2: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - dx2
		let g10: CGFloat = midY + dx2
		let dx1: CGFloat = getCoordinates(9.0 / 32.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g11: CGFloat = midX - dx1
		let g12: CGFloat = midX + dx1
		let g13: CGFloat = getCoordinates(3.0 / 16.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g14: CGFloat = g12 - g13
		let g15: CGFloat = g9 + g13

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g9)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g10)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g10)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g9)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g10)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g10)))
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g15)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g15)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		path3.closeSubpath()

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g9)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g10)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g10)))
		path4.closeSubpath()

		path4.move(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g9)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g14), y: CGFloat(y + g15)))
		path4.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g15)))
		//        path4.closeSubpath()

		let path5 = CGMutablePath()
		path5.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path5.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path5.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path5.closeSubpath()

		let pathArray = [path1, path2, path3, path4, path5]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionSound(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx2: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - dx2
		let g10: CGFloat = midY + dx2
		let g11: CGFloat = midX - dx2
		let g12: CGFloat = midX + dx2
		let g13: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g14: CGFloat = g13 * (1.0 / 8.0)
		let g15: CGFloat = g13 * (5.0 / 16.0)
		let g16: CGFloat = g13 * (5.0 / 8.0)
		let g17: CGFloat = g13 * (11.0 / 16.0)
		let g18: CGFloat = g13 * (3.0 / 4.0)
		let g19: CGFloat = g13 * (7.0 / 8.0)
		let g20: CGFloat = g9 + g14
		let g21: CGFloat = g9 + g15
		let g22: CGFloat = g9 + g17
		let g23: CGFloat = g9 + g19
		let g24: CGFloat = g11 + g15
		let g25: CGFloat = g11 + g16
		let g26: CGFloat = g11 + g18

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g22)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g22)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g9)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		path1.closeSubpath()

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g22)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g22)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g9)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		path2.closeSubpath()

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g22)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g22)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g9)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		//        path3.move(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g21)))
		//        path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g21)))
		//        path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g9)))
		//        path3.addLine(to: CGPoint(x: CGFloat(x + g25), y: CGFloat(y + g10)))
		//        path3.addLine(to: CGPoint(x: CGFloat(x + g24), y: CGFloat(y + g22)))
		//        path3.addLine(to: CGPoint(x: CGFloat(x + g11), y: CGFloat(y + g22)))
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + g21)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g20)))
		path3.move(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + midY)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + midY)))
		path3.move(to: CGPoint(x: CGFloat(x + g26), y: CGFloat(y + g22)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g12), y: CGFloat(y + g23)))

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	func actionHelp(frame: CGRect) -> PresetPathInfo {
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height
		let midX: CGFloat = w * 0.5
		let midY: CGFloat = h * 0.5
		let dx2: CGFloat = getCoordinates(3.0 / 8.0, Width: w, Height: h, Percent: 0.5, Type: "z")
		let g9: CGFloat = midY - dx2
		let g11: CGFloat = midX - dx2
		let g13: CGFloat = getCoordinates(3.0 / 4.0, Width: w, Height: h, Percent: 1.0, Type: "z")
		let g14: CGFloat = g13 * (1.0 / 7.0)
		let g15: CGFloat = g13 * (3.0 / 14.0)
		let g16: CGFloat = g13 * (2.0 / 7.0)
		let g19: CGFloat = g13 * (3.0 / 7.0)
		let g20: CGFloat = g13 * (4.0 / 7.0)
		let g21: CGFloat = g13 * (17.0 / 28.0)
		let g23: CGFloat = g13 * (21.0 / 28.0)
		let g24: CGFloat = g13 * (11.0 / 14.0)
		let g27: CGFloat = g9 + g16
		let g29: CGFloat = g9 + g21
		let g30: CGFloat = g9 + g23
		let g31: CGFloat = g9 + g24
		let g33: CGFloat = g11 + g15
		let g36: CGFloat = g11 + g19
		let g37: CGFloat = g11 + g20
		let g41: CGFloat = g13 * (1.0 / 14.0)
		let g42: CGFloat = g13 * (3.0 / 28.0)
		let g43: CGFloat = g42 + g31

		let e1 = self.computeEllipticCoords(radiusX: g16, radiusY: g16, start: CGPoint(g33, g27), startAngle: .pi, sweepAngle: .pi)
		let e2 = self.computeEllipticCoords(radiusX: g14, radiusY: g15, start: e1, startAngle: 0, sweepAngle: .pi / 2)
		let e3 = self.computeEllipticCoords(radiusX: g41, radiusY: g42, start: e2, startAngle: 3 * .pi / 2, sweepAngle: (CGFloat.pi / 2) * 3)
		let e4 = self.computeEllipticCoords(radiusX: g14, radiusY: g15, start: CGPoint(g36, g29), startAngle: .pi, sweepAngle: .pi / 2)
		let e5 = self.computeEllipticCoords(radiusX: g41, radiusY: g42, start: e4, startAngle: .pi / 2, sweepAngle: 3 * .pi / 2)
		let e6 = self.computeEllipticCoords(radiusX: g14, radiusY: g14, start: e5, startAngle: 0, sweepAngle: .pi)

		var startAngle: CGFloat = 0.0
		var endAngle: CGFloat = 0.0
		var framePoint1 = CGPoint.zero
		var framePoint2 = CGPoint.zero

		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path1.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path1.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path1.closeSubpath()
		path1.move(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g27)))
		path1.addArc(center: CGPoint(x: CGFloat(x + (g33 + e1.x) / 2), y: CGFloat(y + (g27 + g27) / 2)), radius: (e1.x - g33) / 2, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)

		startAngle = 0
		endAngle = CGFloat.pi / 2
		framePoint1.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(endAngle)))

		var controlPoint: [CGPoint] = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e1.x - e2.x + g14) / 2, ry: (e2.y - e1.y + g15) / 2)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = CGFloat.pi
		endAngle = (CGFloat.pi / 2) * 3
		framePoint1.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e2.x + g41 - e3.x) / 2, ry: (e3.y - e2.y + g42) / 2)

		path1.addCurve(to: CGPoint(CGFloat(x + g37), CGFloat(y + g29)), control1: controlPoint[1], control2: controlPoint[0])
		path1.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g30)))
		path1.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g29)))

		startAngle = .pi
		endAngle = 3 * (.pi / 2)
		framePoint1.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + g29 + g15 * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + g29 + g15 * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: g14, ry: g15)
		path1.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = 0
		endAngle = CGFloat.pi / 2
		framePoint1.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e5.x + g41 - e4.x) / 2, ry: (e4.y - e5.y + g42) / 2)

		path1.addCurve(to: CGPoint(CGFloat(x + (e6.x + e5.x) / 2) + (e5.x - e6.x) / 2, CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), control1: controlPoint[1], control2: controlPoint[0])
		path1.addArc(center: CGPoint(x: CGFloat(x + (e6.x + e5.x) / 2), y: CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), radius: (e5.x - e6.x) / 2, startAngle: 0, endAngle: .pi, clockwise: true)
		path1.closeSubpath()

		path1.move(to: CGPoint(x: CGFloat(x + midX + g42), y: CGFloat(y + g43)))
		path1.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g43)), radius: g42, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path2 = CGMutablePath()
		path2.move(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g27)))
		path2.addArc(center: CGPoint(x: CGFloat(x + (g33 + e1.x) / 2), y: CGFloat(y + (g27 + g27) / 2)), radius: (e1.x - g33) / 2, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)

		startAngle = 0
		endAngle = CGFloat.pi / 2
		framePoint1.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e1.x - e2.x + g14) / 2, ry: (e2.y - e1.y + g15) / 2)
		path2.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = CGFloat.pi
		endAngle = (CGFloat.pi / 2) * 3
		framePoint1.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e2.x + g41 - e3.x) / 2, ry: (e3.y - e2.y + g42) / 2)
		path2.addCurve(to: CGPoint(CGFloat(x + g37), CGFloat(y + g29)), control1: controlPoint[1], control2: controlPoint[0])
		path2.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g30)))
		path2.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g29)))

		startAngle = .pi
		endAngle = 3 * (.pi / 2)
		framePoint1.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + g29 + g15 * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + g29 + g15 * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: g14, ry: g15)
		path2.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = 0
		endAngle = CGFloat.pi / 2
		framePoint1.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e5.x + g41 - e4.x) / 2, ry: (e4.y - e5.y + g42) / 2)

		path2.addCurve(to: CGPoint(CGFloat(x + (e6.x + e5.x) / 2) + (e5.x - e6.x) / 2, CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), control1: controlPoint[1], control2: controlPoint[0])
		path2.addArc(center: CGPoint(x: CGFloat(x + (e6.x + e5.x) / 2), y: CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), radius: (e5.x - e6.x) / 2, startAngle: 0, endAngle: .pi, clockwise: true)
		path2.closeSubpath()

		path2.move(to: CGPoint(x: CGFloat(x + midX + g42), y: CGFloat(y + g43)))
		path2.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g43)), radius: g42, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path3 = CGMutablePath()
		path3.move(to: CGPoint(x: CGFloat(x + g33), y: CGFloat(y + g27)))
		path3.addArc(center: CGPoint(x: CGFloat(x + (g33 + e1.x) / 2), y: CGFloat(y + (g27 + g27) / 2)), radius: (e1.x - g33) / 2, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)

		startAngle = 0
		endAngle = .pi / 2
		framePoint1.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x - g14 + e1.x) / 2 + ((e1.x - e2.x + g14) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e1.y - g15 + e2.y) / 2) + ((e2.y - e1.y + g15) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e1.x - e2.x + g14) / 2, ry: (e2.y - e1.y + g15) / 2)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = .pi
		endAngle = 3 * (.pi / 2)
		framePoint1.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e2.x + g41 + e3.x) / 2 + ((e2.x + g41 - e3.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e3.y + g42 + e2.y) / 2) + ((e3.y - e2.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e2.x + g41 - e3.x) / 2, ry: (e3.y - e2.y + g42) / 2)

		path3.addCurve(to: CGPoint(CGFloat(x + g37), CGFloat(y + g29)), control1: controlPoint[1], control2: controlPoint[0])
		path3.addLine(to: CGPoint(x: CGFloat(x + g37), y: CGFloat(y + g30)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g30)))
		path3.addLine(to: CGPoint(x: CGFloat(x + g36), y: CGFloat(y + g29)))

		startAngle = .pi
		endAngle = 3 * (.pi / 2)
		framePoint1.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + g29 + g15 * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + g36 + g14 + g14 * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + g29 + g15 * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: g14, ry: g15)
		path3.addCurve(to: framePoint2, control1: controlPoint[0], control2: controlPoint[1])

		startAngle = 0
		endAngle = .pi / 2
		framePoint1.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(startAngle)))
		framePoint1.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(startAngle)))
		framePoint2.x = x + (e4.x - g41 + e5.x) / 2 + ((e5.x + g41 - e4.x) / 2) * CGFloat(cosf(Float(endAngle)))
		framePoint2.y = y + ((e5.y - g42 + e4.y) / 2) + ((e4.y - e5.y + g42) / 2) * CGFloat(sinf(Float(endAngle)))
		controlPoint = self.getControlPointsForEllipse(framePoint1: framePoint1, framePoint2: framePoint2, startAngle: startAngle, endAngle: endAngle, rx: (e5.x + g41 - e4.x) / 2, ry: (e4.y - e5.y + g42) / 2)

		path3.addCurve(to: CGPoint(CGFloat(x + (e6.x + e5.x) / 2) + (e5.x - e6.x) / 2, CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), control1: controlPoint[1], control2: controlPoint[0])
		path3.addArc(center: CGPoint(x: CGFloat(x + (e6.x + e5.x) / 2), y: CGFloat(y + (e5.y - g14 + e5.y + g14) / 2)), radius: (e5.x - e6.x) / 2, startAngle: 0, endAngle: .pi, clockwise: true)
		path3.closeSubpath()

		path3.move(to: CGPoint(x: CGFloat(x + midX + g42), y: CGFloat(y + g43)))
		path3.addArc(center: CGPoint(x: CGFloat(x + midX), y: CGFloat(y + g43)), radius: g42, startAngle: 0, endAngle: 2 * .pi, clockwise: false)

		let path4 = CGMutablePath()
		path4.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y)))
		path4.addLine(to: CGPoint(x: CGFloat(x + w), y: CGFloat(y + h)))
		path4.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(y + h)))
		path4.closeSubpath()

		let pathArray = [path1, path2, path3, path4]
		let textFrame = CGRect(x: x, y: y, width: w, height: h)
		let animationFrame = frame
		let connector = self.getConnector(frame: frame, type: .rect)
		return PresetPathInfo(paths: pathArray, textFrame: textFrame, pathFrame: frame, animationFrame: animationFrame, connectors: connector)
	}

	// swiftlint:enable function_body_length
	func actionCustom(frame: CGRect) -> PresetPathInfo {
		return self.rect(frame: frame)
	}
}

// swiftlint:enable file_length
