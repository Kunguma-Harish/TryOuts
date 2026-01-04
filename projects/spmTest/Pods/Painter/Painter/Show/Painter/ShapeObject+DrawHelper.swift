//
//  ShapeObject+DrawHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject {
	var hasEmbed: Bool {
		return self.nvProps?.hasEmbed ?? false
	}

	var isExternalEmbed: Bool {
		guard
			let nvProps = self.nvProps,
			nvProps.hasEmbed,
			nvProps.embed.hasType,
			nvProps.embed.type == .external
		else {
			return false
		}
		return nvProps.embed.hasTwitter || nvProps.embed.hasCode
	}

	func getCompleteShapeObject(
		_ config: PainterConfig?,
		gProps: Properties? = nil,
		shouldConvertMultipath: Bool = true,
		withVisualTransform: Bool = true) -> ShapeObject {
		var shapeObject = self
		if shouldConvertMultipath, self.isMultiPathPreset {
			return self.shape.props.getMultiPathGroupShape(gprops: gProps)
		}
		if isMultiPathCropShape {
			return self.getShapeObjectForMultiPathCropShape()
		}
		if self.type == .groupshape {
			shapeObject.groupshape = self.groupshape.getCompleteGroupObject(config)
		}
		if let so = config?.getMergedProps(for: shapeObject) {
			shapeObject = so
		}
		return shapeObject
	}

	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig? = nil,
		parentId: String? = nil,
		matrix: OrientationMatrices = .identity,
		shapeOrientation: ShapeOrientation = ShapeOrientation(),
		crop: Offset? = nil,
		isMultiPathPreset: Bool = false) {
		var completeShapeObject = self.getCompleteShapeObject(config, gProps: gprops, shouldConvertMultipath: false)
//		var shapeClipBox = CGRect.zero
//		if self.isMultiPathPreset {
		//            shapeClipBox = completeShapeObject.props.getMultiPathGroupShape(gprops: gprops)
//				.refreshFrame(parentId: nil, shouldCache: true, config: config, matrix: matrix, gprops: gprops)
		//        } else if self.isMultiPathCropShape {
		//            shapeClipBox = completeShapeObject.getShapeObjectForMultiPathCropShape().refreshFrame(parentId: nil, shouldCache: true, config: config, matrix: matrix, gprops: gprops)
		//        } else {
		//            shapeClipBox = completeShapeObject.refreshFrame(parentId: nil, shouldCache: true, config: config, matrix: matrix, gprops: gprops)
		//        }
//		 let ctxClipBox = ctx.cgContext.boundingBoxOfClipPath
//
//		 clip to a smaller size to improve transparancy layer performance
//		 let clipBox = shapeClipBox.intersection(ctxClipBox)

		ctx.cgContext.saveGState()

		// MARK: Enable this for 'Show' once refresh frame computation for shadow is fixed

//		if gtrans == nil {
//				ctx.cgContext.clip(to: clipBox)
//		}
		let isMultiPath = isMultiPathPreset == false ? completeShapeObject.isMultiPathPreset : isMultiPathPreset
#if os(watchOS)
		completeShapeObject.drawWithoutBlur(in: ctx, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation, isMultiPathPreset: isMultiPath)
#else
		if completeShapeObject.props.hasBlur, completeShapeObject.props.blur.blurValue != 0, !unsupportedBlur {
			completeShapeObject.drawWithBlur(in: ctx, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation, isMultiPathPreset: isMultiPath)
		} else {
			completeShapeObject.drawWithoutBlur(in: ctx, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation, drawShadow: true, crop: crop, isMultiPathPreset: isMultiPath)
		}
#endif
		ctx.cgContext.restoreGState()
	}

	// TODO: Should set crop property also
	func getShapeObjectForMultiPathCropShape() -> ShapeObject {
		var newShape = self
		newShape.type = .shape
		newShape.shape.nvOprops.nvDprops = self.picture.nvOprops.nvDprops
		newShape.shape.nvOprops.nvProps = self.picture.nvOprops.nvProps
		newShape.props = self.picture.props
		newShape.props.fill.type = .pict
		newShape.props.fill.pict.value = self.picture.value
		newShape.shape.props.fill.pict.props = self.picture.pictureProps
		return newShape
	}
}

extension ShapeObject {
	func drawWithoutBlur(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		drawShadow: Bool = false,
		crop: Offset? = nil,
		isMultiPathPreset: Bool = false) {
		let shouldDrawShadowAsImage = false
		if !isHidden {
			switch type {
			case .shape:
				var cropInfo = crop
				if hasPicture, self.isMultiPathPreset {
					cropInfo = picture.crop
				}
				shape.draw(
					in: ctx,
					withGroupProps: gprops,
					using: config,
					matrix: matrix,
					shapeOrientation: shapeOrientation,
					shouldDrawShadowAsImage: shouldDrawShadowAsImage,
					crop: cropInfo,
					isMultiPathPresetShape: isMultiPathPreset)
			case .picture:
				picture.draw(
					in: ctx,
					withGroupProps: gprops,
					using: config,
					matrix: matrix,
					shouldDrawShadowAsImage: shouldDrawShadowAsImage)
			case .connector:
				connector.draw(
					in: ctx,
					withGroupProps: gprops,
					using: config,
					matrix: matrix,
					shapeOrientation: shapeOrientation,
					shouldDrawShadowAsImage: shouldDrawShadowAsImage)
			case .groupshape:
				groupshape.draw(
					in: ctx,
					withGroupProps: gprops,
					using: config,
					matrix,
					shapeOrientation: shapeOrientation,
					shouldDrawShadowAsImage: shouldDrawShadowAsImage,
					crop: crop,
					isMultiPathPreset: isMultiPathPreset)
			case .graphicframe:
				graphicframe.draw(in: ctx, withGroupProps: gprops, using: config)
			case .paragraph:
				assertionFailure("para is not drawable yet")
			case .combinedobject:
				combinedobject.draw(
					in: ctx,
					withGroupProps: gprops,
					using: config,
					matrix: matrix,
					shouldDrawShadowAsImage: shouldDrawShadowAsImage)
			}
		}
	}
}
