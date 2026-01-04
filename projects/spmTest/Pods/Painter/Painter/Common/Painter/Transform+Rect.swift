//
//  Transform+Rect.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public struct OrientationMatrices {
	public var scaleAndTranslateMatrix: CGAffineTransform = .identity
	public var rotationAndFlipMatrix: CGAffineTransform = .identity

	public static let identity = OrientationMatrices(.identity, .identity)

	public init() {
		self.scaleAndTranslateMatrix = .identity
		self.rotationAndFlipMatrix = .identity
	}

	public init(_ scaleAndTranslate: CGAffineTransform, _ rotationAndFlip: CGAffineTransform) {
		self.scaleAndTranslateMatrix = scaleAndTranslate
		self.rotationAndFlipMatrix = rotationAndFlip
	}
}

public class ShapeOrientation {
	var consolidatedMatrix: CGAffineTransform
	var finalOrientationMatrix: OrientationMatrices

	var grpRect: CGRect?
	var initialOrientationMatix: OrientationMatrices?

	public init() {
		self.consolidatedMatrix = CGAffineTransform.identity
		self.finalOrientationMatrix = OrientationMatrices()
	}
}

public extension Transform {
	var rect: CGRect {
		get {
			return CGRect(x: pos.left, y: pos.top, width: dim.width, height: dim.height)
		}
		set {
			pos.left = Float(newValue.origin.x)
			pos.top = Float(newValue.origin.y)
			dim.width = Float(newValue.size.width)
			dim.height = Float(newValue.size.height)
		}
	}

	var chRect: CGRect {
		get {
			return CGRect(x: chPos.left, y: chPos.top, width: chDim.width, height: chDim.height)
		}
		set {
			chPos.left = Float(newValue.origin.x)
			chPos.top = Float(newValue.origin.y)
			chDim.width = Float(newValue.size.width)
			chDim.height = Float(newValue.size.height)
		}
	}

	var rotatedFrame: CGRect {
		let rect = self.rect
		return rect.rotateAtCenter(byDegree: CGFloat(rotAngle))
	}

	var rotationAndFlipMatrix: CGAffineTransform {
		let mFrame = self.rect
		let rotation = rotationAngle
		var rotateFlipMatrix = CGAffineTransform.identity

		if rotation != 0 {
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: mFrame.center.x, y: mFrame.center.y)
			rotateFlipMatrix = rotateFlipMatrix.rotated(by: .pi * CGFloat(-rotation) / 180.0)
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: -mFrame.center.x, y: -mFrame.center.y)
		}
		if fliph {
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: mFrame.size.width, y: 0)
			rotateFlipMatrix = rotateFlipMatrix.scaledBy(x: -1, y: 1)
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		if flipv {
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: 0, y: mFrame.size.height)
			rotateFlipMatrix = rotateFlipMatrix.scaledBy(x: 1, y: -1)
			rotateFlipMatrix = rotateFlipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		return rotateFlipMatrix
	}

	var flipMatrix: CGAffineTransform {
		let mFrame = self.rect
		var flipMatrix = CGAffineTransform.identity

		if fliph {
			flipMatrix = flipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			flipMatrix = flipMatrix.translatedBy(x: mFrame.size.width, y: 0)
			flipMatrix = flipMatrix.scaledBy(x: -1, y: 1)
			flipMatrix = flipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		if flipv {
			flipMatrix = flipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			flipMatrix = flipMatrix.translatedBy(x: 0, y: mFrame.size.height)
			flipMatrix = flipMatrix.scaledBy(x: 1, y: -1)
			flipMatrix = flipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		return flipMatrix
	}

	func getFlipMatrix(rect: CGRect) -> CGAffineTransform {
		let mFrame = rect
		var flipMatrix = CGAffineTransform.identity

		if fliph {
			flipMatrix = flipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			flipMatrix = flipMatrix.translatedBy(x: mFrame.size.width, y: 0)
			flipMatrix = flipMatrix.scaledBy(x: -1, y: 1)
			flipMatrix = flipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		if flipv {
			flipMatrix = flipMatrix.translatedBy(x: mFrame.origin.x, y: mFrame.origin.y)
			flipMatrix = flipMatrix.translatedBy(x: 0, y: mFrame.size.height)
			flipMatrix = flipMatrix.scaledBy(x: 1, y: -1)
			flipMatrix = flipMatrix.translatedBy(x: -mFrame.origin.x, y: -mFrame.origin.y)
		}
		return flipMatrix
	}

	func getTransformWhenMovingInsideGroupShape(gtrans: Transform) -> Transform {
		assert(gtrans.hasChDim && gtrans.hasChPos, "can't calculate without chDim and chPos")
		let (x, y): (Float, Float)
		let rotation = rotationAngle
		var rw = gtrans.chDim.width == 0 ? 1 : gtrans.dim.width / gtrans.chDim.width
		var rh = gtrans.chDim.height == 0 ? 1 : gtrans.dim.height / gtrans.chDim.height

		if (rotation > 44 && rotation < 135) || (rotation > 224 && rotation < 315) {
			swap(&rw, &rh)
			let (originalWidth, originalHeight) = (dim.width / rw, dim.height / rh)
			let (currentWidth, currentHeight) = (dim.width, dim.height)

			let (cx, cy) = (currentWidth * 0.5, currentHeight * 0.5)
			let (cxx, cyy) = (originalWidth * 0.5, originalHeight * 0.5)

			let current_unrotated = getRotatedValue(angle: rotation, x: 0, y: 0, cX: cx, cY: cy)
			let original_unrotated = getRotatedValue(angle: rotation, x: 0, y: 0, cX: cxx, cY: cyy)

			x = ((self.pos.left + Float(current_unrotated.x)) - gtrans.pos.left) / rh - Float(original_unrotated.x) + gtrans.chPos.left
			y = ((self.pos.top + Float(current_unrotated.y)) - gtrans.pos.top) / rw - Float(original_unrotated.y) + gtrans.chPos.top
		} else {
			x = ((pos.left - gtrans.pos.left) / rw) + gtrans.chPos.left
			y = ((pos.top - gtrans.pos.top) / rh) + gtrans.chPos.top
		}

		var trans = self
		trans.rect = CGRect(x: x, y: y, width: dim.width / rw, height: dim.height / rh)
		return trans
	}

	func getEndTranformWhenMovingInsideGroupShape(gtrans: Transform) -> Transform {
		var mtrans = self

		// Modifying rotation
		mtrans.rotationAngle -= gtrans.rotationAngle
		mtrans.rotationAngle = mtrans.rotationAngle.truncatingRemainder(dividingBy: 360.0)
		let anchorPoint = gtrans.rect.center
		let oldOrigin = mtrans.rect.origin
		let oldCenter = mtrans.rect.center
		let angleDiff = -CGFloat(gtrans.rotationAngle)
		let newCenter = oldCenter.rotate(around: anchorPoint, byDegree: angleDiff)
		var newOrigin = oldOrigin.rotate(around: anchorPoint, byDegree: angleDiff)
		newOrigin = newOrigin.rotate(around: newCenter, byDegree: -angleDiff)
		mtrans.rect.origin = newOrigin

		// Modifying flips
		if gtrans.fliph {
			mtrans.fliph.toggle() // Logical xor
			mtrans.pos.left = gtrans.pos.left + (gtrans.pos.left + gtrans.dim.width) - mtrans.pos.left - mtrans.dim.width
			mtrans.rotationAngle *= -1
		}
		if gtrans.flipv {
			mtrans.flipv.toggle() // Logical xor
			mtrans.pos.top = gtrans.pos.top + (gtrans.pos.top + gtrans.dim.height) - mtrans.pos.top - mtrans.dim.height
			mtrans.rotationAngle *= -1
		}
		return mtrans.getTransformWhenMovingInsideGroupShape(gtrans: gtrans)
	}

	func getModifiedTransform(group gtrans: Transform?, using config: PainterConfig?) -> Transform {
		if let gtrans = gtrans {
			let transHash = String(hashValue) + String(gtrans.hashValue)
			if let trans = config?.cache?.getModifiedTransformMap(for: transHash) {
				return trans
			} else {
				assert(gtrans.hasChDim && gtrans.hasChPos, "can't calculate without chDim and chPos")
				let (x, y): (Float, Float)
				let rotation = positiveRotationAngle
				var rw = (gtrans.chDim.width == 0) ? 1 : (gtrans.dim.width / gtrans.chDim.width)
				var rh = (gtrans.chDim.height == 0) ? 1 : (gtrans.dim.height / gtrans.chDim.height)

				if (rotation > 44 && rotation < 135) || (rotation > 224 && rotation < 315) {
					swap(&rw, &rh)
					let (originalWidth, originalHeight) = (dim.width, dim.height)
					let (currentWidth, currentHeight) = (originalWidth * rw, originalHeight * rh)

					let (cx, cy) = (currentWidth * 0.5, currentHeight * 0.5)
					let (cxx, cyy) = (originalWidth * 0.5, originalHeight * 0.5)

					let current_unrotated = getRotatedValue(angle: rotation, x: 0, y: 0, cX: cx, cY: cy)
					let original_unrotated = getRotatedValue(angle: rotation, x: 0, y: 0, cX: cxx, cY: cyy)

					x = (((pos.left + Float(original_unrotated.x)) - gtrans.chPos.left) * rh) - Float(current_unrotated.x) + gtrans.pos.left
					y = (((pos.top + Float(original_unrotated.y)) - gtrans.chPos.top) * rw) - Float(current_unrotated.y) + gtrans.pos.top
				} else {
					x = ((pos.left - gtrans.chPos.left) * rw) + gtrans.pos.left
					y = ((pos.top - gtrans.chPos.top) * rh) + gtrans.pos.top
				}

				var trans = self
				trans.rect = CGRect(x: x, y: y, width: dim.width * rw, height: dim.height * rh)
				config?.cache?.setModifiedTransformMap(for: transHash, value: trans)
				return trans
			}
		} else {
			return self
		}
	}

	func getEndTranformWhenMovingOutsideGroupShape(gtrans: Transform?, using config: PainterConfig?) -> Transform {
		var mtrans = self.getModifiedTransform(group: gtrans, using: config)
		if let gtrans = gtrans {
			// Modifying flips
			if gtrans.fliph {
				mtrans.rotationAngle *= -1
				mtrans.fliph.toggle() // Logical xor
				mtrans.pos.left = gtrans.pos.left + ((gtrans.pos.left + gtrans.dim.width) - (mtrans.pos.left + mtrans.dim.width))
			}
			if gtrans.flipv {
				mtrans.rotationAngle *= -1
				mtrans.flipv.toggle() // Logical xor
				mtrans.pos.top = gtrans.pos.top + ((gtrans.pos.top + gtrans.dim.height) - (mtrans.pos.top + mtrans.dim.height))
			}

			// Modifying rotation
			mtrans.rotationAngle += gtrans.rotationAngle
			mtrans.rotationAngle = mtrans.rotationAngle.truncatingRemainder(dividingBy: 360.0)
			let anchorPoint = gtrans.rect.center
			let oldOrigin = mtrans.rect.origin
			let oldCenter = mtrans.rect.center
			let angleDiff = CGFloat(gtrans.rotationAngle)
			let newCenter = oldCenter.rotate(around: anchorPoint, byDegree: angleDiff)
			var newOrigin = oldOrigin.rotate(around: anchorPoint, byDegree: angleDiff)
			newOrigin = newOrigin.rotate(around: newCenter, byDegree: -angleDiff)
			mtrans.rect.origin = newOrigin
		}
		return mtrans
	}

	func applyRotateAndFlip(on ctx: RenderingContext) {
		self.applyRotate(on: ctx)
		self.applyFlip(on: ctx)
	}

	func applyRotate(on ctx: RenderingContext) {
		if hasRotationAngle {
			let frame = self.rect
			let rotation = rotationAngle

			if rotation != 0 {
				ctx.cgContext.translateBy(x: frame.center.x, y: frame.center.y)
				ctx.cgContext.rotate(by: .pi * CGFloat(rotation) / 180.0)
				ctx.cgContext.translateBy(x: -frame.center.x, y: -frame.center.y)
			}
		}
	}

	func applyFlip(on ctx: RenderingContext) {
		if flipv || fliph {
			let frame = self.rect
			if fliph {
				ctx.cgContext.translateBy(x: frame.origin.x, y: frame.origin.y)
				ctx.cgContext.translateBy(x: frame.size.width, y: 0)
				ctx.cgContext.scaleBy(x: -1, y: 1)
				ctx.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
			}
			if flipv {
				ctx.cgContext.translateBy(x: frame.origin.x, y: frame.origin.y)
				ctx.cgContext.translateBy(x: 0, y: frame.size.height)
				ctx.cgContext.scaleBy(x: 1, y: -1)
				ctx.cgContext.translateBy(x: -frame.origin.x, y: -frame.origin.y)
			}
		}
	}

	func getRotationFlipMatrix(rect: CGRect, fliph: Bool, flipv: Bool, rotation: CGFloat) -> CGAffineTransform {
		let center = CGPoint(x: rect.midX, y: rect.midY)
		var rotation = rotation
		if flipv || fliph, !(flipv && fliph) {
			rotation = 360 - rotation
			rotation = getPositiveAngle(rotation)
		}
		var rotationConsolidated = CGAffineTransform.identity
		if rotation != 0.0 {
			let rotationMatrix1 = CGAffineTransform(translationX: -center.x, y: -center.y)
			let rotationMatrix2 = CGAffineTransform(rotationAngle: .pi * rotation / 180.0)
			let rotationMatrix3 = CGAffineTransform(translationX: center.x, y: center.y)
			rotationConsolidated = rotationMatrix1.concatenating(rotationMatrix2).concatenating(rotationMatrix3)
		}

		var flipvMatrix = CGAffineTransform.identity
		if flipv {
			flipvMatrix = CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y)
			flipvMatrix = flipvMatrix.translatedBy(x: 0, y: rect.height)
			flipvMatrix = flipvMatrix.scaledBy(x: 1, y: -1)
			flipvMatrix = flipvMatrix.translatedBy(x: -rect.origin.x, y: -rect.origin.y)
		}

		var fliphMatrix = CGAffineTransform.identity
		if fliph {
			fliphMatrix = CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y)
			fliphMatrix = fliphMatrix.translatedBy(x: rect.width, y: 0)
			fliphMatrix = fliphMatrix.scaledBy(x: -1, y: 1)
			fliphMatrix = fliphMatrix.translatedBy(x: -rect.origin.x, y: -rect.origin.y)
		}

		let rotationFlipMatrix = rotationConsolidated.concatenating(flipvMatrix).concatenating(fliphMatrix)

		return rotationFlipMatrix
	}

	func getScaleTranslateMatrix(gRect: CGRect, chRect: CGRect, rect: CGRect, rotation: CGFloat, discardScaling: Bool) -> CGAffineTransform {
		var sx = chRect.width == 0 ? 1 : gRect.width / chRect.width
		var sy = chRect.height == 0 ? 1 : gRect.height / chRect.height

		var tx = (rect.origin.x - chRect.origin.x) * sx + gRect.origin.x
		var ty = (rect.origin.y - chRect.origin.y) * sy + gRect.origin.y

		if (rotation > 44 && rotation < 135) || (rotation > 224 && rotation < 315) {
			swap(&sx, &sy)
			let (originalWidth, originalHeight) = (rect.width, rect.height)
			let (currentWidth, currentHeight) = (originalWidth * sx, originalHeight * sy)

			let c = CGPoint(x: currentWidth * 0.5, y: currentHeight * 0.5)
			let cc = CGPoint(x: originalWidth * 0.5, y: originalHeight * 0.5)

			let current_unrotated = getRotatedValue(angle: rotation, point: CGPoint.zero, center: c)
			let original_unrotated = getRotatedValue(angle: rotation, point: CGPoint.zero, center: cc)

			tx = (((rect.origin.x + original_unrotated.x) - chRect.origin.x) * sy) - current_unrotated.x + gRect.origin.x
			ty = (((rect.origin.y + original_unrotated.y) - chRect.origin.y) * sx) - current_unrotated.y + gRect.origin.y
		}

		let translateToOriginMatrix = CGAffineTransform(translationX: -rect.origin.x, y: -rect.origin.y)
		let scaleMatrix = discardScaling ? .identity : CGAffineTransform(scaleX: sx, y: sy)
		let translateMatrix = CGAffineTransform(translationX: tx, y: ty)

		let scaleTranslateMatrix = translateToOriginMatrix.concatenating(scaleMatrix).concatenating(translateMatrix)

		return scaleTranslateMatrix
	}

	func getMatrix(_ parentMatrix: OrientationMatrices, gTrans: Transform?, discardScaling: Bool = false) -> OrientationMatrices {
		var orientationMatrix: OrientationMatrices = parentMatrix
		if let gTrans = gTrans {
			let gRect = gTrans.rect
			let chRect = gTrans.chRect
			let rect = self.rect

			// MARK: - Unused

//			let groupRotation = CGFloat(gTrans.rotationAngle)
			let childRotation = CGFloat(self.positiveRotationAngle)
			let scaledAndTranslatedGRect = gRect.applying(parentMatrix.scaleAndTranslateMatrix)
			let scaleTranslateMatrix = self.getScaleTranslateMatrix(gRect: scaledAndTranslatedGRect, chRect: chRect, rect: rect, rotation: childRotation, discardScaling: discardScaling)

			orientationMatrix = OrientationMatrices(scaleTranslateMatrix, parentMatrix.rotationAndFlipMatrix)
		}
		let childRotation = CGFloat(self.rotationAngle)
		let shapeTranslatedRect = self.rect.applying(orientationMatrix.scaleAndTranslateMatrix)
		let rotationFlipShapeMatrix = self.getRotationFlipMatrix(rect: shapeTranslatedRect, fliph: self.fliph, flipv: self.flipv, rotation: childRotation)
		return OrientationMatrices(orientationMatrix.scaleAndTranslateMatrix, rotationFlipShapeMatrix.concatenating(orientationMatrix.rotationAndFlipMatrix))
	}
}

private extension Transform {
	// to change negative angle to positive
	var positiveRotationAngle: Float {
		var rotation = rotationAngle
		rotation += 360
		rotation = rotation.truncatingRemainder(dividingBy: 360)
		return rotation
	}

	func getRotatedValue(angle: Float, x: Float, y: Float, cX: Float, cY: Float) -> CGPoint {
		let radAngle = .pi * angle / 180.0
		let a = cosf(radAngle)
		let c = -1 * sinf(radAngle)
		let b = sinf(radAngle)
		let d = cosf(radAngle)
		let e = (cY * b) - (cX * d) + cX
		let f = cY - (cX * b) - (cY * d)
		let finX = ((x * a) + (y * c) + e)
		let finY = ((x * b) + (y * d) + f)

		return CGPoint(finX, finY)
	}

	func getRotatedValue(angle: CGFloat, point: CGPoint, center: CGPoint) -> CGPoint {
		var rotationConsolidated = CGAffineTransform.identity
		if angle != 0.0 {
			let rotationMatrix1 = CGAffineTransform(translationX: -center.x, y: -center.y)
			let rotationMatrix2 = CGAffineTransform(rotationAngle: .pi * angle / 180.0)
			let rotationMatrix3 = CGAffineTransform(translationX: center.x, y: center.y)
			rotationConsolidated = rotationMatrix1.concatenating(rotationMatrix2).concatenating(rotationMatrix3)
		}

		return point.applying(rotationConsolidated)
	}

	func applyRotate(onContext ctx: RenderingContext) {
		let frame = self.rect
		let rotation = rotationAngle
		if rotation != 0 {
			ctx.cgContext.translateBy(x: frame.center.x, y: frame.center.y)
			ctx.cgContext.rotate(by: .pi * CGFloat(rotation) / 180.0)
			ctx.cgContext.translateBy(x: -frame.center.x, y: -frame.center.y)
		}
	}

	func applyChPosChange(onContext ctx: RenderingContext) {
		// TODO: - instead of saveGState and restoreGState, is it efficient to retranslate context?
		let tx = pos.left - chPos.left
		let ty = pos.top - chPos.top
		if tx != 0 || ty != 0 {
			ctx.cgContext.translateBy(x: CGFloat(tx), y: CGFloat(ty))
		}
	}
}
