//
//  Picture+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 11/12/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Proto.Picture {
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
		matrix: OrientationMatrices,
		shouldDrawShadowAsImage: Bool = true) {
		let currentMatrix = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
		var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
			.concatenating(currentMatrix.rotationAndFlipMatrix)

		let scaledSize = self.crop.actualShapeFrame(from: self.props.transform.rect).size
			.applying(currentMatrix.scaleAndTranslateMatrix)

		guard
			var image = config?.getPicture(
				picture: self,
				for: ctx.cgContext.boundingBoxOfClipPath,
				size: scaledSize,
				level: ctx.zoomFactor)
		else {
			return
		}

		if self.hasPictureProps,
		   self.pictureProps.hasHsl,
		   let filteredImage = config?.getFilteredImage(picture: self.value, picprops: self.pictureProps, for: ctx.cgContext.boundingBoxOfClipPath, size: scaledSize, level: ctx.zoomFactor) {
			image = filteredImage
		}

		if self.props.hasBlend, self.props.blend != .normal {
			ctx.cgContext.setBlendMode(self.props.blend.mode)
		}

		if self.props.alpha != 0 {
			ctx.cgContext.setAlpha(CGFloat(1.0 - self.props.alpha))
		}

		let shapeId = self.nvOprops.nvDprops.id
		let rawPath = self.props.rawCGPath(forTransform: self.props.transform, id: shapeId, using: config)

		let path = rawPath.copy(using: &consolidatedMatrix) ?? rawPath

		self.drawPictureFillAndStroke(
			in: ctx,
			from: image,
			using: config,
			withGroupProps: gprops,
			picturePath: path,
			currentMatrix: currentMatrix)

		self.drawEffects(
			in: ctx,
			using: config,
			shouldDrawShadowAsImage: shouldDrawShadowAsImage) { shadowCtx in
				self.drawPictureFillAndStroke(
					in: shadowCtx,
					from: image,
					using: config,
					withGroupProps: gprops,
					picturePath: path,
					currentMatrix: currentMatrix)
			}

		if self.props.hasEffects, self.props.effects.hasReflection {
			self.drawPictureReflection(
				in: ctx,
				from: image,
				withGroupProps: gprops,
				using: config,
				matrix: matrix,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage)
		}
	}

	func drawableContentFrame(
		config: PainterConfig?,
		matrix: OrientationMatrices = .identity,
		gprops: Properties? = nil) -> CGRect {
		return self.refreshFrame(
			parentId: nil,
			config: config,
			shouldCache: false,
			matrix: matrix,
			gprops: gprops)
	}
}

// MARK: - Picture with Fill Draw Helpers

extension Proto.Picture {
	func drawPictureWithFill(
		_ fill: Fill,
		in ctx: RenderingContext,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		gprops: Properties?,
		scaledTranslatedRect: CGRect) {
		let fillImage: CGImage
		var imageFill = fill
		imageFill.clearBlend()
		if let currentFillImage = config?.getFillImage(
			for: self.nvOprops.nvDprops.id,
			hashValue: imageFill.hashValue,
			level: ctx.zoomFactor,
			size: scaledTranslatedRect.size) {
			fillImage = currentFillImage
		} else {
			let currentMatrix = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
			let scaledSize = self.crop.actualShapeFrame(from: self.props.transform.rect).size
				.applying(currentMatrix.scaleAndTranslateMatrix)
			guard let bitmapConst = config?.shadowBitmapConstants, let originalImage = config?.getPicture(
				picture: self,
				for: ctx.cgContext.boundingBoxOfClipPath,
				size: scaledSize,
				level: 1),
				let imageContext = CGContext(
					data: nil,
					width: originalImage.width,
					height: originalImage.height,
					bitsPerComponent: bitmapConst.bitsPerComponent,
					bytesPerRow: 0,
					space: bitmapConst.colorSpace,
					bitmapInfo: bitmapConst.bitmapInfo.rawValue) else {
				return
			}
			let renderingContext = RenderingContext(ctx: imageContext)
			let newRect = CGRect(origin: .zero, size: CGSize(width: originalImage.width, height: originalImage.height))
			imageContext.draw(originalImage, in: newRect)
			imageContext.saveGState()
			imageContext.setBlendMode(.sourceIn)
			imageContext.addRect(newRect)
			imageFill.draw(in: renderingContext, within: newRect, withGroupFill: nil, using: config, forId: self.nvOprops.nvDprops.id, shapeTrans: nil, isPictureObject: true)
			imageContext.restoreGState()
			guard let currentFillImage = imageContext.makeImage() else {
				return
			}
			config?.setFillImage(
				for: self.nvOprops.nvDprops.id,
				hashValue: imageFill.hashValue,
				image: currentFillImage)
			fillImage = currentFillImage
		}
		ctx.cgContext.setBlendMode(fill.blend.mode)
		ctx.cgContext.draw(fillImage, in: scaledTranslatedRect)
	}

	func crop(_ ctx: RenderingContext, with matrix: OrientationMatrices, using config: PainterConfig?) {
		var clipPath: CGPath
		if self.props.hasGeom {
			let shapeId = nvOprops.nvDprops.id
			clipPath = self.props.rawCGPath(forTransform: self.props.transform, id: shapeId, using: config)
			var scaleMatrix = matrix.scaleAndTranslateMatrix
			if let path = clipPath.copy(using: &scaleMatrix) {
				clipPath = path
			}
		} else {
			clipPath = CGPath(
				rect: self.props.transform.rect.applying(matrix.scaleAndTranslateMatrix), transform: nil)
		}
		self.props.clip(ctx, with: clipPath)
	}
}

// MARK: - Picture Draw Helpers

private extension Proto.Picture {
	func drawPictureFillAndStroke(
		in ctx: RenderingContext,
		from image: CGImage?,
		using config: PainterConfig?,
		withGroupProps gprops: Properties?,
		picturePath path: CGPath,
		currentMatrix: OrientationMatrices) {
		self.drawPictureWithFill(
			in: ctx,
			from: image,
			using: config,
			matrix: currentMatrix,
			gprops: gprops)
		self.drawPictureStroke(
			in: ctx,
			on: path,
			within: self.props.transform.rect,
			withGroupProps: gprops,
			using: config)
	}

	func drawPictureStroke(
		in ctx: RenderingContext,
		on path: CGPath,
		within rect: CGRect,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?) {
		var fillRemovedProps = self.props
		fillRemovedProps.clearFill()
		fillRemovedProps.fills.removeAll()
		fillRemovedProps.drawFillAndStroke(
			in: ctx,
			on: path,
			within: self.props.transform.rect,
			withGroupProps: gprops,
			isMultipathPreset: false,
			using: config,
			forId: self.nvOprops.nvDprops.id)
	}

	func drawEffects(
		in ctx: RenderingContext,
		using config: PainterConfig?,
		shouldDrawShadowAsImage: Bool,
		drawPictureFillStrokeBlock: @escaping ((RenderingContext) -> Void)) {
		// Shadow
		if self.props.hasEffects {
			self.props.effects.drawPictureShadow(
				of: self,
				in: ctx,
				for: self.props.transform.rect,
				using: config,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage,
				drawPictureFillStrokeBlock: drawPictureFillStrokeBlock)
		}
	}

	func drawPictureReflection(
		in ctx: RenderingContext,
		from image: CGImage?,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shouldDrawShadowAsImage: Bool) {
		let shapeProps = self.props
		let pictureId = self.nvOprops.nvDprops.id
		let bBox = shapeProps.refreshFrame(
			gprops: gprops,
			id: pictureId,
			using: config,
			matrix: matrix,
			toDrawReflection: true)

		ctx.cgContext.saveGState()
#if !os(watchOS)
		shapeProps.effects.reflection.draw(in: ctx, inside: bBox)
#endif

		var picture = self
		let reflectedPictureId = "\(pictureId)_reflectedPicture"
		picture.nvOprops.nvDprops.id = reflectedPictureId

		var reflectProps = shapeProps
		shapeProps.setReflectionProps(reflectProps: &reflectProps)
		picture.props = reflectProps

		picture.draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			matrix: matrix,
			shouldDrawShadowAsImage: shouldDrawShadowAsImage)
		config?.cache?.removeRawGeomPathMap(for: reflectedPictureId)
		ctx.cgContext.restoreGState()
	}
}

// MARK: - Effects Draw Helpers

private extension Effects {
	func drawPictureShadow(
		of picture: Proto.Picture,
		in ctx: RenderingContext,
		for frame: CGRect,
		using config: PainterConfig?,
		shouldDrawShadowAsImage: Bool,
		drawPictureFillStrokeBlock: @escaping ((RenderingContext) -> Void)) {
		if shouldDrawShadowAsImage {
			return
		}
		if self.hasShadow {
			self.shadow.drawPictureShadow(
				of: picture,
				in: ctx,
				for: frame,
				using: config,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage,
				drawPictureFillStrokeBlock: drawPictureFillStrokeBlock)
		}
		for shadow in self.shadows {
			shadow.drawPictureShadow(
				of: picture,
				in: ctx,
				for: frame,
				using: config,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage,
				drawPictureFillStrokeBlock: drawPictureFillStrokeBlock)
		}
	}
}

// MARK: - Picture Shadow Draw Helpers

private extension Effects.Shadow {
	func drawPictureShadow(
		of picture: Proto.Picture,
		in ctx: RenderingContext,
		for frame: CGRect,
		using config: PainterConfig?,
		shouldDrawShadowAsImage: Bool,
		drawPictureFillStrokeBlock: @escaping ((RenderingContext) -> Void)) {
		if self.type == .outer, !shouldDrawShadowAsImage {
			self.drawOuter(
				in: ctx,
				for: frame,
				drawPictureFillStrokeBlock: drawPictureFillStrokeBlock)
		} else if self.type == .inner {
			self.drawInner(in: ctx, for: frame, picture: picture, using: config)
		}
	}

	func drawInner(
		in ctx: RenderingContext,
		for frame: CGRect,
		picture: Proto.Picture,
		using config: PainterConfig?) {
		//			self.drawInner(in: ctx, for: frame, with: clippath, using: config){
		// TODO: Inner shadow for image
		if !(hasHidden && hidden) {
			var path: CGPath
			let shapeId = picture.nvOprops.nvDprops.id
			path = picture.props.rawCGPath(id: shapeId, using: config)
			self.drawInner(in: ctx, for: frame, with: path, using: config)
		}
	}

	func drawOuter(
		in ctx: RenderingContext,
		for frame: CGRect,
		drawPictureFillStrokeBlock: @escaping ((RenderingContext) -> Void)) {
		if self.type == .outer {
			if !(self.hasHidden && self.hidden) {
				let shadowoffset = self.getShadowOffset(for: frame, scale: ctx.scaleRatio, vflip: ctx.verticallyFlipShadow)
				let shadowBlur = CGFloat(self.blur.radius)

				// MARK: Unused

				//			let shadowPath = hasScale ? path.enlargeBy(dx: CGFloat(scale.x), dy: CGFloat(scale.y)) : path
				let shadowColor: CGColor
				if self.hasColor {
					shadowColor = self.color.cgColor
				} else {
					assertionFailure("no color for shadow, applying default shadow color")
					shadowColor = CGColor.black.copy(alpha: 1.0 / 3.0) ?? .black
				}

				ctx.cgContext.saveGState()
				ctx.cgContext.setShadow(offset: shadowoffset, blur: shadowBlur, color: shadowColor)
				// TODO: Check for blend mode
				ctx.cgContext.setBlendMode(CGBlendMode.normal)

				// TODO: The following code for shadow is extremely slow with the use of transparency layer. Find out an effective way to draw shadows.
				ctx.cgContext.beginTransparencyLayer(auxiliaryInfo: nil)

				drawPictureFillStrokeBlock(ctx)

				ctx.cgContext.endTransparencyLayer()
				ctx.cgContext.restoreGState()
			}
		}
	}
}

// MARK: - Actual shape frame from crop frame

public extension Offset {
	func actualShapeFrame(from cropFrame: CGRect) -> CGRect {
		let actualWidth = cropFrame.width / (1 - CGFloat(self.left + self.right))
		let actualHeight = cropFrame.height / (1 - CGFloat(self.top + self.bottom))

		let x = cropFrame.origin.x - (CGFloat(self.left) * actualWidth)
		let y = cropFrame.origin.y - (CGFloat(self.top) * actualHeight)
		return CGRect(x: x, y: y, width: actualWidth, height: actualHeight)
	}
}
