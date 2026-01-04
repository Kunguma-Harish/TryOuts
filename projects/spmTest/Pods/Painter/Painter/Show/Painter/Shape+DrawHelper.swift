//
//  Shape+DrawHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Shape {
	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig? = nil,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation = ShapeOrientation(),
		shouldDrawShadowAsImage: Bool = false,
		crop: Offset? = nil,
		isMultiPathPresetShape: Bool = false) {
		if isMultiPathPreset {
			drawMultiPathPreset(
				in: ctx,
				withGroupProps: gprops,
				config: config,
				matrix: matrix,
				shapeOrientation: shapeOrientation,
				crop: crop)
			return
		}

		props.draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			forId: nvOprops.nvDprops.id,
			matrix: matrix,
			shapeOrientation: shapeOrientation,
			shouldDrawShadowAsImage: shouldDrawShadowAsImage,
			crop: crop,
			isMultiPathPreset: isMultiPathPresetShape)

		if hasTextBody, ctx.editingTextID != self.nvOprops.nvDprops.id {
			self.drawTextBody(
				in: ctx,
				withGroupProps: gprops,
				using: config,
				matrix: matrix,
				shouldDrawShadowAsImage: shouldDrawShadowAsImage)
		}
	}

	func textPathBbox(for bBox: CGRect) -> CGRect {
		if self.props.geom.type == .custom {
			return bBox
		}
		var flipMatrix = self.props.transform.getFlipMatrix(rect: bBox)
		let textPath = CGPath(rect: self.props.geom.preset.pathInfo(frame: bBox).textFrame, transform: &flipMatrix)
		let finalTextFrame = textPath.boundingBoxOfPath
		return self.getFlippedTextBox(for: finalTextFrame)
	}

	func drawTextBody(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shouldDrawShadowAsImage: Bool = false) {
		let currentMatrix = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)

		ctx.cgContext.saveGState()
		applyRotateAndFlip(to: ctx, matrix: matrix, gprops: gprops)

		if props.hasBlend {
			ctx.cgContext.setBlendMode(props.blend.mode)
		}
		ctx.cgContext.setAlpha(CGFloat(1.0 - props.alpha))

		let bBox = self.props.transform.rect.applying(currentMatrix.scaleAndTranslateMatrix)

		if let config = config, !shouldDrawShadowAsImage, props.hasEffects {
			if props.effects.hasShadow, !(props.effects.shadow.hasHidden && props.effects.shadow.hidden) {
				if props.effects.shadow.type == .outer {
					ctx.cgContext.saveGState()
					props.effects.shadow.setShadow(on: ctx, within: props.transform.rect, using: config)
					drawPlainText(in: ctx, within: bBox, using: config)
					ctx.cgContext.restoreGState()
				}
			}

			for shadow in props.effects.shadows where !(shadow.hasHidden && shadow.hidden) && shadow.type == .outer {
				ctx.cgContext.saveGState()
				shadow.setShadow(on: ctx, within: props.transform.rect, using: config)
				drawPlainText(in: ctx, within: bBox, using: config)
				ctx.cgContext.restoreGState()
			}
		}

		drawPlainText(in: ctx, within: bBox, using: config)
		ctx.cgContext.restoreGState()
	}
}

extension Shape {
	func applyRotateAndFlip(to ctx: RenderingContext, matrix: OrientationMatrices, gprops: Properties?) {
		var propsCopy = self.props // Text won't be flipped; only the shapes will get flipped
		propsCopy.transform.fliph = false
		propsCopy.transform.flipv = false
		let currentMatrix = propsCopy.transform.getMatrix(matrix, gTrans: gprops?.transform)
		let rotationConsolidated = currentMatrix.rotationAndFlipMatrix
		ctx.cgContext.concatenate(rotationConsolidated)
	}

	func drawPlainText(
		in ctx: RenderingContext,
		within bBox: CGRect,
		using config: PainterConfig?) {
		let rect = self.textPathBbox(for: bBox)
		ctx.cgContext.saveGState()
		textBody.draw(
			inside: rect,
			forId: self.nvOprops.nvDprops.id,
			using: config)
		ctx.cgContext.restoreGState()
	}
}

private extension Shape {
	func getFlippedTextBox(for bBox: CGRect) -> CGRect {
		return textBody.getSmartTextBbox(for: bBox)
	}
}
