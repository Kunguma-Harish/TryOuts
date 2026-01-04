//
//  Preset+Media.swift
//  Painter
//
//  Created by Madhumitha  B on 28/11/23.
//  Copyright © 2024 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension Preset {
	func audio(frame: CGRect) -> PresetPathInfo {
		let modifiers = presetModifiers
		let x = frame.origin.x, y = frame.origin.y, w = frame.size.width, h = frame.size.height

		let midx = w * 0.5
		let midy = h * 0.5
		let rx = w * 0.5
//		let ry = h * 0.5

		let radius = rx
		let diameter = w

		let textFrame = CGRect(x: x, y: y, width: w, height: h)

		// start end angle caluclation based on modifier
		let angle1 = CGFloat(degreesToRadians(angle: 0))
		let angle2 = CGFloat(Float(modifiers[1]) * (Float.pi / 180))
//		let isLarge = self.isLargeArc(angle1: angle1, angle2: angle2)
		let a = getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: midx, ry: midy, mid: CGPoint(x: midx, y: midy))
		let anticlockwise = CGFloat(degreesToRadians(angle: 270))

		let newStartX = midx + ((a[0] - midx) * cos(anticlockwise)) - (a[1] - midy) * sin(anticlockwise)
		let newStartY = midy + (a[0] - midx) * sin(anticlockwise) + (a[1] - midy) * cos(anticlockwise)
		let newEndX = midx + (a[2] - midx) * cos(anticlockwise) - (a[3] - midy) * sin(anticlockwise)
		let newEndY = midy + (a[2] - midx) * sin(anticlockwise) + (a[3] - midy) * cos(anticlockwise)

		// POINTS FOR PLAY ICON USED IN DEFAULT/PAUSE MODE
		let smallCirlceRadii = (34 * diameter) / 100
		let firstPoint = [midx + smallCirlceRadii / 2.1, midy]
		let secondPoint = [firstPoint[0] - (0.24 * diameter), midy - (0.14 * diameter)]
		let thirdPoint = [firstPoint[0] - (0.24 * diameter), midy + (0.14 * diameter)]

		// outer ring :: dummy :: white BG
		let path1 = CGMutablePath()
		path1.move(to: CGPoint(x, y + midy))
		path1.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
		path1.closeSubpath()

		// 1.  ALL BLUE COLOURED paths go here
		// play button, pause button
		let path2 = CGMutablePath()
		if modifiers[0] == 0 { // OUTER BLUE CIRLCE :: DEAFULT MODE
			path2.move(to: CGPoint(x, y + midy))
			path2.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
			path2.closeSubpath()
		}

		if modifiers[0] == 1 { // PLAY BUTTON IN MIDDLE :: PLAYING MODE
			// play button
			path2.move(to: CGPoint(x + firstPoint[0], y + firstPoint[1]))
			path2.addLine(to: CGPoint(x + secondPoint[0], y + secondPoint[1]))
			path2.addLine(to: CGPoint(x + thirdPoint[0], y + thirdPoint[1]))
			path2.addLine(to: CGPoint(x + firstPoint[0], y + firstPoint[1]))
			path2.closeSubpath()
		}

		if modifiers[0] == 2 { // PAUSE BUTTON IN MIDDLE :: PAUSE MODE
			// pause button
			let top = (radius * 23) / 100 // distance from top
			let left = (radius * 15) / 100 // distance to move from center
			let width = (radius * 10) / 100 // width of each rectangle
			path2.move(to: CGPoint(x + midx - left, y + midy - top))
			path2.addLines(between: [CGPoint(x + midx - left, y + midy - top), CGPoint(x + midx - left, y + midy + top), CGPoint(x + midx - left + width, y + midy + top), CGPoint(x + midx - left + width, y + midy - top)])
			path2.closeSubpath()
			path2.move(to: CGPoint(x + midx + left, y + midy - top))
			path2.addLines(between: [CGPoint(x + midx + left, y + midy - top), CGPoint(x + midx + left, y + midy + top), CGPoint(x + midx + left - width, y + midy + top), CGPoint(x + midx + left - width, y + midy - top)])
			path2.closeSubpath()
		}

		// 2. ALL GRAY COLOURED
		let path3 = CGMutablePath()
		if modifiers[0] == 0 { // NO GRAY COLOURED PATHS IN DEFAULT MODE :: SO DUMMY MOVE
			path3.move(to: CGPoint(x, y))
			path3.closeSubpath()
		}

		if modifiers[0] == 1 || modifiers[0] == 2 { // GRAY COLOURED OUTER RING :: IN PLAY/PAUSE MODE
			path3.move(to: CGPoint(x, y + midy))
			path3.addEllipse(in: CGRect(x: x, y: y, width: w, height: h))
			path3.closeSubpath()
		}

		// TEST
		// var smallCirlceRadii = (diameter * 0.34)/2;
		// this.move(midx - smallCirlceRadii , midy);
		// this.addEllipse(smallCirlceRadii ,smallCirlceRadii, midx, midy);

		// 3. ALL WHITE COLURED PATHS
		let path4 = CGMutablePath()
		if modifiers[0] == 0 { // WHITE COLOURED PLAY BUTTON :: DEFAULT MODE
			path4.move(to: CGPoint(x + firstPoint[0], y + firstPoint[1]))
			path4.addLine(to: CGPoint(x + secondPoint[0], y + secondPoint[1]))
			path4.addLine(to: CGPoint(x + thirdPoint[0], y + thirdPoint[1]))
			path4.addLine(to: CGPoint(x + firstPoint[0], y + firstPoint[1]))
			path4.closeSubpath()
		}

		if modifiers[0] == 1 || modifiers[0] == 2 { // NO WHITE COLOURED PATHS SO DUMMY MOVE
			path4.move(to: CGPoint(x, y))
			path4.closeSubpath()
		}

		// PROGRESS BAR :: BLUE COLOR RING :: IN PLAY/PAUSE MODE
		let path5 = CGMutablePath()
		if modifiers[0] == 1 || modifiers[0] == 2 {
			path5.move(to: CGPoint(x + newStartX, y + newStartY))
			self.addEllipseCurve(x1: newStartX, y1: newStartY, x2: newEndX, y2: newEndY, rx: midy, ry: midy, path: path5, frame: frame)
		} else {
			path5.move(to: CGPoint(x, y))
			path5.closeSubpath()
		}

		// SEEK  BUBBLE :: SHOWN IN PLAY/PAUSE MODE
		let path6 = CGMutablePath()
		if modifiers[0] == 1 || modifiers[0] == 2 {
			// seek bubbble
			let smallCircleRadius = (10 * radius) / 100
			let smMidX = newEndX
			let smMidY = newEndY
			path6.move(to: CGPoint(x + smMidX - smallCircleRadius, y + smMidY))
			path6.addEllipse(in: CGRect(x: x + smMidX - (smallCircleRadius / 2), y: y + smMidY, width: smallCircleRadius, height: smallCircleRadius))
			path6.closeSubpath()
		} else {
			path6.move(to: CGPoint(x, y))
			path6.closeSubpath()
		}

		// ROUNDED RECT TIMER :: GRAY COLOR :: IN PLAY/PAUSE MODE
		let path7 = CGMutablePath()
		if modifiers[0] == 1 || modifiers[0] == 2 {
			let heightOfTimerBox = (0.2 * diameter)
			let widthOfTimerBox = radius
			let timerMidX = midx
			let timerMidY = midy + (radius / 1.7)
			let left = timerMidX - (widthOfTimerBox / 2)
			let top = timerMidY - (heightOfTimerBox / 2)
			// A,B,C,D ARE FOUR CORNER POINTS OF RECT
			let A = [left, top]
			let B = [left + widthOfTimerBox, top]
			let C = [left + widthOfTimerBox, top + heightOfTimerBox]
			let D = [left, top + heightOfTimerBox]
			let RightSide = [left + widthOfTimerBox, top + (heightOfTimerBox / 2)]
			let LeftSide = [left, top + (heightOfTimerBox / 2)]
			let f1 = self.getCoordinates(0.15, Width: B[0], Height: B[1], Percent: 1, Type: "x") // check

			path7.move(to: CGPoint(x + A[0] + f1, y + A[1]))
			path7.addLine(to: CGPoint(x + B[0] - f1, y + A[1]))
			path7.addArc(center: CGPoint(x + B[0] - f1, y + RightSide[1]), radius: RightSide[1] - A[1], startAngle: 3.0 * .pi / 2, endAngle: 0, clockwise: false)
			path7.addArc(center: CGPoint(x + C[0] - f1, y + RightSide[1]), radius: C[1] - RightSide[1], startAngle: 0, endAngle: .pi / 2, clockwise: false)
			path7.addLine(to: CGPoint(x + D[0] + f1, y + D[1]))
			path7.addArc(center: CGPoint(x + D[0] + f1, y + LeftSide[1]), radius: D[1] - LeftSide[1], startAngle: .pi / 2, endAngle: .pi, clockwise: false)
			path7.addArc(center: CGPoint(x + A[0] + f1, y + LeftSide[1]), radius: LeftSide[1] - A[1], startAngle: .pi, endAngle: 3 * .pi / 2, clockwise: false)
			path7.closeSubpath()

//			let textFrame = CGRect(x: x, y: top, width: w, height: top + heightOfTimerBox)
		} else {
			path7.move(to: CGPoint(x, y))
			path7.closeSubpath()
		}

		let path = [path1, path2, path3, path4, path5, path6, path7]
		let pathProps = [1, 2, 3, 4, 5, 6, 7] //
		let connector = self.getConnector(frame: frame, type: .rect)

		return PresetPathInfo(paths: path, textFrame: textFrame, pathFrame: frame, animationFrame: frame, pathProps: pathProps, connectors: connector)
	}

	func isLargeArc(angle1: CGFloat, angle2: CGFloat) -> Bool {
		var largearc = true
		let diffAngle = abs(angle2 - angle1)
		if angle1 < angle2 {
			if diffAngle < .pi { // 180 degree
				largearc = false
			}
		} else {
			if diffAngle > .pi { // 180 degree
				largearc = false
			}
		}
		return largearc
	}
}
