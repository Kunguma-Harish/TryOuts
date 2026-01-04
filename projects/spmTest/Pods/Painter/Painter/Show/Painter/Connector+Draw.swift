//
//  Connector+Draw.swift
//  Painter
//
//  Created by lakshman-7016 on 16/08/18.
//  Copyright © 2018 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Connector {
	var frame: CGRect {
		get {
			return props.transform.rect
		}
		set {
			props.transform.rect = newValue
		}
	}

	func draw(
		in ctx: RenderingContext,
		withGroupProps gprops: Properties?,
		using config: PainterConfig?,
		matrix: OrientationMatrices,
		shapeOrientation: ShapeOrientation,
		shouldDrawShadowAsImage: Bool = false) {
		props.draw(
			in: ctx,
			withGroupProps: gprops,
			using: config,
			forId: nvOprops.nvDprops.id,
			matrix: matrix,
			shapeOrientation: shapeOrientation,
			shouldDrawShadowAsImage: shouldDrawShadowAsImage)
	}

	func drawableContentFrame(config: PainterConfig?) -> CGRect {
		return refreshFrame(parentId: nil, painterConfig: config, shouldCache: false, gprops: nil, matrix: .identity)
	}
}
