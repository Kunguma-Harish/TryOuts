//
//  PerformAnimation+Helpers.swift
//  Painter
//
//  Created by Pravin Palaniappan on 02/01/19.
//  Copyright © 2019 Zoho Corporation Pvt. Ltd. All rights reserved.
//

#if !os(watchOS)
import Proto
import QuartzCore

public extension PerformAnimation {
	func prepareAnimation(data: CoreAnimation) -> [CAAnimation] {
		if data.custom.atStart.transform.hasDim || data.custom.byEnd.transform.hasDim {
			return scaleAniamtion(data: data)
		} else if data.custom.atStart.hasStroke || data.custom.byEnd.hasStroke {
			if data.custom.atStart.stroke.hasFill || data.custom.byEnd.stroke.hasFill {
				return createStrokeFillAnimation(data: data)
			}
		} else {
			self.prepareAnimation()
		}
		return self.groupAnimation
	}
}

private extension PerformAnimation {
	func scaleAniamtion(data: CoreAnimation) -> [CAAnimation] {
		let xScale = CABasicAnimation(keyPath: "transform.scale.x")
		let yScale = CABasicAnimation(keyPath: "transform.scale.y")
		if data.custom.atStart.transform.hasDim {
			let dimension = data.custom.atStart.transform.dim
			if dimension.hasWidth {
				xScale.fromValue = dimension.width
			}
			if dimension.hasHeight {
				yScale.fromValue = dimension.height
			}
		}
		if data.custom.byEnd.transform.hasDim {
			let dimension = data.custom.byEnd.transform.dim
			if dimension.hasWidth {
				xScale.toValue = Double(dimension.width)
			}
			if dimension.hasHeight {
				yScale.toValue = Double(dimension.height)
			}
		}

		return [xScale, yScale]
	}

	func createStrokeFillAnimation(data: CoreAnimation) -> [CAAnimation] {
		let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
		if data.custom.hasAtStart {
			colorAnimation.fromValue = data.custom.atStart.stroke.fill.solid.color.cgColor
		}
		if data.custom.hasByEnd {
			colorAnimation.toValue = data.custom.byEnd.stroke.fill.solid.color.cgColor
		}
		return [colorAnimation]
	}
}
#endif
