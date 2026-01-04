//
//  RefreshFrame.swift
//  Painter
//
//  Created by Akshay T S on 21/01/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

enum TextRefreshData {
	case textBody(TextBody)
	case textPath(CGPath)
}

extension ShapeObject {
	func refreshFrameWithControl(
		withGroupProps gprops: Properties? = nil,
		_ config: PainterConfig?,
		matrix: OrientationMatrices) -> CGRect {
		let completeShapeObject = self.getCompleteShapeObject(config, withVisualTransform: true)
		switch completeShapeObject.type {
		case .shape:
			return completeShapeObject.shape.props.refreshFrameWithControl(
				withGroupProps: gprops,
				id: self.id,
				using: config,
				matrix: matrix)
		case .picture:
			return completeShapeObject.picture.props.refreshFrameWithControl(
				withGroupProps: gprops,
				id: self.id,
				using: config,
				matrix: matrix)
		case .connector:
			return completeShapeObject.connector.props.refreshFrameWithControl(
				withGroupProps: gprops,
				id: self.id,
				using: config,
				matrix: matrix)
		case .groupshape:
			return completeShapeObject.groupshape.refreshFrameWithControl(
				withGroupProps: gprops,
				using: config,
				matrix: matrix)
		case .graphicframe:
			assertionFailure()
		case .paragraph:
			assertionFailure()
		case .combinedobject:
			return completeShapeObject.combinedobject.refreshFrameWithControl(
				withGroupProps: gprops,
				id: self.id,
				using: config,
				matrix: matrix)
		}
		return .null
	}

	func refreshFrameWithoutEffects(
		gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices) -> CGRect {
		let completeShapeObject = self.getCompleteShapeObject(config, withVisualTransform: true)
		switch completeShapeObject.type {
		case .shape:
			return completeShapeObject.shape.refreshFrameWithoutEffects(
				gprops: gprops,
				using: config,
				matrix: matrix)
		case .picture:
			return completeShapeObject.picture.props.refreshFrameWithoutEffects(
				gprops: gprops,
				id: id,
				using: config,
				matrix: matrix).rect
		case .connector:
			return completeShapeObject.connector.props.refreshFrameWithoutEffects(
				gprops: gprops,
				id: id,
				using: config,
				matrix: matrix).rect
		case .groupshape:
			return completeShapeObject.groupshape.refreshFrameWithoutEffects(
				gprops: gprops,
				config: config,
				matrix: matrix)
		case .graphicframe:
			assertionFailure()
		case .paragraph:
			assertionFailure()
		case .combinedobject:
			return completeShapeObject.combinedobject.props.refreshFrameWithoutEffects(
				gprops: gprops,
				id: id,
				using: config,
				matrix: matrix).rect
		}
		return .null
	}
}

extension Proto.Picture {
	func refreshFrame(parentId: String?, config: PainterConfig?, shouldCache: Bool, matrix: OrientationMatrices, gprops: Properties?, toDrawReflection: Bool = false) -> CGRect {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		// note now cached inside getModifiedTransform method
		if let cache = config?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id) {
			return rect.frame
		} else {
			let rect = self.props.refreshFrame(gprops: gprops, id: nvOprops.nvDprops.id, using: config, matrix: matrix, toDrawReflection: toDrawReflection)
			if shouldCache, let config = config {
				config.cache?.setShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id, value: (rect, parentId))
			}
			return rect
		}
	}
}

extension Connector {
	func refreshFrame(parentId: String?, painterConfig: PainterConfig?, shouldCache: Bool, gprops: Properties?, matrix: OrientationMatrices, toDrawReflection: Bool = false) -> CGRect {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		// note now cached inside getModifiedTransform method
		if let cache = painterConfig?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id) {
			return rect.frame
		} else {
			let rect = self.props.refreshFrame(gprops: gprops, id: nvOprops.nvDprops.id, using: painterConfig, matrix: matrix, toDrawReflection: toDrawReflection)
			if shouldCache, let config = painterConfig {
				config.cache?.setShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id, value: (rect, parentId))
			}
			return rect
		}
	}
}

extension ShapeObject.GroupShape {
	func refreshFrameWithControl(
		withGroupProps gprops: Properties? = nil,
		using config: PainterConfig?,
		matrix: OrientationMatrices) -> CGRect {
		let (mprops, currentMatrices) = self.getModifiedPropsAndMatrix(
			withGroupProps: gprops,
			using: config,
			matrix: matrix)

		var rect = CGRect.null
		assert(!shapes.isEmpty, "groupshape should not be empty")
		if hasMask {
			rect = rect.union(self.mask.refreshFrameWithControl(withGroupProps: mprops, config, matrix: currentMatrices))
		} else {
			for i in 0..<shapes.count {
				rect = rect.union(self.childRefreshFrameWithControl(
					atIndex: i,
					withGroupProps: mprops,
					using: config,
					matrix: currentMatrices))
			}
			if self.hasAdditionalFollowers {
				for shapeObject in additionalFollowers.shapesBeneath {
					rect = rect.union(shapeObject.refreshFrameWithControl(withGroupProps: mprops, config, matrix: matrix))
				}
				for shapeObject in additionalFollowers.shapesOnTop {
					rect = rect.union(shapeObject.refreshFrameWithControl(withGroupProps: mprops, config, matrix: matrix))
				}
			}
		}

		if props.hasEffects {
			let box = rect
			let txty = props.effects.getEffectsFrameTranslates(for: box)
			for (xy, radius) in txty {
				let dx = box.center.x - xy.x
				let dy = box.center.y - xy.y
				var shdwBox = box.offsetBy(dx: dx, dy: dy)
				shdwBox = shdwBox.enlargeBy(dx: CGFloat(radius * 2.57), dy: CGFloat(radius * 2.57))
				rect = rect.union(shdwBox)
			}

			let shapeRotationAngle = props.transform.rotationAngle
			if 91...179 ~= shapeRotationAngle || 181...269 ~= shapeRotationAngle {
				rect.size.height += rect.height / 2
			}

			var offset = CGFloat(props.effects.reflection.distance.radius)
			offset += props.reflectionOffset
			rect.size.height += offset
		}
		return self.getBlurRefreshFrame(for: rect)
	}

	func getBlurRefreshFrame(for rect: CGRect) -> CGRect {
		var rect = rect
		if props.hasBlur {
			let oldCenter = rect.center
			let ratioWidth: CGFloat
			let ratioHeight: CGFloat
			switch props.blur.type {
			case .unknownType, .masked:
				ratioWidth = 1.0
				ratioHeight = 1.0
			case .box:
				ratioWidth = 1.5
				ratioHeight = 1.5
			case .disc, .gaussian:
				ratioWidth = 2.0
				ratioHeight = 2.0
			case .motion:
				ratioWidth = 3.0
				ratioHeight = 1.0
			case .zoom:
				ratioWidth = 3.0
				ratioHeight = 3.0
			}
			rect.size = CGSize(width: rect.width * ratioWidth, height: rect.height * ratioHeight)
			rect.center = oldCenter
		}
		return rect
	}
}

extension ShapeObject.CombinedObject {
	func refreshFrame(parentId: String?, config: PainterConfig?, shouldCache: Bool, matrix: OrientationMatrices, gprops: Properties?) -> CGRect {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		// note now cached inside getModifiedTransform method
		if let cache = config?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id) {
			return rect.frame
		} else {
			let rect = self.props.refreshFrame(gprops: gprops, id: self.nvOprops.nvDprops.id, using: config, matrix: matrix)
			let mprops = props.getModifiedProps(from: gprops, using: config)
			let currentMatrices = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
			for node in combinedNodes {
				switch node.type {
				case .unknown:
					assertionFailure("Should not come here.")
					return CGRect.null
				case .shape:
					_ = node.shape.refreshFrame(parentId: self.nvOprops.nvDprops.id, config: config, shouldCache: shouldCache, matrix: currentMatrices, gprops: mprops)
				case .combinedobject:
					_ = node.combinedobject.refreshFrame(parentId: self.nvOprops.nvDprops.id, config: config, shouldCache: shouldCache, matrix: currentMatrices, gprops: mprops)
				}
			}
			if shouldCache, let cache = config?.cache {
				cache.setShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id, value: (rect, parentId))
			}
			return rect
		}
	}

	func refreshFrameWithControl(withGroupProps gprops: Properties? = nil, id: String, using config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		return props.refreshFrameWithControl(withGroupProps: gprops, id: id, using: config, matrix: matrix)
	}
}

extension Properties {
	var strokeWidthForRefreshFrame: Float {
		var widths: [Float] = [0]
		if hasStroke, stroke.fill.type != .none, !stroke.fill.hidden {
			let strokeWidthMiter = stroke.width
			switch stroke.position {
			case .center, .unknownPosition:
				widths.append(strokeWidthMiter)
			case .inside:
				// do nothing
				break
			case .outside:
				widths.append(strokeWidthMiter * 2.0)
			}
		}
		if !strokes.isEmpty {
			for stroke in strokes where stroke.fill.type != .none && !stroke.fill.hidden {
				let strokeWidthMiter = stroke.width
				switch stroke.position {
				case .center, .unknownPosition:
					widths.append(strokeWidthMiter)
				case .inside:
					// do nothing
					break
				case .outside:
					widths.append(strokeWidthMiter * 2.0)
				}
			}
		}
		return widths.max() ?? 0
	}

	public func modifyShapeFrame(_ rect: inout CGRect, mtrans: Transform) {
		let currentRect = transform.rect.rotateAtCenter(byDegree: CGFloat(transform.rotationAngle))
		let mtransRect = mtrans.rect.rotateAtCenter(byDegree: CGFloat(mtrans.rotationAngle))
		let dx = mtransRect.origin.x - currentRect.origin.x
		let dy = mtransRect.origin.y - currentRect.origin.y
		let dWidth = mtransRect.width - currentRect.width
		let dHeight = mtransRect.height - currentRect.height
		rect = rect.offsetBy(dx: dx, dy: dy)
		rect.size.width += dWidth
		rect.size.height += dHeight
	}

	func refreshFrameWithControl(withGroupProps gprops: Properties? = nil, id: String, using config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		// note now cached inside getModifiedTransform method
		let level1Hash = String(self.hashValue)
		if let rect = config?.cache?.getRefreshFrameWithControlMapCache(for: level1Hash) {
			return rect
		} else {
			let rect = self.refreshFrameWithControl(gprops: gprops, id: id, using: config, matrix: matrix)
//			config?.cache?.setRefreshFrameWithControlMap(for: id, value: rect)
			return rect
		}
	}

	// includes stroke width, shadow and reflection bounds
	func refreshFrame(
		gprops: Properties?,
		id: String,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		textRefreshData: TextRefreshData? = nil,
		toDrawReflection: Bool = false,
		isMultiPathPreset: Bool = false) -> CGRect {
		let standAloneComponents = refreshFrameWithoutEffects(
			gprops: gprops,
			id: id,
			using: config,
			matrix: matrix,
			textRefreshData: textRefreshData,
			isMultiPathPreset: isMultiPathPreset)
		let bBox = standAloneComponents.path.boundingBoxOfPath

		var rect = CGRect.null
		var reflectionBbox = CGRect.null

		if hasEffects {
			if !toDrawReflection {
				let txty = effects.getEffectsFrameTranslates(for: bBox)
				for (xy, radius) in txty {
					let dx = bBox.center.x - xy.x
					let dy = bBox.center.y - xy.y
					let enlargeFactor = CGFloat(radius * 2.57)
					var shadowBox = bBox.offsetBy(dx: dx, dy: dy)
					shadowBox = shadowBox.enlargeBy(dx: enlargeFactor, dy: enlargeFactor)
					rect = rect.union(shadowBox)
				}
			}

			if effects.hasReflection {
				var reflectionProps = self
				setReflectionProps(reflectProps: &reflectionProps)

				let rawPath = rawCGPath(forTransform: transform, id: id, using: config)
				let currentMatrix = transform.getMatrix(matrix, gTrans: gprops?.transform)
				let consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
					.concatenating(currentMatrix.rotationAndFlipMatrix)
				reflectionBbox = rawPath.boundingBoxOfPath.applying(consolidatedMatrix)

				var refOffset = CGFloat(effects.reflection.distance.radius)
				refOffset += reflectionOffset
				reflectionBbox.origin.y += refOffset

				let txty = reflectionProps.effects.getEffectsFrameTranslates(for: reflectionBbox)
				for (xy, radius) in txty {
					let dx = reflectionBbox.center.x - xy.x
					let dy = reflectionBbox.center.y - xy.y
					let enlargeFactor = CGFloat(radius * 2.57)
					var shadowBox = reflectionBbox.offsetBy(dx: dx, dy: dy)
					shadowBox = shadowBox.enlargeBy(dx: enlargeFactor, dy: enlargeFactor)
					rect = rect.union(shadowBox)
				}
				rect = rect.union(reflectionBbox)
			}
		}

		if hasBlur {
			let oldCenter = rect.center
			let ratioWidth: CGFloat
			let ratioHeight: CGFloat
			switch blur.type {
			case .unknownType, .masked:
				ratioWidth = 1.0
				ratioHeight = 1.0
			case .box:
				ratioWidth = 1.5
				ratioHeight = 1.5
			case .disc, .gaussian:
				ratioWidth = 2.0
				ratioHeight = 2.0
			case .motion: // TODO: Urgent - Wrong. Consider height for angle.
				ratioWidth = 3.0
				ratioHeight = 1.0
			case .zoom:
				ratioWidth = 3.0
				ratioHeight = 3.0
			}
			rect.size = CGSize(width: rect.width * ratioWidth, height: rect.height * ratioHeight)
			rect.center = oldCenter
		}
		if !toDrawReflection {
			rect = rect.union(standAloneComponents.rect)
		}
		return rect
	}

	// bounds the control points also
	fileprivate func refreshFrameWithControl(gprops: Properties?, id: String, using config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		var tpath = rawCGPath(id: id, using: config)
		let currentMatrix = self.transform.getMatrix(matrix, gTrans: gprops?.transform)
		var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
			.concatenating(currentMatrix.rotationAndFlipMatrix)
		if let transformedPath = tpath.copy(using: &consolidatedMatrix) {
			tpath = transformedPath
		}
		let controlBoundedBox = tpath.boundingBoxOfPath
		let refreshFrame = self.refreshFrame(gprops: gprops, id: id, using: config, matrix: matrix)
		return controlBoundedBox.union(refreshFrame)
	}
}
