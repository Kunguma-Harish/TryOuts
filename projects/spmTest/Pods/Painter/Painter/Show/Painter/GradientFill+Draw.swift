//
//  GradientFill+Draw.swift
//  Painter
//
//  Created by Sarath Kumar G on 12/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

extension GradientFill {
	func draw(in ctx: RenderingContext, within rect: CGRect, using fillRule: CGPathFillRule, shapeOrientation: ShapeOrientation) {
		switch type {
		case .angular:
			advancedAngularFill(in: ctx, within: rect, using: fillRule, shapeOrientation: shapeOrientation)
		case .linear:
			linearFill(in: ctx, rect: rect, using: fillRule, shapeOrientation: shapeOrientation)
		case .radial:
			radialFill(in: ctx, within: rect, using: fillRule, shapeOrientation: shapeOrientation)
		case .rectangular, .path:
			break
		}
	}
}

private extension GradientFill {
	var falseGradient: CGGradient? {
		let first = stops[0].color.cgColor
		let last = stops[stops.count - 1].color.cgColor
		guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [first, last] as CFArray, locations: [0.0, 1.0]) else {
			assertionFailure("gradient can't be formed")
			return CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [CGColor.black, CGColor.black] as CFArray, locations: [0.0, 1.0])
		}
		return gradient
	}
}

// MARK: Linear and Radial Fill

private extension GradientFill {
	var cgGradient: CGGradient? {
		var stopColors = [CGColor]()
		var stopPositions = [CGFloat]()

		for stop in stops {
			stopColors.append(stop.color.cgColor)
			stopPositions.append(CGFloat(min(max(0, stop.position), 1)))
		}

		if let gradient = CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: stopColors as CFArray,
			locations: stopPositions) {
			return gradient
		}
		assertionFailure("CGGradient can't be formed")
		return CGGradient(
			colorsSpace: CGColorSpaceCreateDeviceRGB(),
			colors: [CGColor.black, CGColor.black] as CFArray,
			locations: [0.0, 1.0])
	}

	func linearFill(in ctx: RenderingContext, rect: CGRect, startpt: CGPoint? = nil, endpt: CGPoint? = nil, using fillRule: CGPathFillRule, shapeOrientation: ShapeOrientation) {
		//		if let path = ctx.cgContext.path {
		ctx.cgContext.clip(using: fillRule)
		//            let frame = path.boundingBoxOfPath

		var finalOrientationMatrix = OrientationMatrices()
		if let initialOrientationMatix = shapeOrientation.initialOrientationMatix {
			finalOrientationMatrix = initialOrientationMatix
		} else {
			finalOrientationMatrix = shapeOrientation.finalOrientationMatrix
		}
		let frame = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
		ctx.cgContext.concatenate(finalOrientationMatrix.rotationAndFlipMatrix)

		let alpha = CGFloat(rotate)
		var angle = alpha
		let (w, h) = (frame.width, frame.height)
		var (startPoint, endPoint) = (CGPoint(), CGPoint())
		let centreP = CGPoint(x: frame.origin.x + (w / 2), y: frame.origin.y + (h / 2))
		let dig = distanceBetweenPoints(frame.origin, centreP)
		let theta = atan2(h, w) * CGFloat(180 / CGFloat.pi)

		if angle >= 180, angle <= 270 {
			angle -= 180
		} else if angle > 270, angle < 360 {
			angle = 360 - angle
		} else if angle > 90, angle < 180 {
			angle = 180 - angle
		}
		let beta = abs(theta - angle)
		let d = dig * CGFloat(cos(beta * CGFloat(CGFloat.pi / 180)))
		let X = d * CGFloat(cos(angle * CGFloat(CGFloat.pi / 180)))
		let Y = d * CGFloat(sin(angle * CGFloat(CGFloat.pi / 180)))

		ctx.cgContext.translateBy(x: w / 2, y: h / 2)
		if let startpt = startpt, let endpt = endpt {
			startPoint = startpt
			endPoint = endpt
		} else {
			if alpha >= 0, alpha <= 90 {
				startPoint = CGPoint(x: frame.origin.x - X, y: frame.origin.y - Y)
				endPoint = CGPoint(x: frame.origin.x + X, y: frame.origin.y + Y)
			} else if alpha >= 180, alpha <= 270 {
				startPoint = CGPoint(x: frame.origin.x + X, y: frame.origin.y + Y)
				endPoint = CGPoint(x: frame.origin.x - X, y: frame.origin.y - Y)
			} else if alpha > 270, alpha < 360 {
				startPoint = CGPoint(x: frame.origin.x - X, y: frame.origin.y + Y)
				endPoint = CGPoint(x: frame.origin.x + X, y: frame.origin.y - Y)
			} else {
				startPoint = CGPoint(x: frame.origin.x + X, y: frame.origin.y - Y)
				endPoint = CGPoint(x: frame.origin.x - X, y: frame.origin.y + Y)
			}
		}

		// NOTE: - This causes unintended results if one of the stops contains an alpha of 1
//		if let fgradient = falseGradient {
//			ctx.cgContext.drawLinearGradient(fgradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
//		}
		if let gradient = cgGradient {
			ctx.cgContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
		}
		//		}
	}

	func radialFill(in ctx: RenderingContext, within rect: CGRect, using fillRule: CGPathFillRule, shapeOrientation: ShapeOrientation) {
		//		if let path = ctx.cgContext.path {
		ctx.cgContext.clip(using: fillRule)
		//            let frame = path.boundingBoxOfPath

		var finalOrientationMatrix = OrientationMatrices()
		if let initialOrientationMatix = shapeOrientation.initialOrientationMatix {
			finalOrientationMatrix = initialOrientationMatix
		} else {
			finalOrientationMatrix = shapeOrientation.finalOrientationMatrix
		}
		let frame = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
		ctx.cgContext.concatenate(finalOrientationMatrix.rotationAndFlipMatrix)

		let (w, h) = (frame.width, frame.height)
		var (startPoint, endPoint) = (CGPoint(), CGPoint())

		startPoint = CGPoint(
			x: frame.origin.x + (frame.size.width * CGFloat(radial.fillToRect.left)),
			y: frame.origin.y + (frame.size.height * CGFloat(radial.fillToRect.top)))

		// To get radial gradient that fills only till centre of the frame
		//			endPoint = CGPoint(x: frame.origin.x + (frame.size.width * 0.5), y: frame.origin.y + (frame.size.height * 0.5))

		endPoint = CGPoint(
			x: frame.origin.x + (frame.size.width * CGFloat(1 - radial.fillToRect.left)),
			y: frame.origin.y + (frame.size.height * CGFloat(1 - radial.fillToRect.top)))
		if radial.fillToRect.top == 0.5, radial.fillToRect.left == 0.5 {
			endPoint = CGPoint(
				x: frame.origin.x + frame.size.width,
				y: frame.origin.y + frame.size.height)
		}

		if w >= h {
			ctx.cgContext.scaleBy(x: w / h, y: 1)
			startPoint.x *= (h / w)
			endPoint.x *= (h / w)
		} else {
			ctx.cgContext.scaleBy(x: 1, y: h / w)
			startPoint.y *= (w / h)
			endPoint.y *= (w / h)
		}
		let endRadius = distanceBetweenPoints(startPoint, endPoint)

		// NOTE: - This causes unintended results if one of the stops contains an alpha of 1
//		if let falseGradient = falseGradient {
//			ctx.cgContext.drawRadialGradient(
//				falseGradient,
//				startCenter: startPoint,
//				startRadius: 0.0,
//				endCenter: startPoint,
//				endRadius: endRadius,
//				options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
//		}
		if let gradient = cgGradient {
			ctx.cgContext.drawRadialGradient(
				gradient,
				startCenter: startPoint,
				startRadius: 0.0,
				endCenter: startPoint,
				endRadius: endRadius,
				options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
		}
		//		}
	}
}

// MARK: Angular Gradient Fill

private extension GradientFill {
	struct Transition {
		let fromLocation: CGFloat
		let toLocation: CGFloat
		let fromColor: CGColor
		let toColor: CGColor

		func color(forPercent percent: CGFloat) -> CGColor {
			let normalizedPercent = convert(percent: percent, fromMin: fromLocation, max: toLocation, toMin: 0.0, max: 1.0)
			return CGColor.lerp(from: self.fromColor.rgba, to: self.toColor.rgba, percent: CGFloat(normalizedPercent))
		}
	}

	enum Constants {
		static let MaxAngle: CGFloat = 2 * .pi
		static let MaxHue = CGFloat(255.0)
	}

	// https://github.com/tadija/AEConicalGradient
	func advancedAngularFill(in ctx: RenderingContext, within rect: CGRect, using fillRule: CGPathFillRule, shapeOrientation: ShapeOrientation) {
		if ctx.cgContext.path != nil {
			var finalOrientationMatrix = OrientationMatrices()
			if let initialOrientationMatix = shapeOrientation.initialOrientationMatix {
				finalOrientationMatrix = initialOrientationMatix
			} else {
				finalOrientationMatrix = shapeOrientation.finalOrientationMatrix
			}
			let rect = rect.applying(finalOrientationMatrix.scaleAndTranslateMatrix)
			ctx.cgContext.concatenate(finalOrientationMatrix.rotationAndFlipMatrix)

			ctx.cgContext.clip(using: fillRule)
			let center = CGPoint(x: rect.midX, y: rect.midY)
			let rotateAngle = CGFloat(rotate)
			ctx.cgContext.translateBy(x: center.x, y: center.y)
			ctx.cgContext.rotate(by: .pi * rotateAngle / 180.0)
			ctx.cgContext.translateBy(x: -center.x, y: -center.y)

			var colors = [CGColor]()
			var locations = [CGFloat]()
			let startAngle: CGFloat = 0.0
			let endAngle: CGFloat = Constants.MaxAngle
			var transitions = [Transition]()
			self.loadTransitions(transitions: &transitions, colors: &colors, locations: &locations)

			let longerSide = max(rect.width, rect.height)
			let radius = CGFloat(longerSide) * CGFloat(2.squareRoot())
			let step = CGFloat((.pi / 2) / radius)
			var angle = startAngle

			while angle <= endAngle {
				let pointX = radius * CGFloat(cos(angle)) + CGFloat(rect.center.x)
				let pointY = radius * CGFloat(sin(angle)) + CGFloat(rect.center.y)
				let startPoint = CGPoint(x: pointX, y: pointY)

				let path = CGMutablePath()
				path.move(to: rect.center)
				path.addLine(to: startPoint)

				ctx.cgContext.setStrokeColor(self.color(forAngle: angle, transitions: transitions))
				ctx.cgContext.addPath(path)
				ctx.cgContext.strokePath()

				angle += step
			}
		}
	}

	func color(forAngle angle: CGFloat, transitions: [Transition]) -> CGColor {
		let percent = self.convert(angle: angle, fromZeroToMax: Constants.MaxAngle, toZeroToMax: 1.0)

		guard let transition = transition(forPercent: percent, transitions: transitions) else {
			return .black
		}

		return transition.color(forPercent: percent)
	}

	func loadTransitions(transitions: inout [Transition], colors: inout [CGColor], locations: inout [CGFloat]) {
		transitions.removeAll()
		var colorPositions = [CGFloat: CGColor]()
		for stop in stops {
			colorPositions.updateValue(stop.color.cgColor, forKey: CGFloat(stop.position))
		}
		locations = colorPositions.keys.sorted()
		for pos in locations {
			if let color = colorPositions[pos] {
				colors.append(color)
			}
		}

		if colors.count > 1 {
			let transitionsCount = colors.count - 1
			let locationStep = 1.0 / CGFloat(transitionsCount)

			for i in 0..<transitionsCount {
				let fromLocation, toLocation: CGFloat
				let fromColor, toColor: CGColor

				if locations.count == colors.count {
					fromLocation = locations[i]
					toLocation = locations[i + 1]
				} else {
					fromLocation = locationStep * CGFloat(i)
					toLocation = locationStep * CGFloat(i + 1)
				}

				fromColor = colors[i]
				toColor = colors[i + 1]

				let transition = Transition(fromLocation: fromLocation, toLocation: toLocation, fromColor: fromColor, toColor: toColor)
				transitions.append(transition)
			}
		}
	}

	func transition(forPercent percent: CGFloat, transitions: [Transition]) -> Transition? {
		let filtered = transitions.filter { percent >= $0.fromLocation && percent < $0.toLocation }
		let defaultTransition = percent <= 0.5 ? transitions.first : transitions.last
		return filtered.first ?? defaultTransition
	}

	static func convert(percent: CGFloat, fromMin oldMin: CGFloat, max oldMax: CGFloat, toMin newMin: CGFloat, max newMax: CGFloat) -> CGFloat {
		let oldRange, newRange, newValue: CGFloat
		oldRange = (oldMax - oldMin)
		if oldRange == 0.0 {
			newValue = newMin
		} else {
			newRange = newMax - newMin
			newValue = (((percent - oldMin) * newRange) / oldRange) + newMin
		}
		return newValue
	}

	func convert(angle: CGFloat, fromZeroToMax oldMax: CGFloat, toZeroToMax newMax: CGFloat) -> CGFloat {
		return (angle * newMax) / oldMax
	}
}
