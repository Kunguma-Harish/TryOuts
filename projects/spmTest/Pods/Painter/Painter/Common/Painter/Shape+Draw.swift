//
//  Shape+Draw.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 25/10/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension Shape {
	var frame: CGRect {
		get {
			return props.transform.rect
		}
		set {
			props.transform.rect = newValue
		}
	}

	var isMultiPathPreset: Bool {
		return self.hasProps &&
			self.props.hasGeom &&
			self.props.geom.type == .preset &&
			PainterConfig.multiPathPresets.contains(self.props.geom.preset.type)
	}

	func drawableContentFrame(config: PainterConfig?, matrix: OrientationMatrices = .identity, gprops: Properties? = nil) -> CGRect {
		return refreshFrame(parentId: nil, config: config, shouldCache: true, matrix: matrix, gprops: gprops)
	}
}
