//
//  ShadowDrawing.swift
//  Painter
//
//  Created by Akshay T S on 10/06/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(macOS)
import CoreGraphics
#endif
import Foundation
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif
import Proto

enum ShadowConstants {
	static var scalingFactorForShadowImage: CGFloat = 1.0
#if !os(watchOS)
	static var ciContext = CIContext()
#endif
}

extension Effects.Shadow {
	func getShadow(from alphaOnlyContext: CGContext, cimg: CGSize, id: String, config: PainterConfig?) -> CGImage? {
		guard let bitmapConst = config?.shadowBitmapConstants else {
			return nil
		}
		let shadowColor = self.color.cgColor
		let shadowBlur = CGFloat(blur.radius)
		if let alphaMaskImage = alphaOnlyContext.makeImage() {
			let imageContext = CGContext(
				data: nil,
				width: Int((cimg.width * ShadowConstants.scalingFactorForShadowImage).rounded(.up)),
				height: Int((cimg.height * ShadowConstants.scalingFactorForShadowImage).rounded(.up)),
				bitsPerComponent: bitmapConst.bitsPerComponent,
				bytesPerRow: 0,
				space: bitmapConst.colorSpace,
				bitmapInfo: bitmapConst.bitmapInfo.rawValue)

			let drawRect = CGRect(x: 0, y: 0, width: cimg.width * ShadowConstants.scalingFactorForShadowImage, height: cimg.height * ShadowConstants.scalingFactorForShadowImage)
			imageContext?.setFillColor(shadowColor)
			imageContext?.interpolationQuality = .high
			imageContext?.draw(alphaMaskImage, in: drawRect)

#if !os(watchOS)
			if let unblurredImage = imageContext?.makeImage() {
				let ciContext = ShadowConstants.ciContext
				let unblurredCIImage = CIImage(cgImage: unblurredImage)
				let blurredCIImage = unblurredCIImage.applyingGaussianBlur(sigma: Double(pointToPixel(shadowBlur / 2)))
				let rect = blurredCIImage.regionOfInterest(for: unblurredCIImage, in: blurredCIImage.extent)
				var ceterRect = blurredCIImage.extent
				ceterRect.center = rect.center
				if let blurredImage = ciContext.createCGImage(blurredCIImage, from: ceterRect) {
					config?.setShadowImage(for: id, hashValue: self.hashValue, image: blurredImage)
					return blurredImage
				}
			}
#endif
		}
		return nil
	}
}

extension ShapeObject {
	func getShadows(gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices, with current: RenderingContext, shapeOrientation: ShapeOrientation) -> [(shadow: CGImage, shadowFrame: CGRect)] {
		let frameRect = self.refreshFrameWithoutEffects(gprops: gprops, using: config, matrix: matrix)
		var alphaOnlyContext: CGContext?
		var shadowImages: [(shadow: CGImage, shadowFrame: CGRect)] = []
		for shadow in props.effects.shadows where !shadow.hidden && shadow.type == .outer {
			var shadowWithImageDetail = shadow
			shadowWithImageDetail.clearDistance()
			let shadowImage: CGImage
			let shadowSize: CGSize
			if let shadowMip = config?.getShadowImage(for: self.id, hashValue: shadowWithImageDetail.hashValue, level: current.zoomFactor) {
				shadowImage = shadowMip.0
				shadowSize = shadowMip.1
			} else {
				let context: CGContext
				if let alphaContext = alphaOnlyContext {
					context = alphaContext
				} else {
					context = renderedAlphaOnlyContext(gprops: gprops, using: config, matrix: matrix, frameRect: frameRect, shapeOrientation: shapeOrientation, currentCtx: current)
					alphaOnlyContext = context
				}
				if let currentShadowImage = shadowWithImageDetail.getShadow(from: context, cimg: frameRect.size, id: self.id, config: config) {
					shadowImage = currentShadowImage
					shadowSize = CGSize(width: shadowImage.width, height: shadowImage.height)
				} else {
					continue
				}
			}
			var shadowFrame = shadow.getShadowFrame(for: frameRect)
			var drawRect = shadowFrame
			let dx = frameRect.center.x - shadowFrame.center.x
			let dy = frameRect.center.y - shadowFrame.center.y
			shadowFrame = frameRect.offsetBy(dx: dx, dy: dy)
			drawRect.size.width = shadowSize.width / ShadowConstants.scalingFactorForShadowImage
			drawRect.size.height = shadowSize.height / ShadowConstants.scalingFactorForShadowImage
			drawRect.center = shadowFrame.center
			shadowImages.append((shadowImage, drawRect))
		}
		return shadowImages
	}

	func renderedAlphaOnlyContext(gprops: Properties?, using config: PainterConfig?, matrix: OrientationMatrices, frameRect: CGRect, shapeOrientation: ShapeOrientation, currentCtx: RenderingContext) -> CGContext {
		if let b = config?.shadowBitmapConstants {
			if let alphaOnlyContext = CGContext(
				data: nil,
				width: Int(frameRect.width) != 0 ? Int(frameRect.width.rounded(.up) * ShadowConstants.scalingFactorForShadowImage) : 1,
				height: Int(frameRect.height) != 0 ? Int(frameRect.height.rounded(.up) * ShadowConstants.scalingFactorForShadowImage) : 1,
				bitsPerComponent: b.bitsPerComponent,
				bytesPerRow: 0,
				space: b.colorSpace,
				bitmapInfo: b.bitmapInfo.rawValue) {
				alphaOnlyContext.scaleBy(x: ShadowConstants.scalingFactorForShadowImage, y: ShadowConstants.scalingFactorForShadowImage)
				alphaOnlyContext.translateBy(x: -frameRect.origin.x, y: -frameRect.origin.y)
				let alphaRenderContext = RenderingContext(ctx: alphaOnlyContext, zoomFactor: currentCtx.zoomFactor, vFlipShadow: currentCtx.verticallyFlipShadow)
				alphaRenderContext.editingTextID = currentCtx.editingTextID
				alphaRenderContext.editingShapeIds = currentCtx.editingShapeIds
#if os(macOS)
				let nsGraphicsContext = NSGraphicsContext(cgContext: alphaOnlyContext, flipped: true)
				let previousContext = NSGraphicsContext.current
				NSGraphicsContext.current = nsGraphicsContext
#elseif os(iOS) || os(tvOS)
				UIGraphicsPushContext(alphaOnlyContext)
#else
				assertionFailure("Not supported on watchOS.")
#endif
				self.drawWithoutBlur(in: alphaRenderContext, withGroupProps: gprops, using: config, matrix: matrix, shapeOrientation: shapeOrientation)
#if os(macOS)
				NSGraphicsContext.current = previousContext
#elseif os(iOS) || os(tvOS)
				UIGraphicsPopContext()
#else
				assertionFailure("Not supported on watchOS.")
#endif
				if let image = alphaOnlyContext.makeImage() {
					if let alphaContext = CGContext(
						data: nil,
						width: Int(frameRect.width) != 0 ? Int(frameRect.width.rounded(.up) * ShadowConstants.scalingFactorForShadowImage) : 1,
						height: Int(frameRect.height) != 0 ? Int(frameRect.height.rounded(.up) * ShadowConstants.scalingFactorForShadowImage) : 1,
						bitsPerComponent: 8,
						bytesPerRow: 0,
						space: CGColorSpaceCreateDeviceGray(),
						bitmapInfo: CGImageAlphaInfo.alphaOnly.rawValue) {
						alphaContext.draw(image, in: CGRect(origin: .zero, size: frameRect.size))
						return alphaContext
					}
				}
			}
		}
		return currentCtx.cgContext
	}
}
