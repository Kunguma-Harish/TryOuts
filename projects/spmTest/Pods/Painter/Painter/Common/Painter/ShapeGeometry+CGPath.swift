//
//  ShapeGeometry+CGPath.swift
//  Painter
//
//  Created by Jaganraj Palanivel on 01/11/17.
//  Copyright © 2017 Zoho Corporation Pvt. Ltd. All rights reserved.
//

import CoreGraphics
import Foundation
import Proto

public extension ShapeGeometry {
	func cgpath(id: String, stroke: Stroke? = nil, frame: CGRect? = nil, config: PainterConfig?) -> CGPath {
		if let path = config?.cache?.getRawGeomPathMap(for: id) {
			return path
		}
		let path = shapePath(with: stroke, forRect: frame)
		config?.cache?.setRawGeomPathMap(for: id, value: path)
		return path
	}

	func patternCgPath(rect: CGRect, stroke: Stroke? = nil) -> CGPath {
		return shapePath(with: stroke, forRect: rect, isPattern: true)
	}
}
