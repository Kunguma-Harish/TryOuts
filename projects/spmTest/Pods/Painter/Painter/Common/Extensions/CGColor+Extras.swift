//
//  CGColor+Extras.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 13/12/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public extension CGColor {
	class var white: CGColor {
		return UIColor.white.cgColor
	}

	class var black: CGColor {
		return UIColor.black.cgColor
	}

	class var clear: CGColor {
		return UIColor.clear.cgColor
	}
}
#endif

extension CGColor {
	struct RGBA {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0

		init(color: CGColor) {
			if let components = color.components, !components.isEmpty, components.count < 5 {
				if components.count == 2 {
					self.red = components[0]
					self.green = components[0]
					self.blue = components[0]
					self.alpha = components[1]
				} else if components.count == 3 {
					self.red = components[0]
					self.green = components[1]
					self.blue = components[2]
				} else {
					self.red = components[0]
					self.green = components[1]
					self.blue = components[2]
					self.alpha = components[3]
				}
			}
		}
	}

	var rgba: RGBA {
		return RGBA(color: self)
	}

	class func lerp(from: RGBA, to: RGBA, percent: CGFloat) -> CGColor {
		let red = from.red + percent * (to.red - from.red)
		let green = from.green + percent * (to.green - from.green)
		let blue = from.blue + percent * (to.blue - from.blue)
		let alpha = from.alpha + percent * (to.alpha - from.alpha)

		let colorspace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
		var values = [red, green, blue, alpha]
		let cgColor = CGColor(colorSpace: colorspace, components: &values) ?? .black
		return cgColor
	}

	public var color: Color {
		var color = Color()
		if let rgba = self.components {
			color.type = .custom
			if rgba.count == 2 {
				color.rgb = [Int32(rgba[0] * 255), Int32(rgba[0] * 255), Int32(rgba[0] * 255)]
				let hsb = ColorConversion.rgbToHsb(rgb: [Float(rgba[0]), Float(rgba[0]), Float(rgba[0]), Float(rgba[1])])
				color.colorModelRep = .hsb
				color.hsb.hue = hsb[0]
				color.hsb.saturation = hsb[1]
				color.hsb.brightness = hsb[2]
				color.tweaks.alpha = Float(1.0 - rgba[1])
			} else {
				color.rgb = [Int32(rgba[0] * 255), Int32(rgba[1] * 255), Int32(rgba[2] * 255)]
				let hsb = ColorConversion.rgbToHsb(rgb: [Float(rgba[0]), Float(rgba[1]), Float(rgba[2]), Float(rgba[3])])
				color.colorModelRep = .hsb
				color.hsb.hue = hsb[0]
				color.hsb.saturation = hsb[1]
				color.hsb.brightness = hsb[2]
				color.tweaks.alpha = Float(1.0 - rgba[3])
			}
		} else {
			assertionFailure("cannot create color")
		}
		return color
	}
}
