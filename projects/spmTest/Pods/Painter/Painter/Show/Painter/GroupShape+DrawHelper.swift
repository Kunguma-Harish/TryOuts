//
//  GroupShape+DrawHelper.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeObject.GroupShape {
	var isSmartGroupShape: Bool {
		return (hasNvOprops &&
			nvOprops.hasNvOdprops &&
			nvOprops.nvOdprops.hasIsSmartElement)
			? nvOprops.nvOdprops.isSmartElement : false
	}

	func drawGroupFill(
		in ctx: RenderingContext,
		with gprops: Properties,
		using config: PainterConfig?,
		applying transArr: (rect: CGRect, rotationMatrix: CGAffineTransform),
		matrix: OrientationMatrices,
		isMultiPath: Bool) {
		for shape in shapes {
			var shapeObject = shape
			if shape.isMultiPathPreset {
				shapeObject = shape.props.getMultiPathGroupShape(gprops: gprops)
//				shapeObject = shape.props.multipathGroupShape
			}
			if shapeObject.hasGroupshape {
				let groupProps = shapeObject.groupshape.props.getModifiedProps(
					from: gprops, using: config)
				let currentMatrices = shapeObject.props.transform.getMatrix(
					matrix, gTrans: self.props.transform)
				shapeObject.groupshape.drawGroupFill(
					in: ctx,
					with: groupProps,
					using: config,
					applying: transArr,
					matrix: currentMatrices,
					isMultiPath: isMultiPath)
			} else {
				if self.props.hasFill {
					let currentMatrix = shapeObject.props.transform.getMatrix(
						matrix, gTrans: gprops.transform)
					let rawPath = shapeObject.props.rawCGPath(
						forTransform: shapeObject.props.transform,
						id: shapeObject.id,
						using: config,
						isMultiPathPreset: isMultiPath)
					var consolidatedMatrix = currentMatrix.scaleAndTranslateMatrix
						.concatenating(currentMatrix.rotationAndFlipMatrix)

					guard let path = rawPath.copy(using: &consolidatedMatrix) else {
						assertionFailure()
						return
					}
					ctx.cgContext.saveGState()
					ctx.cgContext.addPath(path)
					self.props.fill.draw(
						in: ctx,
						within: transArr.rect,
						withGroupFill: gprops.fill,
						using: config,
						forId: self.nvOprops.nvDprops.id)
					ctx.cgContext.restoreGState()
				}
			}
		}
	}
}

public extension ShapeObject.GroupShape {
	func getModifiedPropsAndMatrix(
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices) -> (Properties, OrientationMatrices) {
		let mprops = self.props.getModifiedProps(from: gprops, using: config)
		let currentMatrices = self.props.transform.getMatrix(matrix, gTrans: gprops?.transform)
		return (mprops, currentMatrices)
	}
}
