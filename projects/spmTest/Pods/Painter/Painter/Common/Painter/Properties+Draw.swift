//
//  Properties+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

//	NOTE: File Tips
//	1.	Both refresh frame and blur frame calculation are identical, except that refresh frame considers blur as well.
//		If refresh frame calculation is modified, make the same changes in blur frame calculation as well.

import CoreGraphics
import Foundation
import Proto

public extension Properties {
	var frame: CGRect {
		get {
			return transform.rect
		}
		set {
			transform.rect = newValue
		}
	}

	var isConnector: Bool {
		let connectors: [GeometryField.PresetShapeGeometry] = [
			.line, .curvedConnector2, .curvedConnector3, .curvedConnector4, .curvedConnector5,
			.elbowConnector2, .elbowConnector3, .elbowConnector4, .elbowConnector5
		]
		return connectors.contains(geom.preset.type)
	}

	var shadowFills: [Fill] {
		var shadowFills: [Fill] = []
		if hasFill, fill.type != .none, !fill.hidden, !self.isConnector {
			shadowFills.append(fill)
		}

		for fill in fills where fill.type != .none && !fill.hidden {
			shadowFills.append(fill)
		}
		return shadowFills
	}

	var shadowStrokes: [Stroke] {
		var shadowInsideStroke: Stroke?
		var shadowOutsideStroke: Stroke?
		var shadowCenterStroke: Stroke?

		if hasStroke, stroke.fill.type != .none, !stroke.fill.hidden {
			switch stroke.position {
			case .unknownPosition:
				shadowCenterStroke = stroke
			case .center:
				shadowCenterStroke = stroke
			case .inside:
				shadowInsideStroke = stroke
			case .outside:
				shadowOutsideStroke = stroke
			}
		}

		for stroke in strokes where stroke.fill.type != .none && !stroke.fill.hidden {
			switch stroke.position {
			case .unknownPosition:
				if shadowCenterStroke == nil || stroke.width > (shadowCenterStroke?.width ?? -1) {
					shadowCenterStroke = stroke
				}
			case .center:
				if shadowCenterStroke == nil || stroke.width > (shadowCenterStroke?.width ?? -1) {
					shadowCenterStroke = stroke
				}
			case .inside:
				if shadowInsideStroke == nil || stroke.width > (shadowInsideStroke?.width ?? -1) {
					shadowInsideStroke = stroke
				}
			case .outside:
				if shadowOutsideStroke == nil || stroke.width > (shadowOutsideStroke?.width ?? -1) {
					shadowOutsideStroke = stroke
				}
			}
		}

		var shadowStrokes = [Stroke]()
		if let stroke = shadowInsideStroke {
			shadowStrokes.append(stroke)
		}
		if let stroke = shadowOutsideStroke {
			shadowStrokes.append(stroke)
		}
		if let stroke = shadowCenterStroke {
			shadowStrokes.append(stroke)
		}
		return shadowStrokes
	}

	func clip(_ ctx: RenderingContext, with path: CGPath) {
		ctx.cgContext.addPath(path)
		ctx.cgContext.clip(using: .evenOdd) // Must use 'EvenOdd' clipping rule if cropped to 'Donut' like shapes
	}

	func drawFillAndStroke(
		in ctx: RenderingContext,
		on path: CGPath,
		within rect: CGRect,
		withGroupProps gprops: Properties?,
		isMultipathPreset: Bool,
		using config: PainterConfig?,
		forId id: String,
		shapeOrientation: ShapeOrientation = ShapeOrientation(),
		crop: Offset? = nil) {
		// At times, the fill object may turn out to be empty (especially in imported pptx presentations)
		// Added additional check to make sure that it is not empty

		if hasFill, !fill.isEmpty, !fill.hidden, fill.type != .none, !self.isConnector {
			ctx.cgContext.saveGState()
			ctx.cgContext.addPath(path)

			if self.fill.type == .grp, let gprops = gprops, gprops.hasFill, let parentRect = shapeOrientation.grpRect {
				self.fill.draw(in: ctx, within: parentRect, withGroupFill: gprops.fill, using: config, forId: id, shapeOrientation: shapeOrientation, crop: crop)
			} else {
				if gprops != nil, let parentRect = shapeOrientation.grpRect {
					self.fill.draw(in: ctx, within: parentRect, withGroupFill: nil, using: config, forId: id, shapeOrientation: shapeOrientation)
				} else {
					self.fill.draw(in: ctx, within: rect, withGroupFill: nil, using: config, forId: id, shapeOrientation: shapeOrientation)
				}
			}
			ctx.cgContext.restoreGState()
		}

		if !fills.isEmpty, !self.isConnector {
			for fill in fills where
				!fill.isEmpty && fill.type != .none && !fill.hidden && fill.type != .grp {
				ctx.cgContext.saveGState()
				ctx.cgContext.addPath(path)
				fill.draw(in: ctx, within: rect, withGroupFill: gprops?.fill, using: config, forId: id, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
		}

		if hasStroke, !stroke.isEmpty, stroke.fill.type != .none, !stroke.fill.hidden {
			stroke.draw(in: ctx, with: path, using: config, frame: rect, forId: id, shapeOrientation: shapeOrientation)
		}

		if !strokes.isEmpty {
			for stroke in strokes where
				!stroke.isEmpty && stroke.fill.type != .none && !stroke.fill.hidden {
				stroke.draw(in: ctx, with: path, using: config, frame: rect, forId: id, shapeOrientation: shapeOrientation)
			}
		}
	}

	func getModifiedProps(from gprops: Properties?, using config: PainterConfig?) -> Properties {
		if let gprops = gprops {
			var mprops = self

			if gprops.hasFill, !hasFill || (hasFill && fill.type == .grp && fill.grp) {
				mprops.fill = gprops.fill
			}

			if gprops.hasStroke, !hasStroke || (hasStroke && stroke.fill.type == .grp && stroke.fill.grp) {
				mprops.stroke = gprops.stroke
			}
			return mprops
		} else {
			return self
		}
	}

	// With rotation and flip, used for combinedshape usage
	func transformedCGPath(forTransform trans: Transform, id: String, using config: PainterConfig?, isMultiPathPreset: Bool = false) -> CGPath {
		let transHash = trans.hashValue
		if let tpath = config?.cache?.getTransformedPathMap(for: id, with: transHash) {
			return tpath
		} else {
			var path = getTransformedCGPath(forId: id, with: trans, using: config, isMultiPathPreset: isMultiPathPreset)
			if trans.fliph {
				path = path.horizontalFlip(in: trans.rect)
			}
			if trans.flipv {
				path = path.verticalFlip(in: trans.rect)
			}
			path = path.rotate(byDegree: CGFloat(trans.rotationAngle))

			config?.cache?.setTransformedPathMap(for: id, value: (path, transHash))
			return path
		}
	}

	func transformedCGPathWithoutRadius(forTransform trans: Transform, id: String, using config: PainterConfig?) -> CGPath {
		let transHash = trans.hashValue
		if let tpath = config?.cache?.getTransformedPathWithoutRadiusMap(for: id, with: transHash) {
			return tpath
		} else {
			var path = getTransformedCGPathWithoutRadius(forId: id, with: trans, using: config)
			if trans.fliph {
				path = path.horizontalFlip(in: trans.rect)
			}
			if trans.flipv {
				path = path.verticalFlip(in: trans.rect)
			}
			path = path.rotate(byDegree: CGFloat(trans.rotationAngle))

			config?.cache?.setTransformedPathWithoutRadiusMap(for: id, value: (path, transHash))
			return path
		}
	}

	// Original
	//    func transformedCGPath(forTransform trans: Transform) -> CGPath {
	//        let transFormedPathHash = String(geom.hashValue) + String(trans.hashValue)
	//        if let tpath = Cache.transformedPathMap[transFormedPathHash] {
	//            return tpath
	//        } else {
	//            var path = geom.cgpath
	//            path = path.transform(to: trans.rect)
	//
	//            // Corner radius
	//            if (geom.type == .preset) && (geom.preset.hasCornerRadius) {
	//                var customGeom = path.custom
	//                let cornerRadius = Float.minimum(geom.preset.cornerRadius, maxCornerRadiusForPreset)
	//                addPresetCornerRadius(cornerRadius, to: &customGeom)
	//                path = customGeom.cgpath
	//            }
	//
	//            path = path.rotate(byDegree: CGFloat(trans.rotationAngle))
	//            if trans.fliph {
	//                path = path.horizontalFlip
	//            }
	//            if trans.flipv {
	//                path = path.verticalFlip
	//            }
	//
	//            Cache.transformedPathMap[transFormedPathHash] = path
	//            return path
	//        }
	//    }

	// Without rotation and Flip, but confined to given Transform
	func rawCGPath(forTransform trans: Transform, id: String, using config: PainterConfig?, isMultiPathPreset: Bool = false) -> CGPath {
		var trans = trans
		trans.rotationAngle = 0
		trans.fliph = false
		trans.flipv = false
		return self.transformedCGPath(forTransform: trans, id: id, using: config, isMultiPathPreset: isMultiPathPreset)
	}

	func rawCGPathWithoutRadius(forTransform trans: Transform, id: String, using config: PainterConfig?) -> CGPath {
		var trans = trans
		trans.rotationAngle = 0
		trans.fliph = false
		trans.flipv = false
		return self.transformedCGPathWithoutRadius(forTransform: trans, id: id, using: config)
	}

	// TODO: - some methods and properties should only be called if they have geom, properly assert them
	func transformedCGPath(id: String, using config: PainterConfig?, isMultiPathPreset: Bool = false) -> CGPath {
		return self.transformedCGPath(forTransform: transform, id: id, using: config, isMultiPathPreset: isMultiPathPreset)
	}

	// Without rotation and Flip, but confined to own Transform
	func rawCGPath(id: String, using config: PainterConfig?, isMultiPathPreset: Bool = false) -> CGPath {
		return self.rawCGPath(forTransform: transform, id: id, using: config, isMultiPathPreset: isMultiPathPreset)
	}

	func blurFrame(forTransform trans: Transform, id: String, using config: PainterConfig?) -> CGRect {
		if blur.type == .masked {
			return trans.rect.rotateAtCenter(byDegree: CGFloat(trans.rotationAngle))
		}

		let maxStrokeWidth = self.strokeWidthForRefreshFrame

		let tpath = self.transformedCGPath(forTransform: trans, id: id, using: config)

		let strokePath = tpath.copy(strokingWithWidth: CGFloat(maxStrokeWidth), lineCap: .square, lineJoin: .miter, miterLimit: 10)
		var rect = strokePath.boundingBoxOfPath

		if hasEffects {
			let box = rect
			let txty = effects.getEffectsFrameTranslates(for: box)
			for (xy, radius) in txty {
				let dx = box.center.x - xy.x
				let dy = box.center.y - xy.y
				var shdwBox = box.offsetBy(dx: dx, dy: dy)
				shdwBox = shdwBox.enlargeBy(dx: CGFloat(radius), dy: CGFloat(radius))
				rect = rect.union(shdwBox)
			}
		}
		return rect
	}

	func setReflectionProps(reflectProps: inout Properties) {
		let offset = CGFloat(effects.reflection.distance.radius) + reflectionOffset
		var shapeframe = transform.rect
		shapeframe.center.y += offset
		reflectProps.frame = shapeframe
		reflectProps.effects.shadow.distance.angle = 360 - effects.shadow.distance.angle
		reflectProps.transform.rotationAngle = 360 - transform.rotationAngle
		reflectProps.alpha = 1 - effects.reflection.alpha.st

		reflectProps.transform.flipv.toggle()

		if !effects.hasShadow {
			reflectProps.effects.clearShadow()
		}
		reflectProps.effects.clearReflection()
	}
}

// MARK: - Reflection Helpers

extension Properties {
	var reflectionOffset: CGFloat {
		let theta = transform.rotationAngle
		let sinTheta = abs(CGFloat(sin(theta * (.pi / 180))))
		let cosTheta = abs(CGFloat(cos(theta * (.pi / 180))))
		let shapeframe = transform.rect
		return (shapeframe.width * sinTheta) + (shapeframe.height * cosTheta)
	}

	func drawReflection(
		in ctx: RenderingContext,
		gprops: Properties?,
		using config: PainterConfig?,
		forId id: String,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation) {
		var reflectProps = self

		let reflectedShapeId = "\(id)_reflectedShape"
		self.setReflectionProps(reflectProps: &reflectProps)

		let reflectionBbox = self.refreshFrame(
			gprops: gprops,
			id: id,
			using: config,
			matrix: matrix,
			toDrawReflection: true)

		ctx.cgContext.saveGState()
#if !os(watchOS)
		effects.reflection.draw(in: ctx, inside: reflectionBbox)
#endif
		reflectProps.draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			forId: reflectedShapeId,
			matrix: matrix,
			shapeOrientation: shapeOrientation)
		config?.cache?.removeRawGeomPathMap(for: reflectedShapeId)
		ctx.cgContext.restoreGState()
	}
}
