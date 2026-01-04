//
//  Picture+DrawHelpers.swift
//  Painter
//
//  Created by Sarath Kumar G on 29/08/23.
//  Copyright © 2023 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension Proto.Picture {
	func drawPictureWithFill(
		in ctx: RenderingContext,
		from image: CGImage?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		gprops: Properties?) {
		guard let image = image else {
			return
		}
		if self.hasPictureProps, self.pictureProps.hasAlpha {
			ctx.cgContext.setAlpha(CGFloat(1.0 - self.pictureProps.alpha))
		}
		ctx.cgContext.saveGState()
		var scaledTranslatedRect = self.props.transform.rect.applying(matrix.scaleAndTranslateMatrix)
		if self.hasCrop {
			scaledTranslatedRect = self.crop.actualShapeFrame(from: scaledTranslatedRect)
		}
		let rotationConsolidated = matrix.rotationAndFlipMatrix
		ctx.cgContext.concatenate(rotationConsolidated)
		self.crop(ctx, with: matrix, using: config)

		// CG draws image in vertical flip by default so compensating with that
		let flipTransform = Transform.with {
			$0.rect = scaledTranslatedRect
			$0.flipv = true
		}
		flipTransform.applyFlip(on: ctx)

		let picturePropsFlipTransform = Transform.with { transform in
			transform.rect = scaledTranslatedRect
			if hasPictureProps {
				if pictureProps.hasFliph {
					transform.fliph = pictureProps.fliph
				}
				if pictureProps.hasFlipv {
					transform.flipv = pictureProps.flipv
				}
			}
		}
		picturePropsFlipTransform.applyFlip(on: ctx)

		let clipFrame = ctx.cgContext.boundingBoxOfClipPath
		let portionOnImage = clipFrame.intersection(scaledTranslatedRect)
		if portionOnImage.isValid {
			ctx.cgContext.clip(to: portionOnImage)
			ctx.cgContext.draw(image, in: scaledTranslatedRect)
		}

		// Drawing fill over the image hides the image completely if the fill doesn't have any alpha.
		// Applying fill for an image is not supported in Show as of now
		// But if a placeholder shape in a layout has a solid fill and an image is being inserted into that placeholder in slide, the picture object will have fill when we merge the picture object with the placeholder it follows

		/* if self.props.hasFill, !self.props.fill.hidden {
		     self.drawPictureWithFill(
		         self.props.fill,
		         in: ctx,
		         using: config,
		         matrix: matrix,
		         gprops: gprops,
		         scaledTranslatedRect: scaledTranslatedRect)
		 }

		 for fill in self.props.fills where !fill.hidden {
		     drawPictureWithFill(
		         fill,
		         in: ctx,
		         using: config,
		         matrix: matrix,
		         gprops: gprops,
		         scaledTranslatedRect: scaledTranslatedRect)
		 } */

		ctx.cgContext.restoreGState() // Restoring state that was saved for image clipping.
	}
}
