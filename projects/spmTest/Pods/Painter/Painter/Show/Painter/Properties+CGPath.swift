//
//  Properties+CGPath.swift
//  Painter
//
//  Created by Sarath Kumar G on 25/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension Properties {
	func getTransformedCGPath(forId id: String, with trans: Transform, using config: PainterConfig?, isMultiPathPreset: Bool = false) -> CGPath {
		var path: CGPath
		if geom.type == .preset {
			path = geom.cgpath(id: id, stroke: hasStroke ? stroke : strokes.first, frame: trans.rect, config: config)
		} else if geom.type == .custom {
			let newTransform = self.getNewTransformBasedOnCustomPath(for: trans, isMultiPathPreset: isMultiPathPreset)
			path = geom.cgpath(id: id, stroke: hasStroke ? stroke : strokes.first, frame: newTransform.rect, config: config)
//			if canApplyTransform(to: path) {
			let (scalingTrans, translationTrans, _) = path.affineTransform(to: newTransform.rect)
			var modifiedCustomGeom = geom.custom.applying(scalingTrans)
			modifiedCustomGeom = modifiedCustomGeom.applying(translationTrans)
			path = modifiedCustomGeom.cgpath
//			}
		} else {
			assertionFailure()
			path = geom.cgpath(id: id, stroke: hasStroke ? stroke : nil, frame: trans.rect, config: config)
		}
		return path
	}

	func getTransformedCGPathWithoutRadius(forId id: String, with trans: Transform, using config: PainterConfig?) -> CGPath {
		return self.getTransformedCGPath(forId: id, with: trans, using: config)
	}

	func canApplyTransform(to path: CGPath) -> Bool {
		if geom.custom.pathList.count == 1 {
			let pathBbox = path.boundingBoxOfPath.integral
			let customWidth = CGFloat(round(geom.custom.pathList[0].width))
			let customHeight = CGFloat(round(geom.custom.pathList[0].height))
			let delta: CGFloat = 5
			let widthCheck = (customWidth - delta)...(customWidth + delta) ~= pathBbox.width
			let heightCheck = (customHeight - delta)...(customHeight + delta) ~= pathBbox.height
			return widthCheck && heightCheck
		}
		return true
	}
}
