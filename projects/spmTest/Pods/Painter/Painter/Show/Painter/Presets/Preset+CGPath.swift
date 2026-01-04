//
//  Preset+CGPath.swift
//  Painter
//
//  Created by Sarath Kumar G on 18/04/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// swiftlint:disable file_length
struct PresetPathInfo {
	var paths = [CGPath]()
	var handles: [CGPoint]?
	var textFrame = CGRect.zero
	var pathFrame = CGRect.zero
	var animationFrame = CGRect.zero
	var pathProps = [Int]()
	var connectors: [[CGFloat]]

	init(paths: [CGPath], handles: [CGPoint]? = nil, textFrame: CGRect, pathFrame: CGRect, animationFrame: CGRect, pathProps: [Int] = [], connectors: [[CGFloat]] = []) {
		self.paths = paths
		self.handles = handles
		self.textFrame = textFrame
		self.pathFrame = pathFrame
		self.animationFrame = animationFrame
		self.pathProps = pathProps
		self.connectors = connectors
	}
}

public extension Preset {
	func handles(frame: CGRect, stroke: Stroke) -> [CGPoint]? {
		let presetInfo = self.pathInfo(frame: frame, stroke: stroke)
		return presetInfo.handles
	}

	func textFrame(frame: CGRect) -> CGRect {
		let presetInfo = self.pathInfo(frame: frame)
		return presetInfo.textFrame
	}
}

extension Preset {
	var presetModifiers: [CGFloat] {
		return (modifiers.isEmpty ? type.presetDefaults.modifiers : modifiers).compactMap { CGFloat($0) }
	}

	var pathList: [PresetShape.PathList] {
		return type.presetDefaults.pathList
	}

	var handleValues: [PresetShape.HandleValue] {
		return type.presetDefaults.handles
	}

	func connectorPoints(frame: CGRect, stroke: Stroke) -> [[CGFloat]] {
		let presetInfo = self.pathInfo(frame: frame, stroke: stroke)
		return presetInfo.connectors
	}

	func getCoordinates(_ val: CGFloat, Width maxX: CGFloat, Height maxY: CGFloat, Percent maxPercent: CGFloat, Type maxType: Character) -> CGFloat {
		let ss = min(maxX, maxY)
		var f0 = val * ss
		var maxVal = ss * maxPercent

		if maxType == "x" {
			maxVal = maxX * maxPercent
		} else if maxType == "y" {
			maxVal = maxY * maxPercent
		}

		f0 = min(f0, maxVal)
		return f0
	}

	func computeArrowValuesModifiers(ww: CGFloat, hh: CGFloat, m: [CGFloat]) -> [CGFloat] {
		let f0 = self.getCoordinates(m[1], Width: ww, Height: hh, Percent: 0.5, Type: "z")
		let f1 = self.getCoordinates(m[0], Width: ww, Height: hh, Percent: m[1] * 2, Type: "z")
		let f2 = self.getCoordinates(m[2], Width: ww, Height: hh, Percent: 0.5 - m[1], Type: "z")

		return [f0, f1 * 0.5, f2]
	}

	func toCubicControlPoints(p1: CGPoint, cx1: CGFloat, cy1: CGFloat, p2: CGPoint) -> [CGFloat] {
		let val1: CGFloat = 2.0 / 3.0
		let val2: CGFloat = 1.0 / 3.0

		let ccx1 = val1 * cx1 + val2 * p1.x
		let ccy1 = val1 * cy1 + val2 * p1.y

		let ccx2 = val1 * cx1 + val2 * p2.x
		let ccy2 = val1 * cy1 + val2 * p2.y
		return [ccx1, ccy1, ccx2, ccy2]
	}

	func getControlPointsForEllipse(
		framePoint1: CGPoint,
		framePoint2: CGPoint,
		startAngle: CGFloat,
		endAngle: CGFloat,
		rx: CGFloat,
		ry: CGFloat,
		multiplier: CGFloat = 1) -> [CGPoint] {
		let alphaValue = (sin(endAngle - startAngle) * (sqrt(4 + 3 * tan((endAngle - startAngle) / 2)) - 1)) * multiplier / 3
		let tangent1 = CGPoint(-rx * sin(startAngle), ry * cos(startAngle))
		let tangent2 = CGPoint(-rx * sin(endAngle), ry * cos(endAngle))
		let controlPoint1 = CGPoint(framePoint1.x + alphaValue * tangent1.x, framePoint1.y + alphaValue * tangent1.y)
		let controlPoint2 = CGPoint(framePoint2.x - alphaValue * tangent2.x, framePoint2.y - alphaValue * tangent2.y)
		return [controlPoint1, controlPoint2]
	}

	func getEllipseCoordinates(angle1: CGFloat, angle2: CGFloat, rx: CGFloat, ry: CGFloat, mid: CGPoint) -> [CGFloat] {
		let midX = mid.x == -1 ? rx : mid.x
		let midY = mid.y == -1 ? ry : mid.y
		let base1 = rx * cos(angle1)
		let height1 = ry * sin(angle1)
		let x1 = midX + base1
		let y1 = midY + height1

		if angle2 == -1_000 {
			return [x1, y1]
		}
		let base2 = rx * cos(angle2)
		let height2 = ry * sin(angle2)
		let x2 = midX + base2
		let y2 = midY + height2
		return [x1, y1, x2, y2]
	}

	func cgpath(frame: CGRect? = nil, stroke: Stroke? = nil) -> CGPath {
		let presetInfo = self.pathInfo(frame: frame, stroke: stroke)
		let combinedPath = CGMutablePath()
		for path in presetInfo.paths {
			combinedPath.addPath(path)
		}
		if let cgPath = combinedPath.copy() {
			return cgPath
		} else if !presetInfo.paths.isEmpty {
			return presetInfo.paths[0]
		}
		return CGPath(rect: frame ?? .zero, transform: nil)
	}

	func pathInfo(frame: CGRect? = nil, stroke: Stroke? = nil) -> PresetPathInfo {
		let initialPathFrame = CGRect(origin: .zero, size: CGSize(width: 120, height: 120))
		return self.path(shapeFrame: frame ?? initialPathFrame, stroke: stroke)
	}

	// swiftlint:disable function_body_length cyclomatic_complexity
	func path(shapeFrame: CGRect, stroke: Stroke? = nil) -> PresetPathInfo {
		guard hasType else {
			// If it doesn't have any type, return a rect path
			return rect(frame: shapeFrame)
		}

		switch type {
            // MARK: Basic Shapes

		case .rect:
			return rect(frame: shapeFrame)

		case .roundRect:
			return roundRect(frame: shapeFrame)

		case .snipSingleRect:
			return snipSingleRect(frame: shapeFrame)

		case .snipSamesideRect:
			return snipSamesideRect(frame: shapeFrame)

		case .snipDiagonalRect:
			return snipDiagonalRect(frame: shapeFrame)

		case .snipRoundSingleRect:
			return snipRoundSingleRect(frame: shapeFrame)

		case .roundSingleRect:
			return roundSingleRect(frame: shapeFrame)

		case .roundSamesideRect:
			return roundSamesideRect(frame: shapeFrame)

		case .roundDiagonalRect:
			return roundDiagonalRect(frame: shapeFrame)

		case .oval:
			return oval(frame: shapeFrame)

		case .isoscelesTriangle:
			return isoscelesTriangle(frame: shapeFrame)

		case .rightTriangle:
			return rightTriangle(frame: shapeFrame)

		case .trapezoid:
			return trapezoid(frame: shapeFrame)

		case .pentagon:
			return pentagon(frame: shapeFrame)

		case .hexagon:
			return hexagon(frame: shapeFrame)

		case .diamond:
			return diamond(frame: shapeFrame)

		case .parallelogram:
			return parallelogram(frame: shapeFrame)

		case .heptagon:
			return heptagon(frame: shapeFrame)

		case .octagon:
			return octagon(frame: shapeFrame)

		case .decagon:
			return decagon(frame: shapeFrame)

		case .dodecagon:
			assertionFailure("Yet to implement \(type)")
			return rect(frame: shapeFrame)

		case .pie:
			return pie(frame: shapeFrame)

		case .chord:
			return chord(frame: shapeFrame)

		case .teardrop:
			return teardrop(frame: shapeFrame)

		case .frame:
			return frame(frame: shapeFrame)

		case .halfFrame:
			return halfFrame(frame: shapeFrame)

		case .lshape:
			return lshape(frame: shapeFrame)

		case .diagonalStripe:
			return diagonalStripe(frame: shapeFrame)

		case .cross:
			return cross(frame: shapeFrame)

		case .plaque:
			return plaque(frame: shapeFrame)

		case .can:
			return can(frame: shapeFrame)

		case .cube:
			return cube(frame: shapeFrame)

		case .bevel:
			return bevel(frame: shapeFrame)

		case .donut:
			return donut(frame: shapeFrame)

		case .noSymbol:
			return noSymbol(frame: shapeFrame)

		case .blockArc:
			return blockArc(frame: shapeFrame)

		case .foldedCorner:
			return foldedCorner(frame: shapeFrame)

		case .smiley:
			return smiley(frame: shapeFrame)

		case .heart:
			return heart(frame: shapeFrame)

		case .lightningBolt:
			return lightningBolt(frame: shapeFrame)

		case .sun:
			return sun(frame: shapeFrame)

		case .moon:
			return moon(frame: shapeFrame)

		case .cloud:
			return cloud(frame: shapeFrame)

		case .arc:
			return arc(frame: shapeFrame)

		case .doubleBracket:
			return doubleBracket(frame: shapeFrame)

		case .doubleBrace:
			return doubleBrace(frame: shapeFrame)

		case .leftBracket:
			return leftBracket(frame: shapeFrame)

		case .rightBracket:
			return rightBracket(frame: shapeFrame)

		case .leftBrace:
			return leftBrace(frame: shapeFrame)

		case .rightBrace:
			return rightBrace(frame: shapeFrame)

		case .clock:
			return clock(frame: shapeFrame)

            // MARK: Block Arrows

		case .rightArrow:
			return rightArrow(frame: shapeFrame)

		case .leftArrow:
			return leftArrow(frame: shapeFrame)

		case .upArrow:
			return upArrow(frame: shapeFrame)

		case .downArrow:
			return downArrow(frame: shapeFrame)

		case .leftRightArrow:
			return leftRightArrow(frame: shapeFrame)

		case .upDownArrow:
			return upDownArrow(frame: shapeFrame)

		case .quadArrow:
			return quadArrow(frame: shapeFrame)

		case .leftRightUpArrow:
			return leftRightUpArrow(frame: shapeFrame)

		case .bentArrow:
			return bentArrow(frame: shapeFrame)

		case .uTurnArrow:
			return uTurnArrow(frame: shapeFrame)

		case .leftUpArrow:
			return leftUpArrow(frame: shapeFrame)

		case .bentUpArrow:
			return bentUpArrow(frame: shapeFrame)

		case .curvedRightArrow:
			return curvedRightArrow(frame: shapeFrame)

		case .curvedLeftArrow:
			return curvedLeftArrow(frame: shapeFrame)

		case .curvedUpArrow:
			return curvedUpArrow(frame: shapeFrame)

		case .curvedDownArrow:
			return curvedDownArrow(frame: shapeFrame)

		case .stripedRightArrow:
			return stripedRightArrow(frame: shapeFrame)

		case .notchedRightArrow:
			return notchedRightArrow(frame: shapeFrame)

		case .pentagonArrow:
			return pentagonArrow(frame: shapeFrame)

		case .chevron:
			return chevron(frame: shapeFrame)

		case .rightArrowCallout:
			return rightArrowCallout(frame: shapeFrame)

		case .downArrowCallout:
			return downArrowCallout(frame: shapeFrame)

		case .leftArrowCallout:
			return leftArrowCallout(frame: shapeFrame)

		case .upArrowCallout:
			return upArrowCallout(frame: shapeFrame)

		case .leftRightArrowCallout:
			return leftRightArrowCallout(frame: shapeFrame)

		case .quadArrowCallout:
			return quadArrowCallout(frame: shapeFrame)

		case .circularArrow:
			return circularArrow(frame: shapeFrame)

            // MARK: Flow Chart Shapes

		case .plus:
			return plus(frame: shapeFrame)

		case .minus:
			return minus(frame: shapeFrame)

		case .multiply:
			return multiply(frame: shapeFrame)

		case .divide:
			return divide(frame: shapeFrame)

		case .equal:
			return equal(frame: shapeFrame)

		case .notEqual:
			return notEqual(frame: shapeFrame)

		case .process:
			return process(frame: shapeFrame)

		case .alternateProcess:
			return alternateProcess(frame: shapeFrame)

		case .decision:
			return decision(frame: shapeFrame)

		case .data:
			return data(frame: shapeFrame)

		case .predefinedProcess:
			return predefinedProcess(frame: shapeFrame)

		case .internalStorage:
			return internalStorage(frame: shapeFrame)

		case .flowchartDocument:
			return flowchartDocument(frame: shapeFrame)

		case .multiDocument:
			return multiDocument(frame: shapeFrame)

		case .terminator:
			return terminator(frame: shapeFrame)

		case .preparation:
			return preparation(frame: shapeFrame)

		case .manualInput:
			return manualInput(frame: shapeFrame)

		case .manualOperation:
			return manualOperation(frame: shapeFrame)

		case .flowchartConnector:
			return presetConnector(frame: shapeFrame)

		case .offpageConnector:
			return presetOffpageConnector(frame: shapeFrame)

		case .punchedCard:
			return punchedCard(frame: shapeFrame)

		case .punchedTape:
			return punchedTape(frame: shapeFrame)

		case .summingJunction:
			return summingJunction(frame: shapeFrame)

		case .or:
			return or(frame: shapeFrame)

		case .collate:
			return collate(frame: shapeFrame)

		case .sort:
			return sort(frame: shapeFrame)

		case .extract:
			return extract(frame: shapeFrame)

		case .merge:
			return merge(frame: shapeFrame)

		case .storedData:
			return storedData(frame: shapeFrame)

		case .delay:
			return delay(frame: shapeFrame)

		case .sequentialAccessStorage:
			return sequentialAccessStorage(frame: shapeFrame)

		case .magneticDisk:
			return magneticDisk(frame: shapeFrame)

		case .directAccessStorage:
			return directAccessStorage(frame: shapeFrame)

		case .display:
			return display(frame: shapeFrame)

            // MARK: Stars

		case .explosion1:
			return explosion1(frame: shapeFrame)

		case .explosion2:
			return explosion2(frame: shapeFrame)

		case .fourPointStar:
			return fourPointStar(frame: shapeFrame)

		case .fivePointStar:
			return fivePointStar(frame: shapeFrame)

		case .sixPointStar:
			return sixPointStar(frame: shapeFrame)

		case .sevenPointStar:
			return sevenPointStar(frame: shapeFrame)

		case .eightPointStar:
			return eightPointStar(frame: shapeFrame)

		case .tenPointStar:
			return tenPointStar(frame: shapeFrame)

		case .twelvePointStar:
			return twelvePointStar(frame: shapeFrame)

		case .sixteenPointStar:
			return sixteenPointStar(frame: shapeFrame)

		case .twentyFourPointStar:
			return twentyFourPointStar(frame: shapeFrame)

		case .thirtyTwoPointStar:
			return thirtyTwoPointStar(frame: shapeFrame)

		case .upRibbon:
			return upRibbon(frame: shapeFrame)

		case .downRibbon:
			return downRibbon(frame: shapeFrame)

		case .curvedUpRibbon:
			return curvedUpRibbon(frame: shapeFrame)

		case .curvedDownRibbon:
			return curvedDownRibbon(frame: shapeFrame)

		case .verticalScroll:
			return verticalScroll(frame: shapeFrame)

		case .horizontalScroll:
			return horizontalScroll(frame: shapeFrame)

		case .wave:
			return wave(frame: shapeFrame)

		case .doubleWave:
			return doubleWave(frame: shapeFrame)

            // MARK: Callouts

		case .rectangularCallout:
			return rectangularCallout(frame: shapeFrame)

		case .roundedRectangularCallout:
			return roundedRectangularCallout(frame: shapeFrame)

		case .ovalCallout:
			return ovalCallout(frame: shapeFrame)

		case .cloudCallout:
			return cloudCallout(frame: shapeFrame)

		case .callout1:
			return callout1(frame: shapeFrame)

		case .callout2:
			return callout2(frame: shapeFrame)

		case .callout3:
			return callout3(frame: shapeFrame)

		case .accentCallout1:
			return accentCallout1(frame: shapeFrame)

		case .accentCallout2:
			return accentCallout2(frame: shapeFrame)

		case .accentCallout3:
			return accentCallout3(frame: shapeFrame)

		case .borderCallout1:
			return borderCallout1(frame: shapeFrame)

		case .borderCallout2:
			return borderCallout2(frame: shapeFrame)

		case .borderCallout3:
			return borderCallout3(frame: shapeFrame)

		case .accentBorderCallout1:
			return accentBorderCallout1(frame: shapeFrame)

		case .accentBorderCallout2:
			return accentBorderCallout2(frame: shapeFrame)

		case .accentBorderCallout3:
			return accentBorderCallout3(frame: shapeFrame)

            // MARK: Action Buttons

		case .actionPrevious:
			return actionPrevious(frame: shapeFrame)

		case .actionNext:
			return actionNext(frame: shapeFrame)

		case .actionBegin:
			return actionBegin(frame: shapeFrame)

		case .actionEnd:
			return actionEnd(frame: shapeFrame)

		case .actionHome:
			return actionHome(frame: shapeFrame)

		case .actionInformation:
			return actionInformation(frame: shapeFrame)

		case .actionReturn:
			return actionReturn(frame: shapeFrame)

		case .actionMovie:
			return actionMovie(frame: shapeFrame)

		case .actionDocument:
			return actionDocument(frame: shapeFrame)

		case .actionSound:
			return actionSound(frame: shapeFrame)

		case .actionHelp:
			return actionHelp(frame: shapeFrame)

		case .actionCustom:
			return actionCustom(frame: shapeFrame)

            // MARK: Connectors

		case .line:
			return line(frame: shapeFrame, stroke: stroke)

		case .elbowConnector2:
			return elbowConnector2(frame: shapeFrame, stroke: stroke)

		case .elbowConnector3:
			return elbowConnector3(frame: shapeFrame, stroke: stroke)

		case .elbowConnector4:
			return elbowConnector4(frame: shapeFrame, stroke: stroke)

		case .elbowConnector5:
			return elbowConnector5(frame: shapeFrame, stroke: stroke)

		case .curvedConnector2:
			return curveConnector2(frame: shapeFrame, stroke: stroke)

		case .curvedConnector3:
			return curveConnector3(frame: shapeFrame, stroke: stroke)

		case .curvedConnector4:
			return curveConnector4(frame: shapeFrame, stroke: stroke)

		case .curvedConnector5:
			return curveConnector5(frame: shapeFrame, stroke: stroke)

            // MARK: Others

		case .lockSymbol:
			assertionFailure("Yet to implement \(type)")
			return rect(frame: shapeFrame)

		case .grid:
			return grid(frame: shapeFrame)

		case .tablecell:
			assertionFailure("Yet to implement \(type)")
			return rect(frame: shapeFrame)

		case .cropFrame:
			assertionFailure("Yet to implement \(type)")
			return rect(frame: shapeFrame)

            // MARK: Text Presets

		case .twoEdgedFrame:
			return twoEdgedFrame(frame: shapeFrame)

		case .fourEdgedFrame:
			return fourEdgedFrame(frame: shapeFrame)

		case .topBanner:
			return topBanner(frame: shapeFrame)

		case .dottedSign:
			return dottedSign(frame: shapeFrame)

		case .squareOnCircleBoard:
			return squareOnCircleBoard(frame: shapeFrame)

		case .borderQuote:
			return borderQuote(frame: shapeFrame)

		case .twinComet:
			return twinComet(frame: shapeFrame)

		case .rectQuote:
			return rectQuote(frame: shapeFrame)

		case .circleQuote:
			return circleQuote(frame: shapeFrame)

		case .leftBanner:
			return rect(frame: shapeFrame)

		case .rhombusOnBowBoard:
			return rect(frame: shapeFrame)

            // MARK: Smart Elements

		case .man:
			return man(frame: shapeFrame)

		case .woman:
			return woman(frame: shapeFrame)

		case .meterNeedle:
			return meterNeedle(frame: shapeFrame)

		case .clockNeedle:
			return clockNeedle(frame: shapeFrame)

		case .timerScale:
			return timerScale(frame: shapeFrame)

		case .horizontalSlider:
			return horizontalSlider(frame: shapeFrame)

		case .verticalSlider:
			return verticalSlider(frame: shapeFrame)

		case .modRect:
			return modRect(frame: shapeFrame)

		case .modCan:
			return modCan(frame: shapeFrame)

		case .modParallelogram:
			return modParallelogram(frame: shapeFrame)

		case .modRoundRect:
			return modRoundRect(frame: shapeFrame)

		case .circleFiller:
			return circleFiller(frame: shapeFrame)

		case .ellipseFiller:
			return ellipseFiller(frame: shapeFrame)

		case .star:
			assertionFailure("Yet to implement \(type)")
			return fivePointStar(frame: shapeFrame)

		case .polygon:
			assertionFailure("Yet to implement \(type)")
			return isoscelesTriangle(frame: shapeFrame)

		case .audio:
//			return audio(frame: shapeFrame)
			return rect(frame: shapeFrame)

		case .defPresetShape:
			// not used as of now; handle appropriately in future
			assertionFailure("Yet to implement \(type)")
			return rect(frame: shapeFrame)
		}
	}

	// swiftlint:enable function_body_length cyclomatic_complexity
}

// swiftlint:enable file_length
