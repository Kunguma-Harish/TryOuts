//
//  Stroke+Draw.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Stroke {
	/// Strokes the path on to the context by applying additional configurations
	///
	/// - Parameters:
	///   - ctx: Drawing Context
	///   - path: CGPath to be stroked
	///   - config: Additional Configurations that has to be included before painting
	///   - frame: Actual Shape frame (for Connectors)
	func draw(in ctx: RenderingContext, with path: CGPath, using config: PainterConfig? = nil, frame: CGRect? = nil, forId id: String, shapeOrientation: ShapeOrientation = ShapeOrientation()) {
		// https://stackoverflow.com/questions/1798441/preserve-line-width-while-scaling-all-points-in-the-context-with-cgaffinetransfo
		ctx.cgContext.saveGState()
		if hasBlend {
			ctx.cgContext.setBlendMode(blend.mode)
		}

		let dashedPath = getDashedPath(for: path)
		var strokedPath = getStrokedPath(for: dashedPath)

		if let rect = frame {
			let finalOrientataionMatrix = shapeOrientation.finalOrientationMatrix
			if hasHeadend {
				if let headEndPath = drawHeadEnd(path: path, frame: rect.applying(finalOrientataionMatrix.scaleAndTranslateMatrix), matrix: finalOrientataionMatrix) {
					strokedPath = headEndPath.fb_union(strokedPath)
				}
			}

			if hasTailend {
				if let tailEndPath = drawTailEnd(path: path, frame: rect.applying(finalOrientataionMatrix.scaleAndTranslateMatrix), matrix: finalOrientataionMatrix) {
					strokedPath = tailEndPath.fb_union(strokedPath)
				}
			}
		}

		switch position {
		case .unknownPosition, .center:
			ctx.cgContext.addPath(strokedPath)
			ctx.cgContext.clip()

		case .inside:
			ctx.cgContext.addPath(path)
			ctx.cgContext.clip(using: .evenOdd)
			ctx.cgContext.addPath(strokedPath)
			ctx.cgContext.clip()

		case .outside:
			ctx.cgContext.addRect(path.boundingBoxOfPath.enlargeBy(dx: 1_000, dy: 1_000))
			ctx.cgContext.addPath(path)
			ctx.cgContext.clip(using: .evenOdd)
			ctx.cgContext.addPath(strokedPath)
			ctx.cgContext.clip()
		}

		if hasFill {
			// TODO: - not sure about frame for fill `strokedPath.boundingBoxOfPath or dashedPath.boundingBpxpfPath`
			ctx.cgContext.addRect(strokedPath.boundingBoxOfPath)
			fill.draw(in: ctx, within: path.boundingBoxOfPath, using: config, forId: id)
		}
		ctx.cgContext.restoreGState()
	}

	func contains(point: CGPoint, for path: CGPath) -> Bool {
		let strokedPath = getStrokedPath(for: path)
		switch self.position {
		case .unknownPosition, .center:
			return strokedPath.contains(point)
		case .inside:
			if path.contains(point, using: .evenOdd), strokedPath.contains(point) {
				return true
			}
			return false
		case .outside:
			if strokedPath.contains(point), !path.contains(point, using: .evenOdd) {
				return true
			}
			return false
		}
	}

	func getStrokeFillPath(for path: CGPath, with id: String?, config: PainterConfig?) -> CGPath {
		var fillRemoveStroke = self
		fillRemoveStroke.clearFill()
		if let id = id, let strokePath = config?.cache?.getStrokePathMap(for: id, with: fillRemoveStroke.hashValue) {
			return strokePath
		} else {
			let dashedPath = getDashedPath(for: path)
			let strokedPath = getStrokedPath(for: dashedPath)
			if let id = id {
				config?.cache?.setStrokePathMap(for: id, value: (strokedPath, fillRemoveStroke.hashValue))
			}
			return strokedPath
		}
	}

	func drawHeadEnd(path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath? {
		let markerWidth = Preset.getMarkerSize(headend.width)
		let markerHeight = Preset.getMarkerSize(headend.height)
		var path1: CGPath?

		switch headend.type {
		case .block:
			path1 = headEndBlock(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .classic:
			path1 = headEndClassic(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .diamond:
			path1 = headEndDiamond(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .open:
			path1 = headEndOpen(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .oval:
			path1 = headEndOval(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .none, .defMarkerType:
			break
		}
		return path1
	}

	func drawTailEnd(path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath? {
		let markerWidth = Preset.getMarkerSize(tailend.width)
		let markerHeight = Preset.getMarkerSize(tailend.height)
		var path1: CGPath?

		switch tailend.type {
		case .block:
			path1 = tailEndBlock(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .classic:
			path1 = tailEndClassic(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .diamond:
			path1 = tailEndDiamond(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .open:
			path1 = tailEndOpen(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .oval:
			path1 = tailEndOval(markerWidth: markerWidth, markerHeight: markerHeight, path: path, frame: frame, matrix: matrix)
		case .none, .defMarkerType:
			break
		}
		return path1
	}
}

private extension Stroke {
	func getDashedPath(for path: CGPath) -> CGPath {
		var dashedPath: CGPath
		if self.type == .solid {
			dashedPath = path
		} else {
			dashedPath = path.copy(dashingWithPhase: 0, lengths: self.dashPattern.map { CGFloat($0) })
		}
		return dashedPath
	}

	func getStrokedPath(for path: CGPath) -> CGPath {
		let lineCap = self.captype.cap
		let lineJoin = self.jointype.join

		let strokedPath: CGPath
		switch self.position {
		case .unknownPosition, .center:
			strokedPath = path.copy(
				strokingWithWidth: CGFloat(width),
				lineCap: lineCap,
				lineJoin: lineJoin,
				miterLimit: 10.0)

		case .inside:
			strokedPath = path.copy(
				strokingWithWidth: CGFloat(width * 2.0),
				lineCap: lineCap,
				lineJoin: lineJoin,
				miterLimit: 10.0)

		case .outside:
			strokedPath = path.copy(
				strokingWithWidth: CGFloat(width * 2.0),
				lineCap: lineCap,
				lineJoin: lineJoin,
				miterLimit: 10.0)
		}
		return strokedPath
	}
}

// MARK: Head and Tail ends of Stroke

private extension Stroke {
	// MARK: Stroke TailEnd

	func tailEndBlock(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		guard let cap = CGLineCap(rawValue: Int32(captype.rawValue - 1)) else {
			assertionFailure("captype error")
			return CGMutablePath()
		}

		let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)
		let startX = (miterLength * CGFloat(width) + (markerHeight * CGFloat(width)))
		let startY = -(markerWidth / 2 * CGFloat(width))
		var path1: CGPath = Preset.headendBlock(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY,
			cap: cap)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[point.0.count - 1].x, y: point.0[point.0.count - 1].y - box.height / 2, width: box.width, height: box.height)

		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: false)
		path1 = path1.rotateBy(angle: CGFloat.pi + theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func tailEndClassic(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)
		let startX = (miterLength * CGFloat(width)) + (markerHeight * CGFloat(width))
		let startY = -(markerWidth / 2.0 * CGFloat(width))
		var path1: CGPath = Preset.headendClassicMarker(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[point.0.count - 1].x, y: point.0[point.0.count - 1].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: false)
		path1 = path1.rotateBy(angle: CGFloat.pi + theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func tailEndDiamond(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		var path1: CGPath = Preset.diamond(width: CGFloat(width), ry: markerWidth, rx: markerHeight, cx: CGFloat(0), cy: CGFloat(0))

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[point.0.count - 1].x, y: point.0[point.0.count - 1].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: false)
		path1 = path1.rotateBy(angle: CGFloat.pi + theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func tailEndOpen(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)
		let startX = (miterLength * CGFloat(width)) + (markerHeight * CGFloat(width))
		let startY = -(markerWidth / CGFloat(2.0) * CGFloat(width))
		var path1: CGPath = Preset.headendOpenMarker(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.maxX, frame.maxY).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[point.0.count - 1].x, y: point.0[point.0.count - 1].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: false)
		path1 = path1.rotateBy(angle: theta + CGFloat.pi, rect: path1.boundingBoxOfPath)
		return path1
	}

	func tailEndOval(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		var path1: CGPath = Preset.oval(width: CGFloat(width), ry: markerWidth, rx: markerHeight, cx: CGFloat(0), cy: CGFloat(0))

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[point.0.count - 1].x, y: point.0[point.0.count - 1].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: false)
		path1 = path1.rotateBy(angle: CGFloat.pi + theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	// MARK: Stroke HeadEnd

	func headEndBlock(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		guard let cap = CGLineCap(rawValue: Int32(captype.rawValue - 1)) else {
			assertionFailure("captype error")
			return CGMutablePath()
		}
		let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)
		let startX = (miterLength * CGFloat(width) + (markerHeight * CGFloat(width)))
		let startY = -(markerWidth / 2 * CGFloat(width))
		var path1: CGPath = Preset.headendBlock(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY,
			cap: cap)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[0].x, y: point.0[0].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: true)
		path1 = path1.rotateBy(angle: theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func headEndClassic(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		let miterLength = Preset.getMiterLength(w: markerWidth, h: markerHeight)
		let startX = (miterLength * CGFloat(width)) + (markerHeight * CGFloat(width))
		let startY = -(markerWidth / 2.0 * CGFloat(width))
		var path1: CGPath = Preset.headendClassicMarker(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[0].x, y: point.0[0].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: true)
		path1 = path1.rotateBy(angle: theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func headEndDiamond(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		var path1: CGPath = Preset.diamond(width: CGFloat(width), ry: markerWidth, rx: markerHeight, cx: CGFloat(0), cy: CGFloat(0))

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[0].x, y: point.0[0].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: true)
		path1 = path1.rotateBy(angle: theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func headEndOpen(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		let miterLength = Preset.getMiterLength(w: markerHeight, h: markerWidth)
		let startX = (miterLength * CGFloat(width)) + (markerHeight * CGFloat(width))
		let startY = -(markerWidth / CGFloat(2.0) * CGFloat(width))

		var path1: CGPath = Preset.headendOpenMarker(
			width: CGFloat(width),
			markerWidth: markerHeight,
			markerHeight: markerWidth,
			startX: startX,
			startY: startY)

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[0].x, y: point.0[0].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: true)
		path1 = path1.rotateBy(angle: theta, rect: path1.boundingBoxOfPath)
		return path1
	}

	func headEndOval(markerWidth: CGFloat, markerHeight: CGFloat, path: CGPath, frame: CGRect, matrix: OrientationMatrices) -> CGPath {
		var path1: CGPath = Preset.oval(width: CGFloat(width), ry: markerWidth, rx: markerHeight, cx: CGFloat(0), cy: CGFloat(0))

		var point = path.getPathElementsPointsAndTypes()
		if point.0.isEmpty {
			return path1
		}
		let rotationMatrix = matrix.rotationAndFlipMatrix
		point.0[0] = frame.origin.applying(rotationMatrix)
		point.0[point.0.count - 1] = CGPoint(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height).applying(rotationMatrix)

		let box = path1.boundingBoxOfPath
		let toRect = CGRect(x: point.0[0].x, y: point.0[0].y - box.height / 2, width: box.width, height: box.height)
		path1 = path1.transform(to: toRect)

		let theta = Preset.anglesForRotation(point: point, header: true)
		path1 = path1.rotateBy(angle: theta, rect: path1.boundingBoxOfPath)
		return path1
	}
}
