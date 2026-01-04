//
//  CGPath+PathElements.swift
//  Painter
//
//  Created by Sarath Kumar G on 26/02/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics

public extension CGPath {
	func getPathElementsPointsAndTypes() -> ([CGPoint], [CGPathElementType]) {
		var arrayPoints: [CGPoint]! = [CGPoint]()
		var arrayTypes: [CGPathElementType]! = [CGPathElementType]()
		self.forEach { element in
			switch element.type {
			case CGPathElementType.moveToPoint:
				arrayPoints.append(element.points[0])
				arrayTypes.append(element.type)
			case .addLineToPoint:
				arrayPoints.append(element.points[0])
				arrayTypes.append(element.type)
			case .addQuadCurveToPoint:
				arrayPoints.append(element.points[0])
				arrayPoints.append(element.points[1])
				arrayTypes.append(element.type)
				arrayTypes.append(element.type)
			case .addCurveToPoint:
				arrayPoints.append(element.points[0])
				arrayPoints.append(element.points[1])
				arrayPoints.append(element.points[2])
				arrayTypes.append(element.type)
				arrayTypes.append(element.type)
				arrayTypes.append(element.type)
			default:
				break
			}
		}
		return (arrayPoints, arrayTypes)
	}

	func rotateBy(angle: CGFloat, rect: CGRect) -> CGPath {
		if !rect.isValid {
			return self
		}
		var trans = CGAffineTransform.identity
		trans = trans.translatedBy(x: rect.origin.x, y: rect.midY)
		trans = trans.rotated(by: angle)
		trans = trans.translatedBy(x: -rect.origin.x, y: -rect.midY)
		guard let apath = copy(using: &trans) else {
			assertionFailure("CGPath translate error")
			exit(1)
		}
		return apath
	}

	func rotateAboutCenter(angle: CGFloat, rect: CGRect) -> CGPath {
		if !rect.isValid {
			return self
		}
		var trans = CGAffineTransform.identity
		trans = trans.translatedBy(x: rect.midX, y: rect.midY)
		trans = trans.rotated(by: angle)
		trans = trans.translatedBy(x: -rect.midX, y: -rect.midY)
		guard let apath = copy(using: &trans) else {
			assertionFailure("CGPath translate error")
			exit(1)
		}
		return apath
	}

	func scaled(for rect: CGRect) -> CGPath {
		let bBox = self.boundingBox
		var scaleX: CGFloat = 1
		if rect.width != 0, bBox.width != 0 {
			scaleX = rect.width / self.boundingBox.width
		}
		var scaleY: CGFloat = 1
		if rect.height != 0, bBox.height != 0 {
			scaleY = rect.height / self.boundingBox.height
		}
		var scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
		return self.copy(using: &scaleTransform) ?? self
	}
}
