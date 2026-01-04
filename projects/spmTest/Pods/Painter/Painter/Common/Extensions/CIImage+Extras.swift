//
//  CIImage+Extras.swift
//  Painter
//
//  Created by karthikeyan gm on 25/04/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
#if os(macOS)
import AppKit
#endif
import CoreImage
import Foundation

let globalCIContext = CIContext(options: nil)

extension CIImage {
#if os(macOS)
	var nsImage: NSImage {
		let ciImageRepresentation = NSCIImageRep(ciImage: self)
		let nsImage = NSImage(size: ciImageRepresentation.size)
		nsImage.addRepresentation(ciImageRepresentation)
		return nsImage
	}
#endif

	var cgImage: CGImage? {
		let image = globalCIContext.createCGImage(self, from: extent)
		return image
	}

	func saturated(by value: Float) -> CIImage {
		return applyingFilter(
			"CIColorControls",
			parameters:
			[
				kCIInputSaturationKey: value
			])
	}

	func contrasted(by value: Float) -> CIImage {
		return applyingFilter(
			"CIColorControls",
			parameters:
			[
				kCIInputContrastKey: value
			])
	}

	func brightened(by value: Float) -> CIImage {
		return applyingFilter(
			"CIColorControls",
			parameters:
			[
				kCIInputBrightnessKey: value
			])
	}

	func hued(by value: Float) -> CIImage {
		return applyingFilter(
			"CIHueAdjust",
			parameters:
			[
				"inputAngle": Int(value)
			])
	}

	func tint(by color: DeviceColor) -> CIImage {
		var (red, green): (CGFloat, CGFloat) = (0, 0)
		var (blue, alpha): (CGFloat, CGFloat) = (0, 0)
		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return applyingFilter(
			"CIColorMatrix",
			parameters:
			[
				"inputRVector": CIVector(x: red),
				"inputGVector": CIVector(y: green),
				"inputBVector": CIVector(z: blue),
				"inputAVector": CIVector(w: alpha)
			])
	}

	func sharpen(by value: Float) -> CIImage {
		return applyingFilter(
			"CISharpenLuminance",
			parameters:
			[
				"inputSharpness": value
			])
	}

	func blurred(by radius: Float) -> CIImage {
		return applyingFilter(
			"CIGaussianBlur",
			parameters:
			[
				"inputRadius": radius
			])
	}

	func applyingFilters(with components: [HSB]) -> CIImage {
		var output = self
		for component in components {
			output = output.applyingFilter(component.filterName, parameters: component.parameters)
		}
		return output
	}
}
#endif
