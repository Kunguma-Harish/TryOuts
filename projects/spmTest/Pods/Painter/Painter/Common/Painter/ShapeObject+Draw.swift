//
//  ShapeObject+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 15/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif
import Proto

public extension ShapeObject {
	func drawableContentFrame(config: PainterConfig?, hasParent: Bool = true, gProps: Properties? = nil, matrix: OrientationMatrices = .identity, isMultiPathPreset: Bool = false) -> CGRect {
		return refreshFrame(
			parentId: nil,
			shouldCache: !hasParent,
			config: config,
			matrix: matrix,
			gprops: gProps,
			isMultiPathPreset: isMultiPathPreset)
	}

	func drawableContentFrameWithoutEffects(config: PainterConfig?, gProps: Properties? = nil, matrix: OrientationMatrices = .identity) -> CGRect {
		return refreshFrameWithoutEffects(gprops: gProps, using: config, matrix: matrix)
	}

	func drawableContentFrameWithControl(_ config: PainterConfig?) -> CGRect {
		return .null // refreshFrameWithControl(withGroupTransform: nil, config)
	}

#if !os(watchOS)
	func drawWithBlur(in ctx: RenderingContext, withGroupProps gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices, shapeOrientation: ShapeOrientation, isMultiPathPreset: Bool = false) {
		if props.hasBlend {
			ctx.cgContext.setBlendMode(props.blend.mode)
		}

		if let cache = config?.cache, let blurImage = cache.getBlurImageMap(for: id)?.withEffects {
			ctx.cgContext.draw(blurImage.cgImage, in: blurImage.imageRect)
		} else if let blurImage = getBlurImage(from: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation) {
			ctx.cgContext.draw(blurImage.cgImage, in: blurImage.imageRect)
			if let cache = config?.cache {
				cache.setBlurImageMap(for: id, imageWithEffects: blurImage)
			}
		}
	}
#endif
}

extension ShapeObject {
	var unsupportedBlur: Bool { // Masked blur not supported.
//		return props.blur.type == .masked
		return true
	}
}

// MARK: Blur

private extension ShapeObject {
	var platformColorSpace: CGColorSpace {
#if os(macOS)
		return CGDisplayCopyColorSpace(CGMainDisplayID())
#else
		return CGColorSpaceCreateDeviceRGB()
#endif
	}

#if !os(watchOS)
	func getBlurImage(from gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices, shapeOrientation: ShapeOrientation) -> Blur.BlurImage? {
		let mtrans = props.transform.getModifiedTransform(group: gprops?.transform, using: config)
		let shapeFrame = type != .groupshape ? props.blurFrame(forTransform: mtrans, id: id, using: config) : groupshape.blurFrame(forTransform: mtrans, using: config)
		if !self.unsupportedBlur {
			let contextWidth = shapeFrame.width >= 1.0 ? ceil(shapeFrame.width) : 1.0
			let contextHeight = shapeFrame.height >= 1.0 ? ceil(shapeFrame.height) : 1.0
			guard let blurContext = CGContext(
				data: nil,
				width: Int(contextWidth),
				height: Int(contextHeight),
				bitsPerComponent: 8,
				bytesPerRow: 4 * Int(contextWidth),
				space: platformColorSpace,
				bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
			else {
				assertionFailure("Unable to create new context")
				return nil
			}
			blurContext.translateBy(x: -shapeFrame.origin.x, y: -shapeFrame.origin.y)

#if os(macOS)
			let nsGraphicsContext = NSGraphicsContext(cgContext: blurContext, flipped: true)
			let previousContext = NSGraphicsContext.current
			NSGraphicsContext.current = nsGraphicsContext
#elseif os(iOS) || os(tvOS)
			UIGraphicsPushContext(blurContext)
#else
			assertionFailure("Not supported on watchOS.")
#endif

			let renderContext = RenderingContext(ctx: blurContext, vFlipShadow: true)
			drawWithoutBlur(in: renderContext, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation)

#if os(macOS)
			NSGraphicsContext.current = previousContext
#elseif os(iOS) || os(tvOS)
			UIGraphicsPopContext()
#else
			assertionFailure("Not supported on watchOS.")
#endif

			return props.blur.draw(withContext: blurContext, inRect: shapeFrame)
		}
		assertionFailure("Not implemented yet.")
		return nil
	}
#endif
}
