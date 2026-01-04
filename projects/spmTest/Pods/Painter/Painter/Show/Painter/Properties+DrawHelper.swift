//
//  Properties+DrawHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Properties {
	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		forId id: String,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation = ShapeOrientation(),
		shouldDrawShadowAsImage: Bool = false,
		crop: Offset? = nil,
		isMultiPathPreset: Bool = false) {
		// modify the transform according to group transform
		// TODO: - check whether its a good candidate for caching
		let currentMatrix = self.transform.getMatrix(matrix, gTrans: gprops?.transform)
		let rawPath = rawCGPath(forTransform: self.transform, id: id, using: config, isMultiPathPreset: isMultiPathPreset)

		var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
			.concatenating(currentMatrix.rotationAndFlipMatrix)
		shapeOrientation.finalOrientationMatrix = currentMatrix

		guard let path = rawPath.copy(using: &consolidatedMatrix) else {
			assertionFailure()
			return
		}

		ctx.cgContext.saveGState()

		if hasBlend {
			ctx.cgContext.setBlendMode(blend.mode)
		}
		ctx.cgContext.setAlpha(CGFloat(1.0 - alpha))

		if !shouldDrawShadowAsImage, hasEffects {
			effects.drawOuter(
				in: ctx,
				for: transform.rect,
				with: path,
				fills: shadowFills,
				strokes: shadowStrokes,
				transform: self.transform,
				using: config,
				forId: id,
				shapeOrientation: shapeOrientation,
				crop: crop)
		}
		drawFillAndStroke(
			in: ctx,
			on: path,
			within: self.transform.rect,
			withGroupProps: gprops,
			isMultipathPreset: false,
			using: config,
			forId: id,
			shapeOrientation: shapeOrientation,
			crop: crop)

		if hasEffects {
			effects.drawInner(in: ctx, for: transform.rect, with: path, using: config)
			if effects.hasReflection {
				drawReflection(
					in: ctx,
					gprops: gprops,
					using: config,
					forId: id,
					matrix: matrix,
					shapeOrientation: shapeOrientation)
			}
		}
		ctx.cgContext.restoreGState()
	}

	func applyMask(in ctx: RenderingContext, withGroupProps gprops: Properties?, forId id: String, using config: PainterConfig?, matrix: OrientationMatrices, usingTextBody textBody: TextBody?, usingGroupshape groupshape: ShapeObject?) {
		let currentMatrix = self.transform.getMatrix(matrix, gTrans: gprops?.transform)
		let rawPath = self.rawCGPath(forTransform: self.transform, id: id, using: config)

		var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
			.concatenating(currentMatrix.rotationAndFlipMatrix)
		guard let path = rawPath.copy(using: &consolidatedMatrix) else {
			assertionFailure()
			return
		}
		let fillRule = self.fills.first?.rule.fillRule ?? .winding
		ctx.cgContext.addPath(path)
		ctx.cgContext.clip(using: fillRule)
	}

	func getNewTransformBasedOnCustomPath(
		for trans: Transform,
		isMultiPathPreset: Bool = false) -> Transform {
		guard
			self.hasGeom,
			self.geom.type == .custom,
			self.geom.hasCustom,
			!self.geom.custom.pathList.isEmpty,
			isMultiPathPreset == false
		else {
			return trans
		}
		var newTransform = trans
		let customPath = self.geom.custom.pathList[0]
		let rawCGPathRect = CGRect(x: 0, y: 0, width: CGFloat(customPath.width), height: CGFloat(customPath.height))
		let transformPathRect = self.geom.custom.cgpath.boundingBoxOfPath
		var scaleX: CGFloat = 1
		if rawCGPathRect.width != 0, transformPathRect.width != 0 {
			scaleX = transformPathRect.width / rawCGPathRect.width
		}
		var scaleY: CGFloat = 1
		if rawCGPathRect.height != 0, transformPathRect.height != 0 {
			scaleY = transformPathRect.height / rawCGPathRect.height
		}
		let affineTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
		let scaledTransformedRect = self.transform.rect.applying(affineTransform)
		let scaledPath = self.geom.custom.cgpath.scaled(for: scaledTransformedRect)
		let pathRect = scaledPath.boundingBoxOfPath

		if !((roundf(Float(pathRect.size.width)) == roundf(Float(trans.rect.size.width))) && (roundf(Float(pathRect.size.height)) == roundf(Float(trans.rect.size.height)))) {
			if !((roundf(Float(pathRect.origin.x)) == roundf(Float(trans.rect.origin.x))) && (roundf(Float(pathRect.origin.y)) == roundf(Float(trans.rect.origin.y)))) {
				newTransform = Transform()
				newTransform.pos.left = Float(pathRect.origin.x) + trans.pos.left
				newTransform.pos.top = Float(pathRect.origin.y) + trans.pos.top
				newTransform.dim.width = Float(pathRect.size.width)
				newTransform.dim.height = Float(pathRect.size.height)
			}
		}
		return newTransform
	}
}
