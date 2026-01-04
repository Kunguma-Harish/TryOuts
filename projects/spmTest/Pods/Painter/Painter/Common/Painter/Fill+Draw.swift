//
//  Fill+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Fill {
	// Caller should properly save the graphics state of cgcontext before calling fill draw method
	func draw(
		in ctx: RenderingContext,
		within rect: CGRect,
		withGroupFill groupFill: Fill? = nil,
		using config: PainterConfig? = nil,
		forId id: String? = nil,
		shapeTrans: [Transform]? = nil,
		shapeOrientation: ShapeOrientation = ShapeOrientation(),
		crop: Offset? = nil,
		isPictureObject: Bool = false) {
		if hasBlend {
			ctx.cgContext.setBlendMode(blend.mode)
		}
		var passThrough = true
		if self.alpha != 0, self.type != .solid {
			passThrough = false
			ctx.cgContext.setAlpha(CGFloat(1 - self.alpha))
		}

		if !passThrough {
			let clipbox = ctx.cgContext.boundingBoxOfClipPath
			ctx.cgContext.beginTransparencyLayer(in: clipbox, auxiliaryInfo: nil)
		}
		switch type {
		case .none, .textbox:
			ctx.cgContext.beginPath() // old path needs to be thrown away
		case .gradient:
			ctx.cgContext.saveGState()
			gradient.draw(in: ctx, within: rect, using: hasRule ? rule.fillRule : .evenOdd, shapeOrientation: shapeOrientation)
			ctx.cgContext.restoreGState()
		case .grp:
			if let groupFill = groupFill {
				groupFill.draw(in: ctx, within: rect, using: config, forId: id, shapeOrientation: shapeOrientation, crop: crop)
			} else {
				ctx.cgContext.beginPath()
			}
		case .pict:
			ctx.cgContext.saveGState()
			pict.draw(in: ctx, within: rect, forId: id, using: config, shapeOrientation: shapeOrientation, with: hasRule ? rule.fillRule : .evenOdd, crop: crop, isPictureObject: isPictureObject)
			ctx.cgContext.restoreGState()
		case .pattern:
			pattern.draw(in: ctx, within: rect, using: config, with: shapeTrans, shapeOrientation: shapeOrientation)
		case .solid:
			solid.draw(in: ctx, using: hasRule ? rule.fillRule : .evenOdd)
		case .defFill:
			// Not being used for now; handle appropriately in future
			break
		}
		if !passThrough {
			ctx.cgContext.endTransparencyLayer()
		}
	}
}

// MARK: Solid Fill

private extension SolidFill {
	func draw(in ctx: RenderingContext, using fillRule: CGPathFillRule) {
		ctx.cgContext.setFillColor(color.cgColor)
		ctx.cgContext.fillPath(using: fillRule)
	}
}

// MARK: Picture Fill

public struct PictureFillImageData {
	/// Interpolated and extrapolated image from original image to current context parameters
	public var optimalMipImage: CGImage
	/// Ratio of size of modified image to original image.
	public let sizeRatio: CGSize

	public init(optimalMipImage: CGImage, sizeRatio: CGSize) {
		self.optimalMipImage = optimalMipImage
		self.sizeRatio = sizeRatio
	}
}

private extension PictureFill {
	func draw(
		in ctx: RenderingContext,
		within rect: CGRect,
		forId id: String? = nil,
		using config: PainterConfig? = nil,
		shapeOrientation: ShapeOrientation,
		with rule: CGPathFillRule,
		crop: Offset? = nil,
		isPictureObject: Bool = false) {
		let finalOrientationMatrix: OrientationMatrices

		if let initialOrientationMatix = shapeOrientation.initialOrientationMatix {
			finalOrientationMatrix = initialOrientationMatix
		} else {
			finalOrientationMatrix = shapeOrientation.finalOrientationMatrix
		}

		let uncroppedpictureBbox = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
		var pictureBbox = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
		if let cropInfo = crop {
			pictureBbox = cropInfo.actualShapeFrame(from: pictureBbox)
		}
		guard var cgImageInfo = config?.getPicture(from: self, forId: id, size: pictureBbox.size, level: ctx.zoomFactor) else {
			ctx.cgContext.beginPath()
			return
		}

		if self.hasProps,
		   self.props.hasHsl ||
		   self.props.luminance.hasBrightness,
		   let filteredImage = config?.getFilteredImage(picture: self.value, picprops: self.props, for: ctx.cgContext.boundingBoxOfClipPath, size: uncroppedpictureBbox.size, level: ctx.zoomFactor) {
			cgImageInfo.optimalMipImage = filteredImage
		}

		if self.hasProps, self.props.hasAlpha {
			ctx.cgContext.setAlpha(CGFloat(1.0 - self.props.alpha))
		}

		ctx.cgContext.concatenate(finalOrientationMatrix.rotationAndFlipMatrix)
		if isPictureObject {
			self.verticallyFlip(ctx, with: rect)
		}
		self.drawImage(cgImageInfo, in: ctx, within: pictureBbox, with: rule)
	}

	func drawImage(
		_ imageInfo: PictureFillImageData,
		in ctx: RenderingContext,
		within rect: CGRect? = nil,
		with rule: CGPathFillRule) {
		var cropFrame: CGRect
		guard let path = ctx.cgContext.path else {
			assertionFailure("Can't get path from RenderingContext")
			return
		}

		let imageSize = CGSize(width: imageInfo.optimalMipImage.width, height: imageInfo.optimalMipImage.height)
		if let rect = rect {
			cropFrame = rect
		} else {
			cropFrame = path.boundingBoxOfPath
		}

		if hasType {
			cropFrame = type.croppedFrame(for: cropFrame, imageSize: imageSize, ratio: imageInfo.sizeRatio)
		}

		// By default, CG draws vertically flipped image
		// To compensate that, flip context vertically before drawing image
		ctx.cgContext.saveGState()
		if let rect = rect {
			self.verticallyFlip(ctx, with: rect)
		} else {
			self.verticallyFlip(ctx, with: path.boundingBoxOfPath)
		}
		// ctx.cgContext.clip() // Clips context to path added to it
		ctx.cgContext.clip(using: rule)
		ctx.cgContext.draw(imageInfo.optimalMipImage, in: cropFrame, byTiling: type.type == .tile)
		ctx.cgContext.restoreGState()
	}

	func verticallyFlip(_ ctx: RenderingContext, with frame: CGRect) {
		ctx.cgContext.translateBy(x: frame.origin.x, y: frame.origin.y)
		ctx.cgContext.translateBy(x: 0, y: frame.size.height)
		ctx.cgContext.scaleBy(x: 1, y: -1)
		ctx.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
	}
}

public extension PictureFill.PictureFillType {
	func croppedFrame(for rect: CGRect, imageSize size: CGSize, ratio: CGSize) -> CGRect {
		var croppedFrame = rect
		if hasType {
			switch type {
			case .frame:
				croppedFrame = frame.offsetFrame(for: rect)
			case .tile:
				croppedFrame = tile.tileFrame(for: rect, imageSize: size, ratio: ratio)
			case .fit:
				croppedFrame = frame.offsetframeforfit(for: rect, imageSize: size)
			case .fill:
				croppedFrame = frame.offsetframeforfill(for: rect, imageSize: size)
			}
		}
		return croppedFrame
	}
}

private extension Offset {
	func offsetFrame(for frame: CGRect) -> CGRect {
		let x = frame.origin.x + frame.size.width * CGFloat(left)
		let y = frame.origin.y + (frame.size.height * CGFloat(bottom)) // For vertically flipped context
		let width = frame.size.width * CGFloat(1 - (right + left))
		let height = frame.size.height * CGFloat(1 - (bottom + top))

		return CGRect(x: x, y: y, width: width, height: height)
	}

	func offsetframeforfit(for frame: CGRect, imageSize size: CGSize) -> CGRect {
		var x = frame.origin.x + frame.size.width * CGFloat(left)
		var y = frame.origin.y + (frame.size.height * CGFloat(bottom)) // For vertically flipped context
		let Imageratio = size.width / size.height
		var landscape_image = false
		if Imageratio > 1 {
			landscape_image = true
		}
		let frameratio = frame.width / frame.height
		var landscape_frame = false
		if frameratio > 1 {
			landscape_frame = true
		}
		var height = frame.height
		var width = frame.width
		if landscape_frame {
			if landscape_image {
				if frameratio > Imageratio {
					height = frame.height
					width = height * Imageratio
					x += (frame.width - width) / 2
				} else {
					width = frame.width
					height = width / Imageratio
					y += (frame.height - height) / 2
				}
			} else {
				height = frame.height
				width = height * Imageratio
				x += (frame.width - width) / 2
			}
		} else {
			if landscape_image {
				width = frame.width
				height = width / Imageratio
				y += (frame.height - height) / 2
			} else {
				if frameratio > Imageratio {
					height = frame.height
					width = height * Imageratio
					x += (frame.width - width) / 2
				} else {
					width = frame.width
					height = width / Imageratio
					y += (frame.height - height) / 2
				}
			}
		}
		//			height *= CGFloat(1 - (bottom + top))
		//			width *= CGFloat(1 - (right + left))
		return CGRect(x: x, y: y, width: width, height: height)
	}

	func offsetframeforfill(for frame: CGRect, imageSize size: CGSize) -> CGRect {
		let ImageRatio = size.width / size.height
		let frameRatio = frame.width / frame.height
		var x = frame.origin.x + frame.size.width * CGFloat(left)
		var y = frame.origin.y + (frame.size.height * CGFloat(bottom)) // For vertically flipped context
		var height = frame.height
		var width = frame.width
		if frameRatio < ImageRatio {
			height = frame.height
			width = frame.height * ImageRatio
			let diff_width = (width - frame.width)
			x -= (diff_width / 2)
		} else if frameRatio > ImageRatio {
			width = frame.width
			height = frame.width / ImageRatio
			let diff_height = (height - frame.height)
			y -= (diff_height / 2)
		}
		return CGRect(x: x, y: y, width: width, height: height)
	}
}

private extension PictureFill.PictureFillType.Tile {
	func tileFrame(for rect: CGRect, imageSize size: CGSize, ratio: CGSize) -> CGRect {
		let x = rect.origin.x + CGFloat(hasOffsetX ? offsetX : 0)
		let y = rect.origin.y + rect.height - CGFloat(hasOffsetY ? offsetY : 0)
		let scaleX = CGFloat(hasScale && scale.hasX ? scale.x : 1)
		let scaleY = CGFloat(hasScale && scale.hasY ? scale.y : 1)
		let width = size.width * (scaleX / ratio.width)
		let height = size.height * (scaleY / ratio.height)
		return CGRect(x: x, y: y, width: width, height: height)
	}
}

// MARK: Pattern Fill

private extension PatternFill {
	func draw(
		in ctx: RenderingContext,
		within rect: CGRect,
		using config: PainterConfig?,
		with shapeTrans: [Transform]? = nil,
		shapeOrientation: ShapeOrientation) {
		guard let clipPath = ctx.cgContext.path else {
			assertionFailure("Can't get clip path for pattern fill")
			return
		}
		if background.hasType {
			switch background.type {
			case .none:
				ctx.cgContext.beginPath() // old path needs to be thrown away
			case .solid:
				background.solid.draw(in: ctx, using: .evenOdd)
			case .gradient:
				ctx.cgContext.saveGState()
				background.gradient.draw(in: ctx, within: rect, using: .evenOdd, shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			case .pict:
				background.pict.draw(in: ctx, within: rect, forId: background.pict.value.id, using: config, shapeOrientation: shapeOrientation, with: .evenOdd)
			default:
				assertionFailure("Invalid background Fill value for pattern fill")
				return
			}
		}
		ctx.cgContext.addPath(clipPath)
		ctx.cgContext.clip(using: .evenOdd)

		let patternData = hasPreset ? PatternFill.getDefaultPatternFill(for: preset) : nil
		let distanceBetweenShapes = (hasDistance ? distance : patternData?.distance) ?? distance
		let rotateVal = (hasRotate ? rotate : patternData?.rotate) ?? rotate
		for (index, foreGround) in foreground.enumerated() {
			var foreGroundData = foreGround
			if let patternData = patternData, patternData.foreground.count > index {
				do {
					try foreGroundData.merge(serializedData: patternData.foreground[index].serializedData(partial: true), partial: true)
				} catch {
					Debugger.debug("Error in merging foreground data")
				}
			}
			foreGroundData.draw(
				in: ctx,
				with: PatternDetails(rotate: CGFloat(rotateVal), size: distanceBetweenShapes.size, preset: preset),
				within: rect,
				on: clipPath,
				using: config,
				with: shapeTrans,
				shapeOrientation: shapeOrientation)
		}
	}
}

class PatternProps {
	var path: CGPath
	var color: CGColor
	var strokeWidth: CGFloat

	init(path: CGPath, color: CGColor, strokeWidth: CGFloat) {
		self.path = path
		self.color = color
		self.strokeWidth = strokeWidth
	}
}

private struct PatternDetails {
	var rotate: CGFloat
	var size: CGSize
	var preset: String
}

private extension PatternFill.ForegroundShape {
	var strokeWidth: CGFloat {
		if self.geom.preset.type == .line {
			return 1
		} else {
			return -1
		}
	}

	var cgpath: CGPath {
		let transform = Transform.with {
			$0.dim = dim
			$0.pos = Position.with {
				$0.left = 0
				$0.top = 0
			}
		}
		let stroke = Stroke.with {
			$0.type = .solid
			$0.captype = .flat
			$0.jointype = .round
			$0.width = 1
		}

		var patternPath = geom.patternCgPath(rect: transform.rect, stroke: stroke)
		var pathTrans = CGAffineTransform.identity.scaledBy(x: CGFloat(dim.width), y: CGFloat(dim.height))

		if geom.type == .custom {
			if let transformedPath = patternPath.copy(using: &pathTrans) {
				patternPath = transformedPath
			}
		}
		return patternPath
	}

	var drawPatternCallback: CGPatternDrawPatternCallback {
		return { info, ctx in
			if let patternInfo = info {
				let patternProps: PatternProps = Unmanaged.fromOpaque(patternInfo).takeUnretainedValue()
				ctx.saveGState()
				ctx.addPath(patternProps.path)

				if patternProps.strokeWidth != -1 {
					ctx.setLineWidth(patternProps.strokeWidth)
					ctx.setStrokeColor(patternProps.color)
					ctx.strokePath()
				} else {
					ctx.setFillColor(patternProps.color)
					ctx.fillPath()
				}
				ctx.restoreGState()
			}
		}
	}

	// swiftlint:disable function_parameter_count
	func draw(
		in ctx: RenderingContext,
		with details: PatternDetails,
		within rect: CGRect,
		on clipPath: CGPath,
		using config: PainterConfig?,
		with shapeTrans: [Transform]?,
		shapeOrientation: ShapeOrientation) {
		ctx.cgContext.saveGState()
		self.setPatternColorSpace(to: ctx)

		var callbacks = CGPatternCallbacks(version: 0, drawPattern: drawPatternCallback, releaseInfo: nil)
		let patternRect = CGRect(origin: .zero, size: details.size)
//		apply(shapeTrans, to: ctx)

		// Negating initial transform since it is not needed for Pattern Fill
		var rect = rect
		var ctxTransform = CGAffineTransform.identity

		var finalOrientationMatrix = OrientationMatrices()
		if let initialOrientationMatix = shapeOrientation.initialOrientationMatix {
			finalOrientationMatrix = initialOrientationMatix
		} else {
			finalOrientationMatrix = shapeOrientation.finalOrientationMatrix
		}
		rect = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
		ctxTransform = ctxTransform.concatenating(finalOrientationMatrix.rotationAndFlipMatrix)

		var patternTransform = ctxTransform.translatedBy(x: rect.origin.x, y: rect.origin.y)
		patternTransform = patternTransform.rotated(by: details.rotate * CGFloat(Double.pi) / 180.0)

		// TODO: check if initialTransform is always set (even for startwith also)
		let initialTransform = ctx.initialTransform
		let ctxCTM = ctx.cgContext.ctm.concatenating(initialTransform.inverted())
		patternTransform = patternTransform.concatenating(ctxCTM)

		let patternProps = PatternProps(
			path: cgpath,
			color: fill.solid.color.cgColor,
			strokeWidth: self.strokeWidth)
		let unmanagedPatternProps = Unmanaged.passRetained(patternProps).toOpaque()

		let pattern = CGPattern(
			info: unmanagedPatternProps,
			bounds: patternRect,
			matrix: patternTransform,
			xStep: details.size.width,
			yStep: details.size.height,
			tiling: .constantSpacing,
			isColored: true,
			callbacks: &callbacks)
//		restore(ctx, from: shapeTrans)

		if let pattern = pattern {
			var alpha: CGFloat = 1
			ctx.cgContext.setFillPattern(pattern, colorComponents: &alpha)
		}
		ctx.cgContext.fill(clipPath.boundingBoxOfPath)
		ctx.cgContext.restoreGState()
	}

	// swiftlint:enable function_parameter_count

	func setPatternColorSpace(to ctx: RenderingContext) {
		if let colorSpace = CGColorSpace(patternBaseSpace: nil) {
			ctx.cgContext.setFillColorSpace(colorSpace)
		}
	}

	func apply(_ shapeTrans: [Transform]?, to ctx: RenderingContext) {
		if let shapeTrans = shapeTrans {
			for i in 1..<shapeTrans.count {
				ctx.cgContext.saveGState()
				shapeTrans[i].applyRotateAndFlip(on: ctx)
			}
		}
	}

	func restore(_ ctx: RenderingContext, from shapeTrans: [Transform]?) {
		if let shapeTrans = shapeTrans {
			for _ in 1..<shapeTrans.count {
				ctx.cgContext.restoreGState()
			}
		}
	}
}

extension PatternFill.DistanceBetweenShapes {
	var size: CGSize {
		return CGSize(width: Double(left), height: Double(top))
	}
}

extension Fill {
	var deviceColor: DeviceColor? {
		var color: DeviceColor?
		guard self.hasType else {
			return color
		}
		switch self.type {
		case .solid:
			if self.hasSolid, self.solid.hasColor {
				color = self.solid.color.platformColor
			}
		case .pattern:
			if self.hasPattern,
			   let foreground = self.pattern.foreground.first,
			   foreground.hasFill {
				color = foreground.fill.deviceColor
			}
		default:
			break
		}
		return color
	}
}

extension PatternFill.FillValue {
	var deviceColor: DeviceColor? {
		var color: DeviceColor?
		guard self.hasType else {
			return color
		}
		switch self.type {
		case .solid:
			if self.hasSolid, self.solid.hasColor {
				color = self.solid.color.platformColor
			}
		default:
			break
		}
		return color
	}
}
