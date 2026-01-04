//
//  CGImage+Filters.swift
//  Painter
//
//  Created by Sarath Kumar G on 17/07/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
#if !os(watchOS)
import CoreImage
#endif
import Proto

private struct RGB {
	let r: Float
	let g: Float
	let b: Float

	static var `default`: RGB {
		return RGB(r: 0, g: 0, b: 0)
	}
}

extension RGB {
	init(color: Color) {
		self.init(r: Float(color.rgb[0]), g: Float(color.rgb[1]), b: Float(color.rgb[2]))
	}
}

public extension CGImage {
	func applyingFilters(with components: [HSB]) -> CGImage? {
#if !os(watchOS)
		let ciImage = CIImage(cgImage: self)
		return ciImage.applyingFilters(with: components).cgImage
#else
		return self
#endif
	}

	func applyingFilters(from pictureProps: PictureProperties) -> CGImage? {
		let (width, height) = (self.width, self.height)
		let bitsPerComponent = self.bitsPerComponent
		let bytesPerRow = self.bytesPerRow
		let colorSpace = self.colorSpace ?? CGColorSpaceCreateDeviceRGB()
		let alpha = self.alphaInfo

		guard let dataProvider = self.dataProvider, let cfData = dataProvider.data else {
			return nil
		}
		let length = CFDataGetLength(cfData)
		let mutableCFData = CFDataCreateMutableCopy(nil, length, cfData)

		guard var pixelBuffer = CFDataGetMutableBytePtr(mutableCFData) else {
			return nil
		}
		var filteredImage: CGImage?
		if self.applyingFilters(to: &pixelBuffer, from: pictureProps, length: length) {
			let ctx = CGContext(
				data: pixelBuffer,
				width: width,
				height: height,
				bitsPerComponent: bitsPerComponent,
				bytesPerRow: bytesPerRow,
				space: colorSpace,
				bitmapInfo: alpha.rawValue)

			filteredImage = ctx?.makeImage()
		}
		return filteredImage
	}
}

// MARK: - Image Filter Helpers

private extension CGImage {
	func applyingFilters(
		to pixelBuffer: inout UnsafeMutablePointer<UInt8>,
		from pictureProps: PictureProperties,
		length: CFIndex) -> Bool {
		var didApplyFilters = false
		if pictureProps.hasColorChange {
			self.apply(pictureProps.colorChange, to: &pixelBuffer, length: length)
			didApplyFilters = true
		}
		if pictureProps.hasColorMode, pictureProps.colorMode.hasMode {
			switch pictureProps.colorMode.mode {
			case .none:
				break
			case .bilevel:
				let threshold = 255.0 * (pictureProps.colorMode.hasBilevel ? pictureProps.colorMode.bilevel : 0.5)
				self.applyBilevelFilter(to: &pixelBuffer, threshold: threshold, length: length)
			case .duotone:
				self.applyDuotoneFilter(to: &pixelBuffer, from: pictureProps.colorMode.duotone, length: length)
			case .grayscale:
				self.applyGrayScaleFilter(to: &pixelBuffer, length: length)
			case .sepia:
				self.applySepiaFilter(to: &pixelBuffer, length: length)
			}
			didApplyFilters = true
		}
		if pictureProps.hasLuminance {
			self.apply(pictureProps.luminance, to: &pixelBuffer, length: length)
			didApplyFilters = true
		}
		return didApplyFilters
	}

	func apply(
		_ colorChange: PictureProperties.ColorChange,
		to pixelBuffer: inout UnsafeMutablePointer<UInt8>,
		length: CFIndex) {
		let temp: Float = 16
		let fromColor = RGB(color: colorChange.from)

		for index in stride(from: 0, to: length, by: 4) {
			let (rIndex, gIndex, bIndex, aIndex) = (index, index + 1, index + 2, index + 3)
			let r = Float(pixelBuffer[rIndex])
			let g = Float(pixelBuffer[gIndex])
			let b = Float(pixelBuffer[bIndex])

			if r >= (fromColor.r - temp), r <= (fromColor.r - temp),
			   g >= (fromColor.g - temp), g <= (fromColor.g - temp),
			   b >= (fromColor.b - temp), b <= (fromColor.b - temp) {
				pixelBuffer[aIndex] = 0
			}
		}
	}

	func applyBilevelFilter(to pixelBuffer: inout UnsafeMutablePointer<UInt8>, threshold: Float, length: CFIndex) {
		for index in stride(from: 0, to: length, by: 4) {
			let (rIndex, gIndex, bIndex) = (index, index + 1, index + 2)
			let r = Float(pixelBuffer[rIndex])
			let g = Float(pixelBuffer[gIndex])
			let b = Float(pixelBuffer[bIndex])

			let brightness = (r * 0.299) + (g * 0.587) + (b * 0.114)
			let value: UInt8 = brightness >= threshold ? 255 : 0
			pixelBuffer[rIndex] = UInt8(value)
			pixelBuffer[gIndex] = UInt8(value)
			pixelBuffer[bIndex] = UInt8(value)
		}
	}

	func applyDuotoneFilter(to pixelBuffer: inout UnsafeMutablePointer<UInt8>, from colors: [Color], length: CFIndex) {
		precondition(!colors.isEmpty)
		let rgb1 = RGB(color: colors[0])
		let rgb2 = RGB(color: colors[1])
		self.modify(&pixelBuffer, using: duotoneColorMatrix(rgb1: rgb1, rgb2: rgb2), length: length)
	}

	func applyGrayScaleFilter(to pixelBuffer: inout UnsafeMutablePointer<UInt8>, length: CFIndex) {
		for index in stride(from: 0, to: length, by: 4) {
			let (rIndex, gIndex, bIndex) = (index, index + 1, index + 2)
			let r = Int(pixelBuffer[rIndex])
			let g = Int(pixelBuffer[gIndex])
			let b = Int(pixelBuffer[bIndex])

			let gray = (r + g + b) / 3
			pixelBuffer[rIndex] = UInt8(gray)
			pixelBuffer[gIndex] = UInt8(gray)
			pixelBuffer[bIndex] = UInt8(gray)
		}
	}

	func applySepiaFilter(to pixelBuffer: inout UnsafeMutablePointer<UInt8>, length: CFIndex) {
		let rgb1 = RGB(r: 0, g: 0, b: 0)
		let rgb2 = RGB(r: 217, g: 195, b: 165)
		self.modify(&pixelBuffer, using: duotoneColorMatrix(rgb1: rgb1, rgb2: rgb2), length: length)
	}

	func modify(_ pixelBuffer: inout UnsafeMutablePointer<UInt8>, using colorMatrix: [RGB], length: CFIndex) {
		for index in stride(from: 0, to: length, by: 4) {
			let (rIndex, gIndex, bIndex) = (index, index + 1, index + 2)
			let r = Int(pixelBuffer[rIndex])
			let g = Int(pixelBuffer[gIndex])
			let b = Int(pixelBuffer[bIndex])

			// NOTE: r, g, b values must be converted to 'Int' as 'UInt8' has range (0-255bytes) limitation
			let gray = (r + g + b) / 3
			pixelBuffer[rIndex] = UInt8(colorMatrix[gray].r)
			pixelBuffer[gIndex] = UInt8(colorMatrix[gray].g)
			pixelBuffer[bIndex] = UInt8(colorMatrix[gray].b)
		}
	}

	func apply(_ luminance: PictureProperties.Luminance, to pixelBuffer: inout UnsafeMutablePointer<UInt8>, length: CFIndex) {
		let colorMatrix = luminanceColorMatrix(for: luminance)
		for index in stride(from: 0, to: length, by: 4) {
			let (rIndex, gIndex, bIndex) = (index, index + 1, index + 2)
			let r = Int(pixelBuffer[rIndex])
			let g = Int(pixelBuffer[gIndex])
			let b = Int(pixelBuffer[bIndex])

			pixelBuffer[rIndex] = UInt8(colorMatrix[r])
			pixelBuffer[gIndex] = UInt8(colorMatrix[g])
			pixelBuffer[bIndex] = UInt8(colorMatrix[b])
		}
	}
}

// MARK: - Color Matrix Helpers

private extension CGImage {
	func duotoneColorMatrix(rgb1: RGB, rgb2: RGB) -> [RGB] {
		var colorMatrix = Array(repeating: RGB.default, count: 256)
		for index in 0..<256 {
			let t = Float(index) / 255.0
			let r = rgb1.r + t * (rgb2.r - rgb1.r)
			let g = rgb1.g + t * (rgb2.g - rgb1.g)
			let b = rgb1.b + t * (rgb2.b - rgb1.b)
			colorMatrix[index] = RGB(r: r, g: g, b: b)
		}
		return colorMatrix
	}

	func luminanceColorMatrix(for luminance: PictureProperties.Luminance) -> [Float] {
		let b = luminance.hasBrightness ? luminance.brightness : 0
		let contrast = luminance.hasContrast ? luminance.contrast : 0
		let c = (contrast < 0.0) ? (contrast + 1) : ((contrast * 10) + 1)

		var bValue: Float = 255
		if contrast > 0.0 {
			bValue = 127.0
		} else if contrast < 0.0 {
			bValue = (1.0 + c) * 127.0
		}

		var colorMatrix = [Float](repeating: 0, count: 256)
		for index in 0..<256 {
			var l = Float(index) - 127.0
			if contrast >= 0.0 {
				l += (b * bValue)
			}
			l *= c
			if contrast < 0.0 {
				l += (b * bValue)
			}
			l += 127.0
			colorMatrix[index] = fmaxf(fminf(l, 255.0), 0.0)
		}
		return colorMatrix
	}
}
