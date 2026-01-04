//
//  Color+ColorTweaks.swift
//  Painter
//
//  Created by Sarath Kumar G on 22/07/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Color {
	mutating func applyTweaks(_ customTweaks: ColorTweaks? = nil) {
		guard let colorTweaks = (customTweaks != nil) ? customTweaks : tweaks else {
			return
		}
		if !rgb.isEmpty, rgb.count <= 3 {
			var customRGB = rgb.compactMap { Float($0) }
			colorTweaks.setTweaks(for: &customRGB)
			rgb = customRGB.compactMap { Int32($0) }

			if customRGB[0] == 149.0, customRGB[1] == 54.0, customRGB[2] == 53.0 {
				rgb[1] = 55
			}
		}
	}
}

extension ColorTweaks {
	/// Recomputes RGB values based on 'ColorTweaks' (Tint, Shade and HSL)
	func setTweaks(for rgb: inout [Float]) {
		if hasTint {
			setTint(for: &rgb)
		}
		if hasHsl {
			hsl.setHSL(for: &rgb)
		}
		if hasShade {
			setShade(for: &rgb)
		}
	}
}

private extension ColorTweaks {
	/// Recompute RGB values based on 'Tint' value from ColorTweaks
	func setTint(for rgb: inout [Float]) {
		var rgbTweak = RGBTweak()

		// TODO: Investigate on 'rgb' which is RGBTweak() object
		// It isn't used anywhere in computation as of now. Check with web app JS code

		rgbTweak.setRGBTweaks(for: tint, ofType: "tint") // prepare 'rgbTweak' based on 'tint' value
		rgbTweak.setRGB(for: &rgb) // Recompute RGB values
	}

	/// Recompute RGB values based on 'Shade' value from ColorTweaks
	func setShade(for rgb: inout [Float]) {
		var rgbTweak = RGBTweak()
		let tintValue = Float(limit(value: CGFloat(shade), minValue: 0, maxValue: 1))

		rgbTweak.setRGBTweaks(for: tintValue, ofType: "shade")
		rgbTweak.setRGB(for: &rgb)
	}
}

private extension RGBTweak {
	/// Prepare RGBTweak object based on incoming tweak type (i.e. shade or tint)
	mutating func setRGBTweaks(for value: Float, ofType tweakType: String) {
		red.append(Tweak.getTweak(with: value, and: .modify))
		green.append(Tweak.getTweak(with: value, and: .modify))
		blue.append(Tweak.getTweak(with: value, and: .modify))

		if tweakType.lowercased() == "tint" {
			red.append(Tweak.getTweak(with: 1 - value, and: .offset))
			green.append(Tweak.getTweak(with: 1 - value, and: .offset))
			blue.append(Tweak.getTweak(with: 1 - value, and: .offset))
		}
	}

	/// Recompute RGB values based on RGB Tweaks
	func setRGB(for rgb: inout [Float]) {
		self.toRGB(from: &rgb) // RGB to tweak compatible value conversion

		Tweak.modifyRGBTweakValue(for: &rgb[0], using: red)
		Tweak.modifyRGBTweakValue(for: &rgb[1], using: green)
		Tweak.modifyRGBTweakValue(for: &rgb[2], using: blue)

		self.scRGB(toRGB: &rgb) // tweak compatible value to RGB conversion
	}

	/// Convert each RGB value of range 0...255 to range 0...1 so that it can be used in other tweak related calculations ('...' indicates range)
	func toRGB(from rgb: inout [Float]) {
		for index in 0..<3 {
			let value = rgb[index] / 255.0

			if value < 0 {
				rgb[index] = 0
			} else if value <= 0.040_5 {
				rgb[index] = value / 12.92
			} else if value <= 1 {
				let x = (value + 0.055) / 1.055
				rgb[index] = powf(x, 2.4)
			} else {
				rgb[index] = 1
			}
		}
	}

	/// Convert each value of range 0...1 back to RGB value of range 0...255 ('...' indicates range)
	func scRGB(toRGB rgb: inout [Float]) {
		for index in 0..<3 {
			var value = rgb[index]

			if value < 0 {
				value = 0
			} else if value <= 0.003_130_8 {
				value *= 12.92
			} else if value <= 1 {
				let y = Float(1.0 / 2.4)
				value = 1.055 * powf(value, y) - 0.055
			} else {
				value = 1
			}

			rgb[index] = roundf(value * 255)
		}
	}
}

private extension HSLTweak {
	/// Recompute RGB values based on HSL
	func setHSL(for rgb: inout [Float]) {
		self.toHSL(from: &rgb) // RGB to HSL

		var count = 0
		Tweak.modifyHSLTweakValue(for: &rgb[0], using: hue, with: &count) // Hue
		Tweak.modifyHSLTweakValue(for: &rgb[1], using: saturation, with: &count) // Saturation
		Tweak.modifyHSLTweakValue(for: &rgb[2], using: luminance, with: &count) // Luminance

		self.hsl(toRGB: &rgb, withCount: count) // HSL back to RGB
	}

	// RGB to HSL conversion
	func toHSL(from rgb: inout [Float]) {
		let r = rgb[0]
		let g = rgb[1]
		let b = rgb[2]
		let maxValue = max(r, max(g, b))
		let minValue = min(r, min(g, b))
		var h: Float = 0

		if maxValue == minValue {
		} else if maxValue == r {
			let n = (g - b) / (maxValue - minValue)
			h = Float(Int((60 * n) + 360) % 360)
			//            h = ((60 * n) + 360).truncatingRemainder(dividingBy: 360)
		} else if maxValue == g {
			let n = (b - r) / (maxValue - minValue)
			h = (60 * n) + 120
		} else {
			let n = (r - g) / (maxValue - minValue)
			h = (60 * n) + 240
		}
		h /= 360.0

		let l = (maxValue + minValue) / (255 * 2)
		var s: Float = 0

		if maxValue == minValue {
		} else if l <= 0.5 {
			s = (maxValue - minValue) / (2 * l)
		} else {
			s = (maxValue - minValue) / (2 - (2 * l))
		}
		s /= 255.0

		rgb[0] = h
		rgb[1] = s
		rgb[2] = l
	}

	// HSL to RGB conversion
	func hsl(toRGB rgb: inout [Float], withCount count: Int) {
		let h = rgb[0]
		let s = rgb[1]
		let l = rgb[2]
		var q: Float = 0

		if l < 0.5 {
			q = l * (1 + s)
		} else {
			q = l + s - (l * s)
		}

		let p = 2 * l - q
		let hk = h
		let temp = Float(1.0 / 3.0)
		let tr = hk + temp
		let tg = hk
		let tb = hk - temp

		rgb[0] = tr
		rgb[1] = tg
		rgb[2] = tb

		for index in 0..<3 {
			var val = rgb[index]
			if val < 0 {
				val += 1
			} else if val > 1 {
				val -= 1
			}

			//            val = val.truncatingRemainder(dividingBy: 1)

			if val < Float(1.0 / 6.0) {
				val = p + ((q - p) * 6 * val)
			} else if val >= Float(1.0 / 6.0), val < 0.5 {
				val = q
			} else if val >= 0.5, val < Float(2.0 / 3.0) {
				val = p + ((q - p) * 6 * (Float(2.0 / 3.0) - val))
			} else {
				val = p
			}

			var value = roundf(val * 255)
			value = Float(limit(value: CGFloat(value), minValue: 0, maxValue: 255))
			rgb[index] = value
		}
	}
}

private extension Tweak {
	/// Construct a 'ColorTweak_Tweak' object with given value and mode
	static func getTweak(with value: Float, and mode: Tweak.TweakMode) -> Tweak {
		var tweak = Tweak()
		tweak.value = value
		tweak.mode = mode
		return tweak
	}

	/// Modify each RGB value by applying RGBTweaks
	static func modifyRGBTweakValue(for value: inout Float, using rgbTweaks: [Tweak]) {
		for rgbTweak in rgbTweaks {
			rgbTweak.modifyTweakValue(for: &value)
			value = Float(limit(value: CGFloat(value), minValue: 0, maxValue: 1))
		}
	}

	/// Modify each RGB value by applying HSLTweaks
	static func modifyHSLTweakValue(for value: inout Float, using hslTweaks: [Tweak], with count: inout Int) {
		for hslTweak in hslTweaks {
			hslTweak.modifyTweakValue(for: &value)
			value = Float(limit(value: CGFloat(value), minValue: 0, maxValue: 1))
			count += 1
		}
	}

	/// Recompute RGB/HSL Tweak value based given 'value'
	func modifyTweakValue(for tweakValue: inout Float) {
		switch mode {
		case .modify:
			tweakValue *= value
		case .offset:
			tweakValue += value
		case .absolute:
			tweakValue = value
		}
	}
}
