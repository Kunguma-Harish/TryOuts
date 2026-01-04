//
//  Color+CGColor.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

public typealias DeviceColor = UIColor
#else
import AppKit

public typealias DeviceColor = NSColor
#endif

private var defaultColor = DeviceColor.black

public extension Color {
#if os(iOS) || os(tvOS) || os(watchOS)
	var cgColor: CGColor {
		if colorModelRep == .hsb {
			let alpha = CGFloat(1.0 - tweaks.alpha)
			return UIColor(hue: CGFloat(hsb.hue), saturation: CGFloat(hsb.saturation), brightness: CGFloat(hsb.brightness), alpha: alpha).cgColor
		} else if rgb.count >= 3 {
			let alpha = tweaks.alpha
			let colorspace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
			var values = [CGFloat(rgb[0]) / 255.0, CGFloat(rgb[1]) / 255.0, CGFloat(rgb[2]) / 255.0, CGFloat(1.0 - alpha)]
			return CGColor(colorSpace: colorspace, components: &values) ?? .black
		} else {
			assertionFailure("unknown color")
			return .black
		}
	}

	var platformColor: DeviceColor {
		if colorModelRep == .hsb {
			let alpha = CGFloat(1.0 - tweaks.alpha)
			return DeviceColor(hue: CGFloat(hsb.hue), saturation: CGFloat(hsb.saturation), brightness: CGFloat(hsb.brightness), alpha: alpha)
		} else if rgb.count >= 3 {
			let values = [CGFloat(rgb[0]) / 255.0, CGFloat(rgb[1]) / 255.0, CGFloat(rgb[2]) / 255.0, CGFloat(1.0 - tweaks.alpha)]
			return DeviceColor(red: values[0], green: values[1], blue: values[2], alpha: values[3])
		}
		assertionFailure("unknown color")
		return DeviceColor.black
	}

#else
	var cgColor: CGColor {
		if colorModelRep == .hsb {
			let alpha = CGFloat(1.0 - tweaks.alpha)
			let colorspace: CGColorSpace = CGDisplayCopyColorSpace(CGMainDisplayID())
			var color = NSColor(deviceHue: CGFloat(hsb.hue), saturation: CGFloat(hsb.saturation), brightness: CGFloat(hsb.brightness), alpha: alpha)
			if let nsColorSpace = NSColorSpace(cgColorSpace: colorspace) {
				color = NSColor(
					colorSpace: nsColorSpace,
					hue: CGFloat(hsb.hue),
					saturation: CGFloat(hsb.saturation),
					brightness: CGFloat(hsb.brightness),
					alpha: alpha)
			}
			return color.cgColor
		} else if rgb.count >= 3 {
			let colorspace: CGColorSpace = CGDisplayCopyColorSpace(CGMainDisplayID())
			var values = [CGFloat(rgb[0]) / 255.0, CGFloat(rgb[1]) / 255.0, CGFloat(rgb[2]) / 255.0, CGFloat(1.0 - tweaks.alpha)]
			return CGColor(colorSpace: colorspace, components: &values) ?? .black
		} else {
			assertionFailure("unknown color")
			return .black
		}
	}

	var platformColor: DeviceColor {
		if colorModelRep == .hsb {
			let alpha = CGFloat(1.0 - tweaks.alpha)
			let colorspace: CGColorSpace = CGDisplayCopyColorSpace(CGMainDisplayID())
			var color = NSColor(deviceHue: CGFloat(hsb.hue), saturation: CGFloat(hsb.saturation), brightness: CGFloat(hsb.brightness), alpha: alpha)

			if let nsColorSpace = NSColorSpace(cgColorSpace: colorspace) {
				color = NSColor(
					colorSpace: nsColorSpace,
					hue: CGFloat(hsb.hue),
					saturation: CGFloat(hsb.saturation),
					brightness: CGFloat(hsb.brightness),
					alpha: alpha)
			}
			return color
		} else if rgb.count >= 3 {
			let values = [CGFloat(rgb[0]) / 255.0, CGFloat(rgb[1]) / 255.0, CGFloat(rgb[2]) / 255.0, CGFloat(1.0 - tweaks.alpha)]
			return DeviceColor(red: values[0], green: values[1], blue: values[2], alpha: values[3])
		}
		assertionFailure("unknown color")
		return .black
	}
#endif

	var cgColorWithSRGB: CGColor {
		if rgb.count >= 3 {
			guard let colorspace = CGColorSpace(name: CGColorSpace.sRGB) else {
				assertionFailure("Can't create sRGB colorspace")
				return .black
			}
			var values = [CGFloat(rgb[0]) / 255.0, CGFloat(rgb[1]) / 255.0, CGFloat(rgb[2]) / 255.0, CGFloat(1.0 - tweaks.alpha)]
			return CGColor(colorSpace: colorspace, components: &values) ?? .black
		} else {
			assertionFailure("unknown color")
			return .black
		}
	}

	func getHSBArray() -> [Float] {
		var hsb: [Float] = []
		if self.colorModelRep == .hsb {
			hsb.append(self.hsb.hue)
			hsb.append(self.hsb.saturation)
			hsb.append(self.hsb.brightness)
			hsb.append(1.0 - self.tweaks.alpha)
		} else if self.rgb.count == 3 {
			let div: Float = 255.0
			let rgb: [Float] = [Float(self.rgb[0]) / div, Float(self.rgb[1]) / div, Float(self.rgb[2]) / div, Float(1.0 - self.tweaks.alpha)]
			let hsbColor = ColorConversion.rgbToHsb(rgb: rgb)
			hsb.append(contentsOf: hsbColor)
		}
		return hsb
	}
}

// Utility
// https://gist.github.com/mjackson/5311256

public enum ColorConversion {
	public static func rgbToHsb(rgb: [Float]) -> [Float] {
		let r = rgb[0]
		let g = rgb[1]
		let b = rgb[2]
		let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
		let max = r > g ? (r > b ? r : b) : (g > b ? g : b)

		let v = max
		let delta = max - min

		guard delta > 0.000_01 else {
			return [0, 0, max, rgb[3]]
		}
		guard max > 0 else {
			return [-1, 0, v, rgb[3]]
		} // Undefined, achromatic grey
		let s = delta / max

		let hue: (Float, Float) -> Float = { max, delta -> Float in
			if r == max {
				return (g - b) / delta
			} // between yellow & magenta
			else if g == max {
				return 2 + (b - r) / delta
			} // between cyan & yellow
			else {
				return 4 + (r - g) / delta
			} // between magenta & cyan
		}

		let h = hue(max, delta) * 60 // In degrees

		return [(h < 0 ? h + 360 : h) / 360.0, s, v, rgb[3]]
	}

	public static func hsbToRgb(hsl: [Float]) -> [Float] {
		//		Reference: https://www.rapidtables.com/convert/color/hsv-to-rgb.html
		let h = hsl[0] * 360.0
		let s = hsl[1]
		let v = hsl[2]

		let c = v * s
		let x = c * (1 - abs((h / 60).truncatingRemainder(dividingBy: 2) - 1))
		let m = v - c
		var r: Float = 0
		var g: Float = 0
		var b: Float = 0
		if h >= 0, h < 60 {
			r = c; g = x; b = 0
		} else if h >= 60, h < 120 {
			r = x; g = c; b = 0
		} else if h >= 120, h < 180 {
			r = 0; g = c; b = x
		} else if h >= 180, h < 240 {
			r = 0; g = x; b = c
		} else if h >= 240, h < 300 {
			r = x; g = 0; b = c
		} else {
			r = c; g = 0; b = x
		}
		r += m
		g += m
		b += m
		let rgb: [Float] = [r, g, b]
		return rgb + [hsl[3]]
	}

	public static func convertHSLValueToNSColor(hslArray: [Float]) -> DeviceColor {
		return DeviceColor(hue: CGFloat(hslArray[0]), saturation: CGFloat(hslArray[1]), brightness: CGFloat(hslArray[2]), alpha: CGFloat(hslArray[3]))
	}

	public static func convertHSLValueToCGColor(hslArray: [Float]) -> CGColor {
		return self.convertHSLValueToNSColor(hslArray: hslArray).cgColor
	}

	public static func convertRGBValueToNSColor(rgbArray: [Float]) -> DeviceColor {
		return DeviceColor(hue: CGFloat(rgbArray[0]), saturation: CGFloat(rgbArray[1]), brightness: CGFloat(rgbArray[2]), alpha: CGFloat(rgbArray[3]))
	}

#if os(macOS)
	public static func convertNSColorToHSB(color: DeviceColor) -> [Float] {
		let h = Float(color.hueComponent)
		let s = Float(color.saturationComponent)
		let b = Float(color.brightnessComponent)
		let a = Float(color.alphaComponent)
		return [h, s, b, a]
	}

#else
	public static func convertUIColorToHSB(color: UIColor) -> [Float] {
		var (h, s): (CGFloat, CGFloat) = (0, 0)
		var (b, a): (CGFloat, CGFloat) = (0, 0)
		color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
		return [h, s, b, a].compactMap { Float($0) }
	}
#endif
}
