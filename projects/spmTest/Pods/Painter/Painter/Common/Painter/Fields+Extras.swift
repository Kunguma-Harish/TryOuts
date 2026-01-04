//
//  Fields+Extras.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 20/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension ShapeField.BlendMode {
	var mode: CGBlendMode {
		switch self {
		case .normal:
			return CGBlendMode.normal
		case .multiply:
			return CGBlendMode.multiply
		case .screen:
			return CGBlendMode.screen
		case .overlay:
			return CGBlendMode.overlay
		case .darken:
			return CGBlendMode.darken
		case .lighten:
			return CGBlendMode.lighten
		case .colorDodge:
			return CGBlendMode.colorDodge
		case .colorBurn:
			return CGBlendMode.colorBurn
		case .softLight:
			return CGBlendMode.softLight
		case .hardLight:
			return CGBlendMode.hardLight
		case .difference:
			return CGBlendMode.difference
		case .exclusion:
			return CGBlendMode.exclusion
		case .hue:
			return CGBlendMode.hue
		case .saturation:
			return CGBlendMode.saturation
		case .color:
			return CGBlendMode.color
		case .luminosity:
			return CGBlendMode.luminosity
		}
	}
}

public extension StrokeField.CapType {
	var cap: CGLineCap {
		switch self {
		case .flat:
			return CGLineCap.butt
		case .capround:
			return CGLineCap.round
		case .square:
			return CGLineCap.square
		case .defCapType:
			// use 'flat' type for now; handle appropriately in future
			return CGLineCap.butt
		}
	}
}

public extension StrokeField.JoinType {
	var join: CGLineJoin {
		switch self {
		case .round:
			return CGLineJoin.round
		case .bevel:
			return CGLineJoin.bevel
		case .miter:
			return CGLineJoin.miter
		case .defJoinType:
			// use 'round' for now; handle appropriately in future
			return CGLineJoin.round
		}
	}
}

public extension FillField.FillRule {
	var fillRule: CGPathFillRule {
		switch self {
		case .noRule, .evenOdd:
			return .evenOdd
		case .nonZero:
			return .winding
		}
	}
}
