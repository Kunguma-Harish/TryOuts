//
//  ShapeGeometry+Path.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension ShapeGeometry {
	func shapePath(with stroke: Stroke? = nil, forRect rect: CGRect? = nil, isPattern: Bool = false) -> CGPath {
		var path: CGPath
		switch type {
		case .custom:
			path = isPattern ? custom.patternCgPath : custom.cgpath
		case .preset:
			path = preset.cgpath(frame: rect, stroke: stroke)
		default:
			assertionFailure("Yet to implement")
			path = custom.cgpath
		}
		return path
	}
}

public extension ShapeGeometry {
	var handleValues: [PresetShape.HandleValue] {
		return preset.handleValues
	}

	var presetModifiers: [CGFloat] {
		return preset.presetModifiers
	}

	func handles(frame: CGRect, stroke: Stroke) -> [CGPoint]? {
		return preset.handles(frame: frame, stroke: stroke)
	}

	func connectorPoints(frame: CGRect, stroke: Stroke) -> [[CGFloat]]? {
		return preset.connectorPoints(frame: frame, stroke: stroke)
	}

	func textFrame(frame: CGRect) -> CGRect {
		return preset.textFrame(frame: frame)
	}

	func getEllipseCoordinates(angle1: CGFloat, angle2: CGFloat, rx: CGFloat, ry: CGFloat, mid: CGPoint) -> [CGFloat] {
		return preset.getEllipseCoordinates(angle1: angle1, angle2: angle2, rx: rx, ry: ry, mid: mid)
	}
}
