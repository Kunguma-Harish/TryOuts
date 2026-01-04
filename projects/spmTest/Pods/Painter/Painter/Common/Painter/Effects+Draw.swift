//
//  Effects+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
#if !os(watchOS)
import CoreImage
#endif
import Foundation
import Proto

extension Effects.Shadow {
	public func getShadowOffset(for frame: CGRect, scale: CGFloat = 1.0, vflip: Bool = false) -> CGSize {
		var point = frame.center
		point.x += CGFloat(distance.radius) * scale
		point = point.rotate(around: frame.center, byDegree: self.shadowAngle)
		var offset = CGSize(width: point.x - frame.center.x, height: point.y - frame.center.y)

		if vflip {
			offset.height *= -1
		}
		return offset
	}

	func getShadowFrame(for frame: CGRect) -> CGRect {
		let x = CGFloat(distance.radius)
		let angle = CGFloat(distance.angle)

		var center = frame.center
		center.x -= x
		center = center.rotate(around: frame.center, byDegree: angle)

		var shdwFrame = frame
		shdwFrame.center = center

		return shdwFrame
	}

	func drawInner(
		in ctx: RenderingContext,
		for frame: CGRect,
		with path: CGPath,
		using config: PainterConfig?,
		isConnector: Bool = false) {
		// TODO: Inner shadow for image
		if !(hasHidden && hidden) {
			let shadowOffset = self.getShadowOffset(for: frame, scale: ctx.scaleRatio, vflip: ctx.verticallyFlipShadow)
			let shadowBlur = CGFloat(blur.radius)
			//        let shadowPath: CGPath
			let shadowOpaqueColor: CGColor
			let shadowColorAlpha: CGFloat

			//        if hasScale {
			//            shadowPath = path.enlargeBy(dx: CGFloat(scale.x), dy: CGFloat(scale.y))
			//        }
			//        else {
			//            shadowPath = path
			//        }

			if hasColor {
				shadowOpaqueColor = color.cgColor.copy(alpha: 1.0) ?? color.cgColor
				shadowColorAlpha = CGFloat(1.0 - color.tweaks.alpha)
			} else {
				assertionFailure("no color for shadow, applying default shadow color")
				shadowOpaqueColor = CGColor.black.copy(alpha: 1.0) ?? .black
				shadowColorAlpha = 1.0 - (1.0 / 3.0)
			}

			ctx.cgContext.saveGState()
			ctx.cgContext.clip(to: path.boundingBoxOfPath)
			ctx.cgContext.setShadow(offset: CGSize.zero, blur: 0)
			ctx.cgContext.setAlpha(shadowColorAlpha)
			ctx.cgContext.beginTransparencyLayer(in: path.boundingBoxOfPath, auxiliaryInfo: nil)
			ctx.cgContext.setShadow(offset: shadowOffset, blur: shadowBlur, color: shadowOpaqueColor)
			ctx.cgContext.setBlendMode(.sourceOut)
			ctx.cgContext.beginTransparencyLayer(in: path.boundingBoxOfPath, auxiliaryInfo: nil)

			ctx.cgContext.setFillColor(shadowOpaqueColor)
			ctx.cgContext.addPath(path)
			if isConnector {
				ctx.cgContext.strokePath()
			} else {
				ctx.cgContext.fillPath() // Connectors should only be stroked
			}

			ctx.cgContext.endTransparencyLayer()
			ctx.cgContext.endTransparencyLayer()
			ctx.cgContext.restoreGState()
		}
	}

	// swiftlint:disable function_parameter_count
	func drawOuter(
		in ctx: RenderingContext,
		for frame: CGRect,
		with path: CGPath,
		fills: [Fill],
		strokes: [Stroke],
		transform: Transform,
		using config: PainterConfig?,
		forId id: String,
		shapeOrientation: ShapeOrientation,
		crop: Offset? = nil) {
		if !(hasHidden && hidden) {
			let shadowoffset = self.getShadowOffset(for: frame, scale: ctx.scaleRatio, vflip: ctx.verticallyFlipShadow)
			let shadowBlur = CGFloat(blur.radius)

			// MARK: Unused

			//			let shadowPath = hasScale ? path.enlargeBy(dx: CGFloat(scale.x), dy: CGFloat(scale.y)) : path
			let shadowColor: CGColor

			if hasColor {
				shadowColor = color.cgColor
			} else {
				assertionFailure("no color for shadow, applying default shadow color")
				shadowColor = CGColor.black.copy(alpha: 1.0 / 3.0) ?? .black
			}

			ctx.cgContext.saveGState()
			ctx.cgContext.setShadow(offset: shadowoffset, blur: shadowBlur, color: shadowColor)
			// TODO: Check for blend mode
			ctx.cgContext.setBlendMode(CGBlendMode.normal)

			// TODO: The following code for shadow is extremely slow with the use of transparency layer. Find out an effective way to draw shadows.
			ctx.cgContext.beginTransparencyLayer(auxiliaryInfo: nil)

			for fill in fills {
				ctx.cgContext.saveGState()
				ctx.cgContext.addPath(path)
				fill.draw(
					in: ctx,
					within: frame,
					using: config,
					forId: id,
					shapeOrientation: shapeOrientation,
					crop: crop)
				ctx.cgContext.restoreGState()
			}

			for stroke in strokes {
				ctx.cgContext.saveGState()
				stroke.draw(
					in: ctx,
					with: path,
					frame: frame,
					forId: id,
					shapeOrientation: shapeOrientation)
				ctx.cgContext.restoreGState()
			}
			ctx.cgContext.endTransparencyLayer()
			ctx.cgContext.restoreGState()
		}
	}

	// swiftlint:enable function_parameter_count

	func setShadow(on ctx: RenderingContext, within frame: CGRect, using config: PainterConfig?) {
		let shadowoffset = self.getShadowOffset(for: frame, scale: ctx.scaleRatio, vflip: ctx.verticallyFlipShadow)
		let shadowBlur = CGFloat(blur.radius)
		let shadowColor: CGColor

		if hasColor {
			shadowColor = color.cgColor
		} else {
			assertionFailure("no color for shadow, applying default shadow color")
			shadowColor = CGColor.black.copy(alpha: 1.0 / 3.0) ?? .black
		}
		ctx.cgContext.setShadow(offset: shadowoffset, blur: shadowBlur, color: shadowColor)
	}
}

extension Effects {
	var hasVisibleOuterShadow: Bool {
		if hasShadow, shadow.type == .outer, shadow.hidden == false {
			return true
		}

		for shdw in shadows where shdw.type == .outer && shdw.hidden == false {
			return true
		}

		return false
	}

	func getEffectsFrame(for frame: CGRect) -> CGRect? {
		var sframe = CGRect.null
		if hasShadow, shadow.type == .outer {
			sframe = shadow.getShadowFrame(for: frame)
		}
		for shdw in shadows where shdw.type == .outer {
			sframe = sframe.union(shdw.getShadowFrame(for: frame))
		}
		if hasReflection {
			assertionFailure("reflection support not added")
		}
		return (sframe != .null) ? sframe : nil
	}

	func getEffectsFrameTranslates(for frame: CGRect) -> [(CGPoint, Float)] {
		var txty: [(CGPoint, Float)] = []
		if hasShadow, shadow.type == .outer, !shadow.hidden {
			let sframe = shadow.getShadowFrame(for: frame)
			txty.append((sframe.center, shadow.blur.radius))
		}
		for shdw in shadows where shdw.type == .outer && !shdw.hidden {
			let sframe = shdw.getShadowFrame(for: frame)
			txty.append((sframe.center, shdw.blur.radius))
		}
		return txty
	}

	// swiftlint:disable function_parameter_count
	func drawOuter(
		in ctx: RenderingContext,
		for frame: CGRect,
		with path: CGPath,
		fills: [Fill],
		strokes: [Stroke],
		transform: Transform,
		using config: PainterConfig?,
		forId id: String,
		shapeOrientation: ShapeOrientation,
		crop: Offset? = nil) {
		if hasShadow, shadow.type == .outer {
			shadow.drawOuter(
				in: ctx,
				for: frame,
				with: path,
				fills: fills,
				strokes: strokes,
				transform: transform,
				using: config,
				forId: id,
				shapeOrientation: shapeOrientation,
				crop: crop)
		}
		for shdw in shadows where shdw.type == .outer {
			shdw.drawOuter(
				in: ctx,
				for: frame,
				with: path,
				fills: fills,
				strokes: strokes,
				transform: transform,
				using: config,
				forId: id,
				shapeOrientation: shapeOrientation,
				crop: crop)
		}
	}

	// swiftlint:enable function_parameter_count

	func drawInner(in ctx: RenderingContext, for frame: CGRect, with path: CGPath, using config: PainterConfig?, isConnector: Bool = false) {
		if hasShadow, shadow.type == .inner {
			shadow.drawInner(in: ctx, for: frame, with: path, using: config, isConnector: isConnector)
		}
		for shdw in shadows where shdw.type == .inner {
			shdw.drawInner(in: ctx, for: frame, with: path, using: config, isConnector: isConnector)
		}
	}
}

// MARK: - Reflection

extension Effects.Reflection {
#if !os(watchOS)
	func draw(in ctx: RenderingContext, inside frame: CGRect, start: CGFloat? = nil, end: CGFloat? = nil) {
		var filterParams = [
			"inputPoint0": CIVector(x: 50, y: 0),
			"inputPoint1": CIVector(x: 50, y: CGFloat(self.pos.end) * 100),
			"inputColor0": CIColor(red: 255, green: 255, blue: 255, alpha: 1),
			"inputColor1": CIColor(red: 255, green: 255, blue: 255, alpha: 0)
		]
		// FIXME: - 'start' and 'end' values are incorrect. Revisit
//		if let start = start {
//			filterParams["inputPoint0"] = CIVector(x: 50, y: start * 100)
//		}
//		if let end = end {
//			filterParams["inputPoint1"] = CIVector(x: 50, y: end * 100)
//		}

		if self.pos.end == 0 {
			filterParams["inputPoint1"] = CIVector(x: 50, y: 0.01)
			filterParams["inputColor0"] = CIColor(red: 255, green: 255, blue: 255, alpha: 1)
		}

		if let filter = CIFilter(name: "CILinearGradient", parameters: filterParams) {
			guard let result = filter.outputImage else {
				assertionFailure()
				return
			}
			let ciContext = CIContext(options: convertToOptionalCIContextOptionDictionary(
				[convertFromCIContextOption(.useSoftwareRenderer): false]))

			guard let mask = ciContext.createCGImage(result, from: CGRect(x: 0, y: 0, width: 100, height: 100)) else {
				assertionFailure()
				return
			}
			ctx.cgContext.clip(to: frame, mask: mask)
		}
	}

	func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
		guard let input = input else {
			return nil
		}
		return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value) })
	}

	func convertFromCIContextOption(_ input: CIContextOption) -> String {
		return input.rawValue
	}
#endif
}
