//
//  RefreshFrameHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension ShapeObject {
	func refreshFrame(parentId: String?, shouldCache: Bool, config: PainterConfig?, matrix: OrientationMatrices, gprops: Properties? = nil, toDrawReflection: Bool = false, isMultiPathPreset: Bool = false) -> CGRect {
		if self.isHidden {
			return .null
		}
		switch self.type {
		case .shape:
			let shapeRefreshFrame = shape.refreshFrame(parentId: parentId, config: config, shouldCache: shouldCache, matrix: matrix, gprops: gprops, toDrawReflection: toDrawReflection, isMultiPathPreset: isMultiPathPreset)
			if shape.isMultiPathPreset {
				let multiPathShape = shape.props.getMultiPathGroupShape(gprops: gprops)
				let multiShapeFrame = multiPathShape.refreshFrame(parentId: parentId, shouldCache: shouldCache, config: config, matrix: matrix, toDrawReflection: toDrawReflection, isMultiPathPreset: true)
				let unionFrame = multiShapeFrame.union(shapeRefreshFrame)
				return unionFrame
			}
			return shapeRefreshFrame
		case .picture:
			if isMultiPathCropShape {
				return self.getShapeObjectForMultiPathCropShape().refreshFrame(
					parentId: parentId,
					shouldCache: shouldCache,
					config: config,
					matrix: matrix,
					gprops: gprops,
					toDrawReflection: toDrawReflection)
			}
			return self.picture.refreshFrame(
				parentId: parentId,
				config: config,
				shouldCache: shouldCache,
				matrix: matrix,
				gprops: gprops,
				toDrawReflection: toDrawReflection)
		case .connector:
			return self.connector.refreshFrame(
				parentId: parentId,
				painterConfig: config,
				shouldCache: shouldCache,
				gprops: gprops,
				matrix: matrix,
				toDrawReflection: toDrawReflection)
		case .groupshape:
			return self.groupshape.refreshFrame(
				parentId: parentId,
				config: config,
				shouldCache: shouldCache,
				matrix: matrix,
				gprops: gprops,
				toDrawReflection: toDrawReflection,
				isMultiPathPreset: isMultiPathPreset)
		case .graphicframe:
			return graphicframe.refreshFrame(
				parentId: parentId,
				config: config,
				shouldCache: shouldCache)
		case .paragraph:
			assertionFailure()
		case .combinedobject:
			return self.combinedobject.refreshFrame(
				parentId: parentId,
				config: config,
				shouldCache: shouldCache,
				matrix: matrix,
				gprops: gprops)
		}
		return .null
	}

	func childShapeRefreshFrame(parentId: String?, shouldCache: Bool, using config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		if isMultiPathPreset {
			return props.getMultiPathGroupShape(gprops: nil).refreshFrame(
				parentId: parentId,
				shouldCache: shouldCache,
				config: config,
				matrix: matrix)
		} else {
			return self.refreshFrame(
				parentId: id,
				shouldCache: shouldCache,
				config: config,
				matrix: matrix)
		}
	}
}

extension Shape {
	func refreshFrameWithoutEffects(gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		var textRefreshData: TextRefreshData?
		if self.hasTextBody {
			textRefreshData = .textBody(self.textBody)
		}
		return self.props.refreshFrameWithoutEffects(
			gprops: gprops,
			id: self.nvOprops.nvDprops.id,
			using: config,
			matrix: matrix,
			textRefreshData: textRefreshData).rect
	}

	func refreshFrame(parentId: String?, config: PainterConfig?, shouldCache: Bool, matrix: OrientationMatrices, gprops: Properties?, toDrawReflection: Bool = false, isMultiPathPreset: Bool = false) -> CGRect {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		// note now cached inside getModifiedTransform method
		if let cache = config?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id) {
			return rect.frame
		} else {
			let text = hasTextBody ? textBody : nil
			let textRefreshData = hasTextBody ? TextRefreshData.textBody(textBody) : nil
			var rect = self.props.refreshFrame(
				gprops: gprops,
				id: nvOprops.nvDprops.id,
				using: config,
				matrix: matrix,
				textRefreshData: textRefreshData,
				toDrawReflection: toDrawReflection,
				isMultiPathPreset: isMultiPathPreset)

			if let textBody = text {
				let baseFrame = self.textPathBbox(for: self.props.transform.rect)
				var textFrame = TextBody.getTextViewFrame(
					from: textBody.textAttributedString(using: config),
					basedOn: baseFrame,
					with: textBody.props)
				var propsCopy = self.props // Text won't be flipped; only the shapes will get flipped
				propsCopy.transform.fliph = false
				propsCopy.transform.flipv = false
				let currMatrix = propsCopy.transform.getMatrix(matrix, gTrans: gprops?.transform)
				var rotationConsolidated = currMatrix.rotationAndFlipMatrix
				let textBoundsAsPath = CGPath(rect: textFrame, transform: &rotationConsolidated)
				textFrame = textBoundsAsPath.boundingBoxOfPath

				rect = rect.union(textFrame)
			}

			if shouldCache, let config = config {
				config.cache?.setShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id, value: (rect, parentId))
			}
			return rect
		}
	}
}

extension ShapeObject.GroupShape {
	func refreshFrame(parentId: String?, config: PainterConfig?, shouldCache: Bool, matrix: OrientationMatrices, gprops: Properties?, toDrawReflection: Bool = false, isMultiPathPreset: Bool = false) -> CGRect {
		if let cache = config?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id) {
			return rect.frame
		}
		let mprops = props.getModifiedProps(from: gprops, using: config)
		let currentMatrices = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
		var rect = CGRect.null
		if hasMask {
			var nonHiddenMask = self.mask
			nonHiddenMask.isHidden = false
			let maskRect = nonHiddenMask.refreshFrame(parentId: self.nvOprops.nvDprops.id, shouldCache: shouldCache, config: config, matrix: currentMatrices, gprops: mprops)
			rect = rect.union(maskRect)
		} else {
			for i in 0..<shapes.count {
				var childRect = CGRect.zero
				if shapes[i].isMultiPathPreset {
					childRect = shapes[i].props.getMultiPathGroupShape(gprops: mprops).refreshFrame(parentId: self.nvOprops.nvDprops.id, shouldCache: shouldCache, config: config, matrix: currentMatrices, gprops: mprops, toDrawReflection: toDrawReflection, isMultiPathPreset: isMultiPathPreset)
				} else {
					childRect = shapes[i].refreshFrame(parentId: self.nvOprops.nvDprops.id, shouldCache: shouldCache, config: config, matrix: currentMatrices, gprops: mprops, toDrawReflection: toDrawReflection, isMultiPathPreset: isMultiPathPreset)
				}
				rect = rect.union(childRect)
			}
		}
		if props.hasEffects {
			let box = rect
			if props.effects.hasReflection {
				var grpShape = self
				var reflectProps = self.props
				self.props.setReflectionProps(reflectProps: &reflectProps)
				grpShape.props = reflectProps
				let refreshFrame = grpShape.refreshFrame(parentId: nil, config: config, shouldCache: false, matrix: matrix, gprops: gprops, toDrawReflection: toDrawReflection, isMultiPathPreset: isMultiPathPreset)
				rect = rect.union(refreshFrame)
			}

			if !toDrawReflection {
				let txty = props.effects.getEffectsFrameTranslates(for: rect)
				for (xy, radius) in txty {
					let dx = box.center.x - xy.x
					let dy = box.center.y - xy.y
					var shdwBox = box.offsetBy(dx: dx, dy: dy)
					shdwBox = shdwBox.enlargeBy(dx: CGFloat(radius), dy: CGFloat(radius))
					rect = rect.union(shdwBox)
				}
			}
		}
		rect = getBlurRefreshFrame(for: rect)

		if shouldCache, let cache = config?.cache {
			cache.setShapeLevelRefreshFrameMap(for: self.nvOprops.nvDprops.id, value: (rect, parentId))
		}
		return rect
	}

	func refreshFrameWithoutEffects(gprops: Properties?, config: PainterConfig?, matrix: OrientationMatrices) -> CGRect {
		let mprops = props.getModifiedProps(from: gprops, using: config)
		let currentMatrices = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
		var rect = CGRect.null
		if hasMask {
			let maskRect = self.mask.refreshFrameWithoutEffects(gprops: mprops, using: config, matrix: currentMatrices)
			rect = rect.union(maskRect)
		} else {
			for i in 0..<shapes.count {
				var childRect = CGRect.null
				if shapes[i].isMultiPathPreset {
					childRect = shapes[i].props.getMultiPathGroupShape(gprops: mprops).refreshFrameWithoutEffects(gprops: mprops, using: config, matrix: currentMatrices)
				} else {
					childRect = shapes[i].refreshFrameWithoutEffects(gprops: mprops, using: config, matrix: currentMatrices)
				}
				rect = rect.union(childRect)
			}
		}
		return rect
	}

	func childRefreshFrameWithControl(
		atIndex index: Int,
		withGroupProps gprops: Properties? = nil,
		using config: PainterConfig?,
		matrix: OrientationMatrices) -> CGRect {
		if shapes[index].isMultiPathPreset {
			return shapes[index].props.getMultiPathGroupShape(gprops: gprops)
				.refreshFrameWithControl(withGroupProps: gprops, config, matrix: matrix)
		}
		return shapes[index].refreshFrameWithControl(
			withGroupProps: gprops,
			config,
			matrix: matrix)
	}
}

extension GraphicFrame {
	func refreshFrame(parentId: String?, config: PainterConfig?, shouldCache: Bool) -> CGRect {
		if let cache = config?.cache, let rect = cache.getShapeLevelRefreshFrameMap(for: nvOprops.nvDprops.id) {
			return rect.frame
		} else {
			let rect = props.refreshFrame(for: props.transform)
			if shouldCache, let config = config {
				config.cache?.setShapeLevelRefreshFrameMap(for: nvOprops.nvDprops.id, value: (rect, parentId))
			}
			return rect
		}
	}
}

extension GraphicFrame.GraphicFrameProps {
	var frame: CGRect {
		get {
			return transform.rect
		}
		set {
			transform.rect = newValue
		}
	}

	func refreshFrame(for trans: Transform) -> CGRect {
		return self.frame
	}
}

extension Properties {
	func getRefreshTextFrame(from matrix: OrientationMatrices) -> CGRect {
		let textFrame = self.transform.rect.applying(matrix.scaleAndTranslateMatrix)
		var flipMatrix = self.transform.getFlipMatrix(rect: textFrame)
		let textPath = CGPath(rect: geom.preset.pathInfo(frame: textFrame).textFrame, transform: &flipMatrix)
		return textPath.boundingBoxOfPath
	}

	func refreshFrameForMarker(strokedPath: inout CGPath, path: CGPath, currentMatrix: OrientationMatrices) {
		let rect = self.transform.rect
		let finalOrientataionMatrix = currentMatrix
		if self.hasStroke {
			if stroke.hasHeadend {
				if let headEndPath = self.stroke.drawHeadEnd(path: path, frame: rect.applying(finalOrientataionMatrix.scaleAndTranslateMatrix), matrix: finalOrientataionMatrix) {
					strokedPath = headEndPath.fb_union(strokedPath)
				}
			}

			if stroke.hasTailend {
				if let tailEndPath = self.stroke.drawTailEnd(path: path, frame: rect.applying(finalOrientataionMatrix.scaleAndTranslateMatrix), matrix: finalOrientataionMatrix) {
					strokedPath = tailEndPath.fb_union(strokedPath)
				}
			}
		}
	}

	func refreshFrameWithoutEffects(gprops: Properties?, id: String, using config: PainterConfig?, matrix: OrientationMatrices, textRefreshData: TextRefreshData? = nil, isMultiPathPreset: Bool = false) -> (rect: CGRect, path: CGPath) {
		let maxStrokeWidth = self.strokeWidthForRefreshFrame
		let currentMatrix = self.transform.getMatrix(matrix, gTrans: gprops?.transform)
		var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix.concatenating(currentMatrix.rotationAndFlipMatrix)

		var shapePath = rawCGPath(id: id, using: config, isMultiPathPreset: isMultiPathPreset)
		if let transformedPath = shapePath.copy(using: &consolidatedMatrix) {
			shapePath = transformedPath
		}

		// Must use 'CGRect.null' as 'CGRect.zero' may alter final result on rect union operation
		var textPath = CGPath(rect: .null, transform: nil)
		if let textRefreshData = textRefreshData {
			switch textRefreshData {
			case let .textBody(textBody):
				if !textBody.isEmpty(id: id, using: config) {
					let textFrame = self.getRefreshTextFrame(from: currentMatrix)
					let textBounds = textBody.getTextBounds(frame: textFrame, id: id, config: config)

					if textBody.props.hasWrap, textBody.props.wrap == .none {
						// Rotation matrix constructed with rotation around actual center(center of transfrom.rect)
						let centerDiff = textBounds.center - textFrame.center
						var rotationMatrix = CGAffineTransform.identity.translatedBy(x: -centerDiff.x, y: -centerDiff.y)
						rotationMatrix = rotationMatrix.concatenating(currentMatrix.rotationAndFlipMatrix)
						rotationMatrix = rotationMatrix.translatedBy(x: centerDiff.x, y: centerDiff.y)

						let textBoundsAsPath = CGPath(rect: textBounds, transform: &rotationMatrix)
						textPath = textBoundsAsPath
					} else {
						var propsCopy = self // Text won't be flipped; only the shapes will get flipped
						propsCopy.transform.fliph = false
						propsCopy.transform.flipv = false
						let currMatrix = propsCopy.transform.getMatrix(matrix, gTrans: gprops?.transform)
						var rotationConsolidated = currMatrix.rotationAndFlipMatrix

						let textBoundsAsPath = CGPath(rect: textBounds, transform: &rotationConsolidated)
						textPath = textBoundsAsPath
					}
				}
			case .textPath:
				assertionFailure("For Show, data should have TextBody.")
			}
		}

		// NOTE: Since a 'Shape' can also contain 'TextBody' in Show, we've to consider max bounding box between shape and text paths
//		var path = shapePath
//		if !textPath.isNan, textPath.isValid, shapePath != textPath {
//			path = textPath.fb_union(shapePath)
//		}
//		if path.isNan || !path.isValid {
//			path = shapePath
//		}
//		if shapePath.boundingBoxOfPath.height > path.boundingBoxOfPath.height {
//			path = shapePath
//		}

		let shapeRect = shapePath.boundingBoxOfPath
		let textRect = textPath.boundingBoxOfPath
		let unionRect = shapeRect.union(textRect)
		var path = CGPath(rect: unionRect, transform: nil)

		var strokedPath = path.copy(strokingWithWidth: CGFloat(maxStrokeWidth), lineCap: .square, lineJoin: .miter, miterLimit: 10)
		self.refreshFrameForMarker(strokedPath: &strokedPath, path: path, currentMatrix: currentMatrix)
		path = strokedPath

		let rect = path.boundingBoxOfPath
		return (rect, path)
	}
}

extension TextBody {
	func getTextBounds(frame: CGRect, id: String, config: PainterConfig?) -> CGRect {
#if os(watchOS)
		return frame
#else
		var textBounds = self.getTextAsPaths(withFrame: frame, id: id, using: config, charactersRequired: false).boundingBoxOfPaths
		textBounds = textBounds.isValid ? textBounds.union(frame) : frame
		return textBounds
#endif
	}
}
