//
//  GroupShape+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 15/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

//	NOTE: File Tips
//	1.	Both refresh frame and blur frame calculation are identical, except that refresh frame considers blur as well.
//		If refresh frame calculation is modified, make the same changes in blur frame calculation as well.

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject.GroupShape {
	var frame: CGRect {
		get {
			return props.transform.rect
		}
		set {
			props.transform.rect = newValue
		}
	}

	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		_ matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		shouldDrawShadowAsImage: Bool = true,
		crop: Offset? = nil,
		isMultiPathPreset: Bool = false) {
		let (mprops, currentMatrices) = self.getModifiedPropsAndMatrix(
			withGroupProps: gprops,
			using: config,
			matrix: matrix)

		ctx.cgContext.saveGState()

		if props.hasBlend {
			ctx.cgContext.setBlendMode(props.blend.mode)
		}

		ctx.cgContext.setAlpha(CGFloat(1.0 - props.alpha))
		ctx.cgContext.beginTransparencyLayer(auxiliaryInfo: nil) // Required for group shape opacity to work.

		if props.hasFill, props.fill.type != .grp, props.fill.type != .none {
			shapeOrientation.grpRect = self.props.transform.rect
			shapeOrientation.initialOrientationMatix = currentMatrices
		}

		if !shouldDrawShadowAsImage, props.hasEffects {
			self.drawEffects(
				in: ctx,
				withGroupProps: mprops,
				using: config,
				matrix: currentMatrices,
				shapeOrientation: shapeOrientation,
				crop: crop)
		}

		if hasMask {
			if !mask.isHidden {
				mask.draw(
					in: ctx,
					withGroupProps: mprops,
					using: config,
					parentId: nvOprops.nvDprops.id,
					matrix: currentMatrices,
					shapeOrientation: shapeOrientation)
			}
			if mask.type == .shape {
				if mask.shape.hasTextBody,
				   let editingTextID = ctx.editingTextID,
				   editingTextID == mask.shape.nvOprops.nvDprops.id {
					// Do not render the shape if its text is being edited.
				} else {
					mask.shape.props.applyMask(
						in: ctx,
						withGroupProps: mprops,
						forId: mask.shape.nvOprops.nvDprops.id,
						using: config,
						matrix: currentMatrices,
						usingTextBody: mask.shape.hasTextBody ? mask.shape.textBody : nil,
						usingGroupshape: nil)
				}
			} else if mask.type == .combinedobject {
				mask.combinedobject.props.applyMask(
					in: ctx,
					withGroupProps: mprops,
					forId: mask.shape.nvOprops.nvDprops.id,
					using: config,
					matrix: currentMatrices,
					usingTextBody: nil,
					usingGroupshape: nil)
			} else if mask.type == .groupshape {
				mask.groupshape.props.applyMask(
					in: ctx,
					withGroupProps: mprops,
					forId: mask.groupshape.nvOprops.nvDprops.id,
					using: config,
					matrix: currentMatrices,
					usingTextBody: nil,
					usingGroupshape: mask)
			} else {
				Debugger.debug("unsupported mask")
			}
		}

		if self.hasAdditionalFollowers {
			for shapeobject in self.additionalFollowers.shapesBeneath {
				ctx.cgContext.saveGState()
				shapeobject.draw(in: ctx, withGroupProps: mprops, using: config, parentId: nvOprops.nvDprops.id, matrix: currentMatrices, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
		}

		for shapeObject in shapes {
			ctx.cgContext.saveGState()
			let isMultiPath = !isMultiPathPreset ? shapeObject.isMultiPathPreset : isMultiPathPreset
			shapeObject.draw(
				in: ctx,
				withGroupProps: mprops,
				using: config,
				parentId: nvOprops.nvDprops.id,
				matrix: currentMatrices,
				shapeOrientation: shapeOrientation,
				crop: crop,
				isMultiPathPreset: isMultiPath)
			ctx.cgContext.restoreGState()
		}

		if self.hasAdditionalFollowers {
			for shapeobject in self.additionalFollowers.shapesOnTop {
				ctx.cgContext.saveGState()
				shapeobject.draw(in: ctx, withGroupProps: mprops, using: config, parentId: nvOprops.nvDprops.id, matrix: currentMatrices, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
		}

		ctx.cgContext.endTransparencyLayer()

		ctx.cgContext.restoreGState()
		if props.effects.hasReflection {
			self.drawReflection(
				in: ctx,
				withGroupProps: gprops,
				using: config,
				matrix: matrix,
				shapeOrientation: shapeOrientation,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage)
		}
	}

	func drawEffects(in ctx: RenderingContext, withGroupProps gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices, shapeOrientation: ShapeOrientation, crop: Offset? = nil) {
		if props.effects.hasShadow {
			if props.effects.shadow.type == .outer, !(props.effects.shadow.hasHidden && props.effects.shadow.hidden) {
				self.drawOuterShadow(props.effects.shadow, in: ctx, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation, crop: crop)
			}
		}

		if !props.effects.shadows.isEmpty {
			for shadow in props.effects.shadows where
				shadow.type == .outer && !(shadow.hasHidden && shadow.hidden) {
				drawOuterShadow(shadow, in: ctx, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation)
			}
		}
	}

	func drawReflection(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		shouldDrawShadowAsImage: Bool) {
		let groupShapeProps = self.props
		let groupShapeId = self.nvOprops.nvDprops.id
		let bBox = groupShapeProps.refreshFrame(
			gprops: gprops,
			id: groupShapeId,
			using: config,
			matrix: matrix,
			toDrawReflection: true)

		ctx.cgContext.saveGState()
#if !os(watchOS)
		self.props.effects.reflection.draw(in: ctx, inside: bBox)
#endif

		var reflectProps = groupShapeProps
		groupShapeProps.setReflectionProps(reflectProps: &reflectProps)

		let reflectedShapeId = "\(groupShapeId)_reflectedShape"
		var groupShape = self
		groupShape.props = reflectProps
		groupShape.nvOprops.nvDprops.id = reflectedShapeId

		groupShape.draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			matrix,
			shapeOrientation: shapeOrientation,
			shouldDrawShadowAsImage: shouldDrawShadowAsImage)
		config?.cache?.removeRawGeomPathMap(for: reflectedShapeId)
		ctx.cgContext.restoreGState()
	}

	func drawOuterShadow(
		_ shadow: Effects.Shadow,
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		crop: Offset? = nil) {
		let shadowoffset = shadow.getShadowOffset(for: self.frame, scale: ctx.scaleRatio, vflip: ctx.verticallyFlipShadow)
		let shadowBlur = CGFloat(shadow.blur.radius)
		//            let shadowPath: CGPath
		let shadowColor: CGColor

		// Scale requires path construction for the entire group
		//            if hasScale {
		//                shadowPath = path.enlargeBy(dx: CGFloat(scale.x), dy: CGFloat(scale.y))
		//            } else {
		//                shadowPath = path
		//            }

		if shadow.hasColor {
			shadowColor = shadow.color.cgColor
		} else {
			assertionFailure("no color for shadow, applying default shadow color")
			shadowColor = CGColor.black.copy(alpha: 1.0 / 3.0) ?? .black
		}

		ctx.cgContext.saveGState()
		ctx.cgContext.setShadow(offset: shadowoffset, blur: shadowBlur, color: shadowColor)

		// TODO: Using transparency layer is extremely slow. Find a way to optimize group shape shadows.
		ctx.cgContext.beginTransparencyLayer(auxiliaryInfo: nil)

		// Effects for children should be prevented when drawing group effects, else extra shadows will be drawn for children's shadow.
		// FIXME: below code
		//		let oldDrawEffects = config?.drawEffects
		//		config?.drawEffects = false

		if hasMask {
			if mask.type == .shape {
				if mask.shape.hasTextBody, let editingTextID = ctx.editingTextID, editingTextID == mask.shape.nvOprops.nvDprops.id {
					// Do not render the shape if its text is being edited.
				} else {
					mask.shape.draw(in: ctx, withGroupProps: gprops, using: config, matrix: matrix)
					mask.shape.props.applyMask(in: ctx, withGroupProps: gprops, forId: mask.shape.nvOprops.nvDprops.id, using: config, matrix: matrix, usingTextBody: mask.shape.hasTextBody ? mask.shape.textBody : nil, usingGroupshape: nil)
				}
			} else if mask.type == .combinedobject {
				mask.combinedobject.props.draw(in: ctx, withGroupProps: gprops, using: config, forId: mask.combinedobject.nvOprops.nvDprops.id, matrix: matrix)
				mask.combinedobject.props.applyMask(in: ctx, withGroupProps: gprops, forId: mask.shape.nvOprops.nvDprops.id, using: config, matrix: matrix, usingTextBody: nil, usingGroupshape: nil)
			} else if mask.type == .groupshape {
				mask.groupshape.draw(in: ctx, withGroupProps: gprops, using: config, matrix, shapeOrientation: shapeOrientation)
				mask.groupshape.props.applyMask(in: ctx, withGroupProps: gprops, forId: mask.groupshape.nvOprops.nvDprops.id, using: config, matrix: matrix, usingTextBody: nil, usingGroupshape: mask)
			} else {
				Debugger.debug("unsupported mask")
			}
		}

		if self.hasAdditionalFollowers {
			for shapeobject in self.additionalFollowers.shapesBeneath {
				ctx.cgContext.saveGState()
				shapeobject.draw(in: ctx, withGroupProps: gprops, using: config, parentId: nvOprops.nvDprops.id, matrix: matrix, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
		}
		for shapeobject in shapes {
			ctx.cgContext.saveGState()
			shapeobject.draw(in: ctx, withGroupProps: gprops, using: config, parentId: nvOprops.nvDprops.id, matrix: matrix, shapeOrientation: shapeOrientation, crop: crop)
			ctx.cgContext.restoreGState()
		}
		if self.hasAdditionalFollowers {
			for shapeobject in self.additionalFollowers.shapesOnTop {
				ctx.cgContext.saveGState()
				shapeobject.draw(in: ctx, withGroupProps: gprops, using: config, parentId: nvOprops.nvDprops.id, matrix: matrix, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
		}

		ctx.cgContext.endTransparencyLayer()
		ctx.cgContext.restoreGState()
	}

	func drawableContentFrame(
		_ config: PainterConfig?,
		matrix: OrientationMatrices = .identity,
		gprops: Properties? = nil) -> CGRect {
		return refreshFrame(
			parentId: nil,
			config: config,
			shouldCache: false,
			matrix: matrix,
			gprops: gprops)
	}

	func blurFrame(forTransform trans: Transform, using config: PainterConfig?) -> CGRect {
		var rect = CGRect.null
		if hasMask {
			if mask.type == .shape {
				let mtrans = mask.shape.props.transform.getModifiedTransform(group: trans, using: config)
				rect = rect.union(mask.shape.props.blurFrame(forTransform: mtrans, id: mask.shape.nvOprops.nvDprops.id, using: config))
			} else if mask.type == .combinedobject {
				let mtrans = mask.combinedobject.props.transform.getModifiedTransform(group: trans, using: config)
				rect = rect.union(mask.combinedobject.props.blurFrame(forTransform: mtrans, id: mask.id, using: config))
			} else {
				Debugger.debug("unsupported mask")
			}
		} else {
			if self.hasAdditionalFollowers {
				for shapeobject in self.additionalFollowers.shapesBeneath {
					let mtrans = shapeobject.props.transform.getModifiedTransform(group: trans, using: config)
					rect = rect.union(shapeobject.props.blurFrame(forTransform: mtrans, id: shapeobject.id, using: config))
				}
				for shapeobject in self.additionalFollowers.shapesOnTop {
					let mtrans = shapeobject.props.transform.getModifiedTransform(group: trans, using: config)
					rect = rect.union(shapeobject.props.blurFrame(forTransform: mtrans, id: shapeobject.id, using: config))
				}
			}
			for i in 0..<shapes.count {
				let mtrans = shapes[i].props.transform.getModifiedTransform(group: trans, using: config)
				rect = rect.union(shapes[i].props.blurFrame(forTransform: mtrans, id: shapes[i].id, using: config))
			}
		}
		rect = rect.rotateAtCenter(byDegree: CGFloat(trans.rotationAngle))
		if props.hasEffects {
			let box = rect
			let txty = props.effects.getEffectsFrameTranslates(for: box)
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

	//    Consider hidden property of child shapes
	//    var groupPath: CGPath {
	//        let groupPath = CGMutablePath()
	//        for shapeObj in shapes {
	//            switch shapeObj.type {
	//            case .shape, .picture, .connector, .combinedobject:
	//                groupPath.addPath(shapeObj.props.transformedCGPath)
	//            case .groupshape:
	//                groupPath.addPath(shapeObj.groupshape.groupPath)
	//            case .graphicframe, .paragraph:
	//                assert(false)
	//                break
	//            }
	//        }
	//        return groupPath
	//    }
	//
	//    func groupPath(for transform: Transform) -> CGPath {
	//        var groupPath = self.groupPath
	//        if let path = groupPath.transform(to: transform.rect).mutableCopy() {
	//            groupPath = path
	//        }
	//        if let path = groupPath.rotate(byDegree: CGFloat(transform.rotationAngle)).mutableCopy() {
	//            groupPath = path
	//        }
	//        if transform.fliph {
	//            groupPath = groupPath.horizontalFlip
	//        }
	//        if transform.flipv {
	//            groupPath = groupPath.verticalFlip
	//        }
	//        return groupPath
	//    }
}

public extension ShapeObject.GroupShape {
	func getCompleteGroupObject(_ config: PainterConfig?, withVisualTransform: Bool = true) -> ShapeObject.GroupShape {
		if self.hasCategory, self.category.type == .follower {
			if let groupObject = config?.cache?.getCompleteObjectDataMap(for: self.nvOprops.nvDprops.id, withVisualTransform: withVisualTransform) {
				return groupObject
			} else {
				if let groupObject = config?.getSmartObject(forShapeObject: self, withVisualTransform: withVisualTransform) {
					config?.cache?.setCompleteObjectDataMap(for: self.nvOprops.nvDprops.id, value: groupObject, withVisualTransform: withVisualTransform)
					return groupObject
				}
			}
		}
		var groupObject = self
		if self.hasCategory, let follower = config?.cache?.getOverridenDataMap(for: self.nvOprops.nvDprops.id) {
			return follower
		} else {
			if let follower = config?.getOverriddenValue(for: self) {
				groupObject = follower
			}
			config?.cache?.setOverridenDataMap(for: self.nvOprops.nvDprops.id, value: groupObject)
			return groupObject
		}
	}

	static func overrideText(followeShape: inout Shape, portions: [Portion]) {
		let followerPortions = followeShape.textBody.paras.flatMap { $0.portions }
		if portions.count == 1, portions[0].id == "" {
			self.overrideText(followeShape: &followeShape, text: [portions[0].t])
			return
		}
		var portions = portions
		if followerPortions.count == portions.count {
			for i in 0..<followeShape.textBody.paras.count {
				for j in 0..<followeShape.textBody.paras[i].portions.count {
					followeShape.textBody.paras[i].portions[j] = portions.removeFirst()
				}
			}
		}
	}
}

private extension ShapeObject.GroupShape {
	static func overrideText(followeShape: inout Shape, text: [String]) {
		func getTextString(from texts: [String]) -> [String] {
			var textsArray: [String] = []
			for text in texts {
				let text = text.components(separatedBy: " ")
				for i in 0..<text.count {
					textsArray.append(text[i])
					textsArray.append(" ")
				}
			}
			return textsArray
		}
		var followerTextArray = getTextString(from: text)
		var isFollowerTextFilled = false
		for i in 0..<followeShape.textBody.paras.count {
			if isFollowerTextFilled {
				break
			}
			for j in 0..<followeShape.textBody.paras[i].portions.count {
				if let first = followerTextArray.first {
					_ = followerTextArray.removeFirst()
					followeShape.textBody.paras[i].portions[j].t = first
				} else {
					followeShape.textBody.paras[i].portions.removeSubrange(j..<followeShape.textBody.paras[i].portions.count)
					followeShape.textBody.paras.removeSubrange(i + 1..<followeShape.textBody.paras.count)
					isFollowerTextFilled = true
					break
				}
				if i == followeShape.textBody.paras.count - 1, j == followeShape.textBody.paras[i].portions.count - 1 {
					followeShape.textBody.paras[i].portions[j].t += followerTextArray.joined()
				}
			}
		}
	}
}
