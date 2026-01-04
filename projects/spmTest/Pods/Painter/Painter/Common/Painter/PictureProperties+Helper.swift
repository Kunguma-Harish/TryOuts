//
//  PictureProperties+Helper.swift
//  Painter
//
//  Created by karthikeyan gm on 25/04/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

// helps to create CIFilter instances
public enum HSB {
	case hue(angle: Float)
	case saturation(value: Float)
	case brightness(value: Float)

	public var filterName: String {
		switch self {
		case .hue:
			return "CIHueAdjust"
		case .saturation, .brightness:
			return "CIColorControls"
		}
	}

	public var parameters: [String: Any] {
		switch self {
		case let .hue(value):
			return ["inputAngle": value]
		case let .saturation(value):
			return ["inputSaturation": value]
		case let .brightness(value):
			return ["inputBrightness": value]
		}
	}
}

public extension PictureProperties {
	var brightness: Float {
		return luminance.brightness
	}

	var contrast: Float {
		return luminance.contrast
	}

	var saturation: Float {
		guard let tweak = hsl.saturation.first else {
			return 1
		}
		return tweak.value
	}

	var hue: Float {
		guard let tweak = hsl.hue.first else {
			return 0
		}
		return tweak.value
	}

	var hueTweak: Tweak? {
		return hsl.hue.first
	}

	var saturationTweak: Tweak? {
		return hsl.saturation.first
	}

	var luminanceTweak: Tweak? {
		return hsl.luminance.first
	}

	var hsbComponents: [HSB] {
		return [
			.hue(angle: self.hue),
			.saturation(value: self.saturation),
			.brightness(value: self.brightness)
		]
	}
}
